require "#{File.dirname(__FILE__)}/base.rb"

module Processing  
  
  # A sketch loader, observer, and reloader, to tighten 
  # the feedback between code and effect.
  class Watcher
    
    # Sic a new Processing::Watcher on a given sketch.
    def initialize(sketch)
      @file = sketch
      @time = Time.now
      record_state_of_ruby
      load @file
      start_watching
    end
    
    
    # Kicks off a thread to watch the sketch, reloading Ruby-Processing
    # and restarting the sketch whenever it changes.
    def start_watching
      thread = Thread.start do
        loop do
          file_mtime = File.stat(@file).mtime
          if file_mtime > @time
            @time = file_mtime
            Processing::App.wipe_out_current_app!
            rewind_to_recorded_state
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
    
    
    # Do the best we can to take a picture of the current Ruby interpreter.
    # For now, this means top-level constants and loaded .rb files.
    def record_state_of_ruby
      @saved_constants  = Object.send(:constants).dup
      @saved_load_paths = $LOAD_PATH.dup
      @saved_features   = $LOADED_FEATURES.dup
      @saved_globals    = Kernel.global_variables.dup
    end
    
    
    # Try to go back to the recorded Ruby state.
    def rewind_to_recorded_state
      new_constants  = Object.send(:constants).reject {|c| @saved_constants.include?(c) }
      new_load_paths = $LOAD_PATH.reject {|p| @saved_load_paths.include?(p) }
      new_features   = $LOADED_FEATURES.reject {|f| @saved_features.include?(f) }
      new_globals    = Kernel.global_variables.reject {|g| @saved_globals.include?(g) }
      
      new_constants.each {|c| Object.send(:remove_const, c) }
      new_load_paths.each {|p| $LOAD_PATH.delete(p) }
      new_features.each {|f| $LOADED_FEATURES.delete(f) }
      new_globals.each do |g| 
        begin
          eval("#{g} = nil") # There's no way to undef a global variable in Ruby
        rescue NameError => e
          # Some globals are read-only, and we can't set them to nil.
        end
      end
    end
    
  end
end

Processing::Watcher.new(Processing::SKETCH_PATH)
