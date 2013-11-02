require 'rbconfig'
include RbConfig


desc 'Check platform as best we can'
task :default => [:platform]

task :platform do
  case CONFIG['host_os']
  when /mswin|windows/i
    begin
      Rake::Task["build_windows"].execute
      Rake::Task["install"].execute
    rescue
      warn("WARNING: you need to manually download jruby-complete{version).jar and processing(version).zip to ./vendors/windows")
      raise "missing file in ./vendors/windows, see ./vendors/windows/Rakefile"
    end
  when /linux/i
    # check for wget in the usual place this is the simplest test	  
    if File.exists?('/usr/bin/wget')
      Rake::Task["build_linux"].execute
      Rake::Task["test"].execute
    else
      raise "You need to install wget"
    end
  else
    # I wrongly assumed Mac users know they require wget, or have installed Brew	  
    begin
      Rake::Task["build"].execute
      Rake::Task["test"].execute
    rescue
      warn("WARNING: you may not have wget installed")	    
    end
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

desc 'Build Windows'
task :build_windows do
  sh "cd vendors/windows && rake"
end

desc 'Build gem linux'
task :build_linux do
  sh "cd vendors/linux && rake"
  sh "gem build ruby-processing.gemspec"
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
