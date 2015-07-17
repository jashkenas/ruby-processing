# Ruby-Processing is for Code Art.
# Send suggestions, ideas, and hate-mail to jashkenas [at] gmail.com
# Also, send samples and libraries.
unless defined? RP5_ROOT
  $LOAD_PATH << File.expand_path(File.dirname(__FILE__))
  RP5_ROOT = File.expand_path(File.dirname(__FILE__) + '/../')
end

SKETCH_ROOT ||= Dir.pwd

require 'ruby-processing/version'
require 'ruby-processing/helpers/numeric'
require 'ruby-processing/helpers/range'

# The top-level namespace, a home for all Ruby-Processing classes.
module Processing
  require 'ruby-processing/runner'   
end
