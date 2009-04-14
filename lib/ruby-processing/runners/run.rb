# Windows apps start life in the wrong folder.
# TODO: Fix this crud as soon as possible.
if ARGV[1] == '--windows-app'
  ARGV[1] = nil
  Dir.chdir('lib')
  $__windows_app_mode__ = true
end

# TODO: this is also crud. Windows applets and applications are having serious
# trouble with absolute paths.

if $__windows_app_mode__ || defined?(JRUBY_APPLET)
  require 'ruby-processing/runners/base.rb'
else
  require "#{File.dirname(__FILE__)}/base.rb"
end

Processing.load_and_run_sketch