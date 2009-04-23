# TODO: this is crud. Windows applets are having serious
# trouble with absolute paths.

root = defined?(JRUBY_APPLET) ? 'ruby-processing/runners' : File.dirname(__FILE__)
require "#{root}/base.rb"

Processing.load_and_run_sketch