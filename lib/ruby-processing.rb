# Ruby-Processing is for Code Art.
# Send suggestions, ideas, and hate-mail to jashkenas [at] gmail.com
# Also, send samples and libraries.

require 'java'
require 'fileutils'

$LOAD_PATH << File.expand_path(File.dirname(__FILE__))

# RUBY_PROCESSING_ROOT = File.expand_path(File.dirname(__FILE__)) unless defined?(RUBY_PROCESSING_ROOT)
# SKETCH_PATH = File.dirname($0) unless defined?(SKETCH_PATH)

module Processing
  VERSION = [1,1]
  
  def self.version
    VERSION.join('.')
  end
  
  autoload :App,      'processing/app'
  autoload :Runner,   'processing/runner'
end