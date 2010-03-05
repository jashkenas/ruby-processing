require 'ostruct'
require 'fileutils'

module Processing

  # Utility class to handle the different commands that the 'rp5' command
  # offers. Able to run, watch, live, create, app, applet, and unpack
  class Runner

    HELP_MESSAGE = <<-EOS

  Ruby-Processing is a little shim between Processing and JRuby that helps
  you create sketches of code art.

  Usage:
    rp5 [run | watch | live | create | app | applet | unpack] path/to/sketch

  Examples:
    rp5 unpack samples
    rp5 run samples/jwishy.rb
    rp5 create some_new_sketch --bare 640 480
    rp5 watch some_new_sketch.rb
    rp5 applet some_new_sketch.rb

  Everything Else:
    http://wiki.github.com/jashkenas/ruby-processing

      EOS

    # Start running a ruby-processing sketch from the passed-in arguments
    def self.execute
      runner = new
      runner.parse_options(ARGV)
      runner.execute!
    end

    # Dispatch central.
    def execute!
      case @options.action
      when 'run'    then run(@options.path, @options.args)
      when 'watch'  then watch(@options.path, @options.args)
      when 'live'   then live(@options.path, @options.args)
      when 'create' then create(@options.path, @options.args, @options.bare)
      when 'app'    then app(@options.path)
      when 'applet' then applet(@options.path)
      when 'unpack' then unpack(@options.path)
      when /-v/     then show_version
      when /-h/     then show_help
      else
        show_help
      end
    end

    # Parse the command-line options. Keep it simple.
    def parse_options(args)
      @options = OpenStruct.new
      @options.bare   = !!args.delete('--bare')
      @options.jruby  = !!args.delete('--jruby')
      @options.action = args[0]     || nil
      @options.path   = args[1]     || File.basename(Dir.pwd + '.rb')
      @options.args   = args[2..-1] || []
    end

    # Create a fresh Ruby-Processing sketch, with the necessary
    # boilerplate filled out.
    def create(sketch, args, bare)
      Processing::Creator.new.create!(sketch, args, bare)
    end

    # Just simply run a ruby-processing sketch.
    def run(sketch, args)
      ensure_exists(sketch)
      spin_up('run.rb', sketch, args)
    end

    # Run a sketch, keeping an eye on it's file, and reloading
    # whenever it changes.
    def watch(sketch, args)
      ensure_exists(sketch)
      spin_up('watch.rb', sketch, args)
    end

    # Run a sketch, opening its guts to IRB, letting you play with it.
    def live(sketch, args)
      ensure_exists(sketch)
      spin_up('live.rb', sketch, args)
    end

    # Generate a cross-platform application of a given Ruby-Processing sketch.
    def app(sketch)
      Processing::ApplicationExporter.new.export!(sketch)
    end

    # Generate an applet and HTML page for a given sketch.
    def applet(sketch)
      Processing::AppletExporter.new.export!(sketch)
    end

    # Install the included samples to a given path, where you can run and
    # alter them to your heart's content.
    def unpack(dir)
      require 'fileutils'
      usage = "Usage: rp5 unpack [samples | library]"
      puts usage and return unless dir.match(/\A(samples|library)\Z/)
      FileUtils.cp_r("#{RP5_ROOT}/#{dir}", "#{Dir.pwd}/#{dir}")
    end

    # Display the current version of Ruby-Processing.
    def show_version
      puts "Ruby-Processing version #{Processing::VERSION}"
    end

    # Show the standard help/usage message.
    def show_help
      puts HELP_MESSAGE
    end


    private

    # Trade in this Ruby instance for a JRuby instance, loading in a
    # starter script and passing it some arguments.
    # If --jruby is passed, use the installed version of jruby, instead of
    # our vendored jarred one (useful for gems).
    def spin_up(starter_script, sketch, args)
      runner = "#{RP5_ROOT}/lib/ruby-processing/runners/#{starter_script}"
      java_args = discover_java_args(sketch)
      command = @options.jruby ?
                ['jruby', java_args, runner, sketch, args].flatten :
                ['java', java_args, '-cp', jruby_complete, 'org.jruby.Main', runner, sketch, args].flatten
      exec *command
      # exec replaces the Ruby process with the JRuby one.
    end

    # If you need to pass in arguments to Java, such as the ones on this page:
    # http://java.sun.com/j2se/1.4.2/docs/tooldocs/windows/java.html
    # then type them into a java_args.txt in your data directory next to your sketch.
    def discover_java_args(sketch)
      arg_file = "#{File.dirname(sketch)}/data/java_args.txt"
      args = dock_icon
      args += File.read(arg_file).split(/\s+/) if File.exists?(arg_file)
      args.map! {|arg| "-J#{arg}" }            if @options.jruby
      args
    end

    def ensure_exists(sketch)
      puts "Couldn't find: #{sketch}" and exit unless File.exists?(sketch)
    end

    def jruby_complete
      File.join(RP5_ROOT, 'lib/core/jruby-complete.jar')
    end

    # On the Mac, we can display a fat, shiny ruby in the Dock.
    def dock_icon
      mac = RUBY_PLATFORM.match(/darwin/i) || (RUBY_PLATFORM == 'java' && ENV_JAVA['os.name'].match(/mac/i))
      mac ? ["-Xdock:name=Ruby-Processing", "-Xdock:icon=#{RP5_ROOT}/lib/templates/application/Contents/Resources/sketch.icns"] : []
    end

  end # class Runner

end # module Processing
