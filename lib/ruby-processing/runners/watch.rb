require "#{File.dirname(__FILE__)}/base.rb"

module Processing

  # A sketch loader, observer, and reloader, to tighten
  # the feedback between code and effect.
  class Watcher

    # Sic a new Processing::Watcher on the sketch
    def initialize
      @files = ([SKETCH_PATH] + Dir.glob(File.dirname(SKETCH_PATH) + "/*.rb")).uniq
      @time = Time.now
      start_watching
    end


    # Kicks off a thread to watch the sketch, reloading Ruby-Processing
    # and restarting the sketch whenever it changes.
    def start_watching
      start_runner
      loop do
        if @files.detect { |file| File.exists?(file) && File.stat(file).mtime > @time }
          puts "reloading sketch..."
          $app.close
          @time = Time.now
          GC.start
          start_runner
        end
        sleep 0.33
      end
    end

    # Convenience function to report errors when loading and running a sketch,
    # instead of having them eaten by the thread they are loaded in.
    def report_errors
      yield
    rescue Exception => e
      puts "Exception occured while running sketch #{File.basename SKETCH_PATH}:"
      puts e.to_s
      puts e.backtrace.join("\n")
    end

    def start_runner 
      @runner.kill if @runner && @runner.alive?
      @runner = Thread.start do 
        report_errors do 
          Processing.load_and_run_sketch
        end
      end
    end
  end
end

Processing::Watcher.new
