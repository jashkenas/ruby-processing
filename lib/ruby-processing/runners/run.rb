# Windows apps start life in the wrong folder.
# TODO: Fix this crud as soon as possible.
if ARGV[1] == '--windows-app'
  ARGV[1] = nil
  Dir.chdir('lib')
  $__windows_app_mode__ = true
end

require "#{File.dirname(__FILE__)}/base.rb"

Processing.load_and_run_sketch