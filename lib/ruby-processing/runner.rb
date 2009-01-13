require 'ostruct'
require 'fileutils'

module Processing
  
  # Utility class to handle the different commands that the 'rp5' command
  # offers. Able to run, watch, live, create, app, applet, and unpack_samples
  class Runner
    
    HELP_MESSAGE = <<-EOS
      
  Ruby-Processing is a little shim between Processing and JRuby that helps
  you create sketches of code art.
  
  Usage:
    rp5 [run | watch | live | create | app | applet | unpack_samples] path/to/sketch
    
  Examples:
    rp5 unpack_samples
    rp5 run samples/jwishy.rb
    rp5 create some_new_sketch 640 480
    rp5 watch some_new_sketch.rb
    rp5 applet some_new_sketch.rb
    
  Further information:
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
      when 'run'            : run(@options.path)
      when 'watch'          : watch(@options.path)
      when 'create'         : create(@options.path, @options.args)
      when 'live'           : live(@options.path)
      when 'app'            : app(@options.path)
      when 'applet'         : applet(@options.path)
      when 'unpack_samples' : unpack_samples
      when /-v/             : show_version
      when /-h/             : show_help
      else show_help
      end
    end
    
    # Parse the command-line options. Keep it simple.
    def parse_options(args)
      @options = OpenStruct.new
      @options.action = args[0]     || nil
      @options.path   = args[1]     || File.basename(Dir.pwd + '.rb')
      @options.args   = args[2..-1] || []
    end
    
    # Create a fresh Ruby-Processing sketch, with the necessary
    # boilerplate filled out.
    def create(sketch, args)
      Processing::Creator.new.create!(sketch, args)
    end
    
    # Just simply run a ruby-processing sketch.
    def run(sketch)
      ensure_exists(sketch)
      spin_up('run.rb', sketch)
    end
    
    # Run a sketch, keeping an eye on it's file, and reloading
    # whenever it changes.
    def watch(sketch)
      ensure_exists(sketch)
      spin_up('watch.rb', sketch)
    end
    
    # Run a sketch, opening its guts to IRB, letting you play with it.
    def live(sketch)
      ensure_exists(sketch)
      spin_up('live.rb', sketch)
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
    def unpack_samples
      require 'fileutils'
      FileUtils.cp_r("#{RP5_ROOT}/samples", "#{Dir.pwd}/samples")
    end
    
    # Display the current version of Ruby-Processing.
    def show_version
      puts "Ruby-Processing version #{Processing.version}"
    end
    
    # Show the standard help/usage message.
    def show_help
      puts HELP_MESSAGE
    end
    
    
    private
    
    # Trade in this Ruby instance for a JRuby instance, loading in a 
    # starter script and passing it some arguments.
    def spin_up(starter_script, args)
      runner = "#{RP5_ROOT}/lib/ruby-processing/runners/#{starter_script}"
      command = "java -cp #{jruby_complete} #{dock_icon} org.jruby.Main #{runner} #{args}"
      exec(command)
      # exec replaces the Ruby process with the JRuby one.
    end
    
    def ensure_exists(sketch)
      unless File.exists?(sketch)
        puts "Couldn't find: #{sketch}"
        exit
      end
    end
    
    def jruby_complete
      File.join(RP5_ROOT, 'lib/core/jruby-complete.jar')
    end
    
    # On the Mac, we can display a fat, shiny ruby in the Dock.
    def dock_icon
      mac = RUBY_PLATFORM.match(/darwin/i)
      mac ? "-Xdock:name=Ruby-Processing -Xdock:icon=#{RP5_ROOT}/lib/templates/application/Contents/Resources/sketch.icns" : ""
    end
    
  end # class Runner
  
end # module Processing