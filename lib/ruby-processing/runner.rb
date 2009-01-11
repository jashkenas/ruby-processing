require 'ostruct'
require 'fileutils'

module Processing
  
  class Runner
    
    # Start running a ruby-processing sketch from the passed-in arguments
    def self.execute
      runner = new
      runner.parse_options(ARGV)
      runner.execute!
    end
    
    def initialize(out_stream = STDOUT, error_stream = STDERR)
      @out_stream, @error_stream = out_stream, error_stream
      @options = OpenStruct.new
    end
    
    def execute!
      case @options.action
      when 'run'    : run(@options.path)
      when 'watch'  : watch(@options.path)
      when 'create' : create(@options.path, @options.args)
      when 'live'   : live(@options.path)
      when 'sample' : sample(@options.path)
      when /-v/     : show_version
      when /-h/     : show_help
      else show_help
      end
    end
    
    # Parse the command-line options. Keep it simple
    def parse_options(args)
      @options.action = args[0]     || 'run'
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
    
    def sample
      
    end
    
    def show_version
      exit_with_success("ruby-processing version #{Processing.version}")
    end
    
    def show_help
      help = <<-EOS
Usage: rp5 [run | watch | live | create | applet | application] path/to/the/sketch
      EOS
      exit_with_success(help)
    end
    
    
    private
    
    def spin_up(starter_script, args)
      runner = "#{RP5_ROOT}/lib/ruby-processing/runners/#{starter_script}"
      command = "java -cp #{jruby_complete} #{dock_icon} org.jruby.Main #{runner} #{args}"
      exec(command)
      # exec replaces the Ruby process with the JRuby one.
    end
    
    def ensure_exists(sketch)
      exit_with_error("Couldn't find: #{sketch}") unless File.exists?(sketch)
    end
    
    def jruby_complete
      File.join(RP5_ROOT, 'lib/core/jruby-complete.jar')
    end
    
    def dock_icon
      mac = RUBY_PLATFORM.match(/darwin/i)
      mac ? "-Xdock:name=Ruby-Processing -Xdock:icon=script/application_files/Contents/Resources/sketch.icns" : ""
    end
    
    def exit_with_success(message)
      @out_stream.puts message
      Kernel.exit(0)
    end
    
    def exit_with_error(message)
      @error_stream.puts message
      Kernel.exit(1)
    end
    
  end # class Runner
  
end # module Processing