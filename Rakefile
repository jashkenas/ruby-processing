require 'rbconfig'
include RbConfig


desc 'Check platform as best we can'
task :default => [:platform]

task :platform do
  case CONFIG['host_os']
  when /mswin|windows/i
    puts "If you have any build problems you might be missing wget"
    puts "You might be better using the alternative vendors/Rakefile see Wiki"
    Rake::Task["build"].execute
    Rake::Task["install"].execute
  else
    Rake::Task["build"].execute
    Rake::Task["test"].execute
  end
end

desc 'Build and install gem'
task :install => :build do
  sh "gem install #{Dir.glob('*.gem').join(' ')} --no-ri --no-rdoc"
end

desc 'Uninstall gem'
task :uninstall do
  sh "gem uninstall -x ruby-processing"	
end


desc 'Build gem'
task :build do
  sh "cd vendors && rake"
  sh "gem build ruby-processing.gemspec"
end

desc 'Test'
task :test do
  ruby "test/rp5_test.rb"	
end
