# Ruby-Processing is for Code Art.
# Send suggestions, ideas, and hate-mail to jashkenas [at] gmail.com
# Also, send samples and libraries.

unless defined? RP5_ROOT
  $LOAD_PATH << File.expand_path(File.dirname(__FILE__))
  RP5_ROOT = File.expand_path(File.dirname(__FILE__) + "/../")
end

module Processing
  VERSION = [1,1]
  
  def self.version
    VERSION.join('.')
  end
  
  autoload :App,      'ruby-processing/app'
  autoload :Runner,   'ruby-processing/runner'
end