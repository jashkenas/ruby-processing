require_relative 'lib/ruby-processing/version'

def create_manifest
  title =  'Implementation-Title: rpextras (java extension for ruby-processing)'
  version =  format('Implementation-Version: %s', RubyProcessing::VERSION)
  file = File.open('MANIFEST.MF', 'w') do |f|
    f.puts(title)
    f.puts(version)
  end
end

desc 'Create Manifest'
task :init do
  create_manifest
end

desc 'build and test'    
task :default => [:init, :build_and_test]

task :build_and_test do
  Rake::Task["build"].execute  
  Rake::Task["test"].execute
end

desc 'Build and install gem'
task :install => :build do
  sh "jruby -S gem install #{Dir.glob('*.gem').join(' ')} --no-ri --no-rdoc"
end

desc 'Uninstall gem'
task :uninstall do
  sh "gem uninstall -x ruby-processing"	
end

desc 'Install jruby-complete'
task :install_jruby_complete do
  begin
    sh 'cd vendors && rake'
  rescue
    warn('WARNING: you may not have wget installed')	    
  end
end

desc 'Build gem'
task :build do
  sh 'mvn package'
  sh 'mv target/rpextras.jar lib'
end

desc 'Test'
task :test do
  sh "jruby test/vecmath_spec_test.rb"
  sh "jruby test/deglut_spec_test.rb"
  sh "jruby test/math_tool_test.rb"
  sh "jruby test/helper_methods_test.rb"
  ruby "test/rp5_run_test.rb"	
end

desc 'Clean'
task :clean do
  Dir['./**/*.%w{jar gem}'].each do |path|
    puts "Deleting #{path} ..."
    File.delete(path)
  end
  FileUtils.rm_rf('./tmp')
end
