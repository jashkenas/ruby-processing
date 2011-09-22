require 'rake'

desc 'Build and install gem'
task :install => :build do
  sh "gem install #{Dir.glob('*.gem').join(' ')} --no-ri --no-rdoc"
end

desc 'Uninstall gem'
task :uninstall do
  sh "gem uninstall -x ruby-processing"
end

task :build do
  sh "cd vendors && rake"
  sh "gem build ruby-processing.gemspec"
end

task :test do
  ruby "test/rp5_test.rb"
end

task :default => [:build, :test]
