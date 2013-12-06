
desc 'build and test'    
task :default => [:build_and_test]

task :build_and_test do
  Rake::Task["build"].execute
  Rake::Task["test"].execute
end

desc 'Build and install gem'
task :install => :build do
  sh "gem install #{Dir.glob('*.gem').join(' ')} --no-ri --no-rdoc"
end

desc 'Uninstall gem'
task :uninstall do
  sh "gem uninstall -x ruby-processing"	
end

desc 'Install jruby-complete'
task :install_jruby_complete do
  begin
    sh "cd vendors && rake"
  rescue
    warn("WARNING: you may not have wget installed")	    
  end
end

desc 'Build gem'
task :build do
  sh "gem build ruby-processing.gemspec"
end

desc 'Test'
task :test do
  ruby "test/rp5_test.rb"	
end
