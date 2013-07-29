# Ruby-Processing is for Code Art.
# Send suggestions, ideas, and hate-mail to jashkenas [at] gmail.com
# Also, send samples and libraries.

unless defined? RP5_ROOT
  $LOAD_PATH << File.expand_path(File.dirname(__FILE__))
  RP5_ROOT = File.expand_path(File.dirname(__FILE__) + "/../")
end

SKETCH_ROOT = Dir.pwd unless defined? SKETCH_ROOT

require 'ruby-processing/helpers/string'
require 'ruby-processing/helpers/numeric'

# The top-level namespace, a home for all Ruby-Processing classes.
module Processing
  VERSION = "2.1.1" unless defined? Processing::VERSION
  # Autoload a number of constants that we may end up using.
  autoload :App,                  'ruby-processing/app'
  autoload :Runner,               'ruby-processing/runner'
  autoload :Watcher,              'ruby-processing/runners/watch'
  autoload :Creator,              'ruby-processing/exporters/creator'
  autoload :BaseExporter,         'ruby-processing/exporters/base_exporter'
  autoload :ApplicationExporter,  'ruby-processing/exporters/application_exporter'
end
