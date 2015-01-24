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
  def self.exported?
    @exported ||= ENV['EXPORTED'].eql?('true')
  end

  # Autoload a number of path/constants that we may end up using.
  # mri ruby does not understand ** require 'java' ** and we may otherwise call
  # it from mri ruby without lazy path loading of autoload
  # NB: autoload is slated for possible removal by ruby-2.2
  autoload :App,                  'ruby-processing/app'
  autoload :Runner,               'ruby-processing/runner'
  autoload :Watcher,              'ruby-processing/runners/watch'
end
