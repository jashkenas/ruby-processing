# A sketch loader, observer, and reloader, to tighten 
# the feedback between code and effect.

require "#{File.dirname(__FILE__)}/base.rb"

module Processing  
  class Watcher
    
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
            Processing::App.wipe_out_current_app!
            GC.start
            begin
              load @file
            rescue SyntaxError
              print "Syntax Error in your sketch: ", $!, "\n"
            end
          end
          sleep 0.1
        end
      end
      thread.join
    end
    
  end
end

Processing::Watcher.new(Processing::SKETCH_PATH)
