# A sketch loader, observer, and reloader, to tighten 
# the feedback between code and effect.

module Processing
  class SketchObserver
    
    def initialize(file)
      @file = file
      @time = Time.now
      load @file
      start_watching
    end
    
    def start_watching
      thread = Thread.start do
        loop do
          file_mtime = File.stat(@file).mtime
          if file_mtime > @time
            @time = file_mtime
            app = Processing::App.current
            Processing::App.current.close if app
            GC.start
            load @file
          end
          sleep 0.1
        end
      end
      thread.join
    end
    
  end
end

sketch = ARGV[0]
ARGV[0] = nil
Processing::SketchObserver.new(sketch)

