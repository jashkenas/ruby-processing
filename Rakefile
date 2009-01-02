require 'rubygems'
require 'rake'
require 'echoe'

Echoe.new('ruby-processing', '1.0.1') do |p|
  p.description = "Code as Art, Art as Code. Processing and Ruby are meant for each other."
  p.url         = "http://github.com/jashkenas/ruby-processing/"
  p.author      = "Jeremy Ashkenas"
  p.email       = "jeremy@ashkenas.com"
  p.ignore_pattern = ["tmp/*"]
  p.development_dependencies = []
end

# Dir["#{File.dirname(__FILE__)}/tasks/*.rake"].sort.each {|ext| load ext }

desc 'Create gemspec for github'
task :gemspec do
  sh "sudo rake manifest"
  sh "sudo rake gem"
end


desc 'Build and install ruby gem.'
task :build do
  sh "sudo rake manifest"
  sh "sudo rake gem"
  sh "sudo rake install"
end

desc 'Remove ruby gem build data.'
task :remove do
  sh "sudo gem uninstall ruby-processing"
end