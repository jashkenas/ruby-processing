require 'ostruct'
require 'fileutils'
require 'rbconfig'
require_relative '../ruby-processing/config'
require_relative '../ruby-processing/version'

module Processing

  # Utility class to handle the different commands that the 'rp5' command
  # offers. Able to run, watch, live, create, app, and unpack
  class Runner
    HELP_MESSAGE ||= <<-EOS
    Version: #{RubyProcessing::VERSION}

    Ruby-Processing is a little shim between Processing and JRuby that helps
    you create sketches of code art.

    Usage:
    rp5 [choice] path/to/sketch

    choice:-
    run:              run sketch once
    watch:            watch for changes on the file and relaunch it on the fly
    live:                  launch sketch and give an interactive IRB shell
    create [width height][mode][flag]: create a new sketch.
    app:              create an application version of the sketch
    setup:            check setup, install jruby-complete, unpack samples

    Common options:
    --nojruby:  use jruby-complete in place of an installed version of jruby
    (Set [JRUBY: 'false'] in .rp5rc to make using jruby-complete default)

    Examples:
    rp5 setup unpack_samples
    rp5 run rp_samples/samples/contributed/jwishy.rb
    rp5 create some_new_sketch 640 480 p3d (P3D mode example)
    rp5 create some_new_sketch 640 480 --wrap (a class wrapped default sketch)
    rp5 watch some_new_sketch.rb

    Everything Else:
    http://wiki.github.com/jashkenas/ruby-processing

    EOS

    WIN_PATTERNS = [
      /bccwin/i,
      /cygwin/i,
      /djgpp/i,
      /ming/i,
      /mswin/i,
      /wince/i
    ]

    attr_reader :os

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
      when 'create' then create(@options.path, @options.args)
      when 'app'    then app(@options.path)
      when 'setup'  then setup(@options.path)
      when /-v/     then show_version
      when /-h/     then show_help
      else
        show_help
      end
    end

    # Parse the command-line options. Keep it simple.
    def parse_options(args)
      @options = OpenStruct.new
      @options.wrap = !args.delete('--wrap').nil?
      @options.inner = !args.delete('--inner').nil?
      @options.jruby = !args.delete('--jruby').nil?
      @options.nojruby = !args.delete('--nojruby').nil?
      @options.action = args[0] || nil
      @options.path = args[1] || File.basename(Dir.pwd + '.rb')
      @options.args = args[2..-1] || []
    end

    # Create a fresh Ruby-Processing sketch, with the necessary
    # boilerplate filled out.
    def create(sketch, args)
      require_relative '../ruby-processing/exporters/creator'
      return Processing::Inner.new.create!(sketch, args) if @options.inner
      return Processing::ClassSketch.new.create!(sketch, args) if @options.wrap
      Processing::BasicSketch.new.create!(sketch, args)
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
      require_relative '../ruby-processing/exporters/application_exporter'
      Processing::ApplicationExporter.new.export!(sketch)
    end

    def setup(choice)
      proc_root = FileTest.exist?("#{ENV['HOME']}/.rp5rc")
      case choice
      when /check/
        check(proc_root, FileTest.exist?("#{RP5_ROOT}/lib/ruby/jruby-complete.jar"))
      when /install/
        install(proc_root)
      when /unpack_samples/
        system "cd #{RP5_ROOT}/vendors && rake unpack_samples"
      else
        puts 'Usage: rp5 setup [check | install | unpack_samples]'
      end
    end

    def install(root_exist)
      system "cd #{RP5_ROOT}/vendors && rake"
      return if root_exist
      set_processing_root
      warn 'PROCESSING_ROOT set optimistically, run check to confirm'
    end

    def check(root_exist, installed)
      show_version
      root = '  PROCESSING_ROOT = Not Set!!!' unless root_exist
      root ||= "  PROCESSING_ROOT = #{Processing::RP_CONFIG['PROCESSING_ROOT']}"
      jruby = Processing::RP_CONFIG['JRUBY']
      x_off = Processing::RP_CONFIG['X_OFF']
      y_off = Processing::RP_CONFIG['Y_OFF']
      puts root
      puts "  JRUBY = #{jruby}" unless jruby.nil?
      puts "  X_OFF = #{x_off}" unless x_off.nil?
      puts "  Y_OFF = #{y_off}" unless y_off.nil?
      puts "  jruby-complete installed = #{installed}"
    end

    # Display the current version of Ruby-Processing.
    def show_version
      puts "Ruby-Processing version #{RubyProcessing::VERSION}"
    end

    # Show the standard help/usage message.
    def show_help
      puts HELP_MESSAGE
    end

    private
    
    # Trade in this Ruby instance for a JRuby instance, loading in a starter
    # script and passing it some arguments.Unless '--nojruby' is passed, the
    # installed version of jruby is used instead of our vendored jarred one
    # (which is required for some sketches eg shaders and for export). To use
    # jruby-complete by default set JRUBY: false in ~/.rp5rc config
    # (but that will make using other gems in your sketches hard....)
    def spin_up(starter_script, sketch, args)
      runner = "#{RP5_ROOT}/lib/ruby-processing/runners/#{starter_script}"
      warn('The --jruby flag is no longer required') if @options.jruby
      @options.nojruby = true if Processing::RP_CONFIG['JRUBY'] == 'false'
      java_args = discover_java_args(sketch)
      if @options.nojruby 
        command = ['java',
                  java_args,
                  '-cp',
                  jruby_complete,
                  'org.jruby.Main',
                  runner,
                  sketch,
                  args].flatten
      else
        command = ['jruby', 
                  java_args,
                  runner, 
                  sketch, 
                  args].flatten        
      end
      exec(*command)
      # exec replaces the Ruby process with the JRuby one.
    end

    # If you need to pass in arguments to Java, such as the ones on this page:
    # http://docs.oracle.com/javase/1.5.0/docs/tooldocs/windows/java.html
    # add them to a java_args.txt in your data directory next to your sketch.
    def discover_java_args(sketch)
      arg_file = "#{File.dirname(sketch)}/data/java_args.txt"
      args = []
      args += dock_icon
      if FileTest.exist?(arg_file)
        args += File.read(arg_file).split(/\s+/)
      elsif Processing::RP_CONFIG['java_args']
        args += Processing::RP_CONFIG['java_args'].split(/\s+/)
      end
      args.map! { |arg| "-J#{arg}" } unless @options.nojruby
      args
    end
    
    # NB: we really do require 'and' not '&&' to get message returned

    def ensure_exists(sketch)
      puts "Couldn't find: #{sketch}" and exit unless FileTest.exist?(sketch)
    end

    def jruby_complete
      rcomplete = File.join(RP5_ROOT, 'lib/ruby/jruby-complete.jar')
      return rcomplete if FileTest.exist?(rcomplete)
      warn "#{rcomplete} does not exist\nTry running `rp5 setup install`"
      exit
    end

    def host_os
      detect_os = RbConfig::CONFIG['host_os']
      case detect_os
      when /mac|darwin/ then :mac
      when /linux/ then :linux
      when /solaris|bsd/ then :unix
      else
        WIN_PATTERNS.find { |r| detect_os =~ r }
        fail "unknown os: #{detect_os.inspect}" if Regexp.last_match.nil?
        :windows
      end
    end

    # Optimistically set processing root
    def set_processing_root
      require 'psych'
      @os ||= host_os
      data = {}
      path = File.expand_path("#{ENV['HOME']}/.rp5rc")
      if os == :mac
        data['PROCESSING_ROOT'] = '/Applications/Processing.app/Contents/Java'
      else
        root = "#{ENV['HOME']}/processing-2.2.1"
        data['PROCESSING_ROOT'] = root
      end
      data['JRUBY'] = true
      open(path, 'w:UTF-8') { |f| f.write(data.to_yaml) }
    end

    # On the Mac, we can display a fat, shiny ruby in the Dock.
    def dock_icon
      @os ||= host_os
      icon = []
      if os == :mac
        icon << '-Xdock:name=Ruby-Processing'
        icon << "-Xdock:icon=#{RP5_ROOT}/lib/templates/application/Contents/Resources/sketch.icns"
      end
      icon
    end
  end # class Runner
end # module Processing
