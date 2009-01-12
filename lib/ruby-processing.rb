# Ruby-Processing is for Code Art.
# Send suggestions, ideas, and hate-mail to jashkenas [at] gmail.com
# Also, send samples and libraries.

unless defined? RP5_ROOT
  $LOAD_PATH << File.expand_path(File.dirname(__FILE__))
  RP5_ROOT = File.expand_path(File.dirname(__FILE__) + "/../")
end

require 'ruby-processing/helpers/string'

# The top-level namespace, a home for all Ruby-Processing classes.
module Processing
  VERSION = [1,1]
  
  # Returns the current version of Ruby-Processing.
  def self.version
    VERSION.join('.')
  end
  
  autoload :App,                  'ruby-processing/app'
  autoload :Runner,               'ruby-processing/runner'
  autoload :Creator,              'ruby-processing/exporters/creator'
  autoload :BaseExporter,         'ruby-processing/exporters/base_exporter'
  autoload :AppletExporter,       'ruby-processing/exporters/applet_exporter'
  autoload :ApplicationExporter,  'ruby-processing/exporters/application_exporter'
end