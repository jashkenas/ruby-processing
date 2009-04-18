require 'rake'

desc 'Build and install gem'
task :install do
  sh "sudo gem build ruby-processing.gemspec"
  sh "sudo gem install #{Dir.glob('*.gem').join(' ')} --no-ri --no-rdoc"
end

desc 'Uninstall gem'
task :uninstall do
  sh "sudo gem uninstall -x ruby-processing"
end
