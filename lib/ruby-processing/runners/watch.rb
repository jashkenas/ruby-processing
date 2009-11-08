require "#{File.dirname(__FILE__)}/base.rb"

module Processing

  # A sketch loader, observer, and reloader, to tighten
  # the feedback between code and effect.
  class Watcher

    # Sic a new Processing::Watcher on the sketch
    def initialize
      @file = SKETCH_PATH
      @time = Time.now
      # Doesn't work well enough for now.
      # record_state_of_ruby
      start_watching
    end


    # Kicks off a thread to watch the sketch, reloading Ruby-Processing
    # and restarting the sketch whenever it changes.
    def start_watching
      @runner = Thread.start { report_errors { Processing.load_and_run_sketch } } unless $app
      thread = Thread.start do
        loop do
          file_mtime = File.stat(@file).mtime
          if file_mtime > @time
            @time = file_mtime
            wipe_out_current_app!
            # Taking it out the reset until it can be made to work more reliably
            # rewind_to_recorded_state
            GC.start
            @runner = Thread.start { report_errors { Processing.load_and_run_sketch } }
          end
          sleep 0.33
        end
      end
      thread.join
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

    # Used to completely remove all traces of the current sketch,
    # so that it can be loaded afresh. Go down into modules to find it, even.
    def wipe_out_current_app!
      @runner.kill if @runner.alive?
      app = $app
      return unless app
      app.no_loop
      # Wait for the animation thread to finish rendering
      sleep 0.075
      app.close
      constant_names = app.class.to_s.split(/::/)
      app_class_name = constant_names.pop
      obj = constant_names.inject(Object) {|o, name| o.send(:const_get, name) }
      obj.send(:remove_const, app_class_name)
    end

    # The following methods were intended to make the watcher clean up all code
    # loaded in from the sketch, gems, etc, and have them be reloaded properly
    # when the sketch is.... but it seems that this is neither a very good idea
    # or a very possible one. If you can make the scheme work, please do,
    # otherwise the following methods will probably be removed soonish.

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

      Processing::App.recursively_remove_constants(Object, new_constants)
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


    # Used to clean up declared constants in code that needs to be reloaded.
    def recursively_remove_constants(base, constant_names)
      constants = constant_names.map {|name| base.const_get(name) }
      constants.each_with_index do |c, i|
        java_obj = Java::JavaLang::Object
        constants[i] = constant_names[i] = nil if c.respond_to?(:ancestors) && c.ancestors.include?(java_obj)
        constants[i] = nil if !c.is_a?(Class) && !c.is_a?(Module)
      end
      constants.each {|c| recursively_remove_constants(c, c.constants) if c }
      constant_names.each {|name| base.send(:remove_const, name.to_sym) if name }
    end

  end
end

Processing::Watcher.new
