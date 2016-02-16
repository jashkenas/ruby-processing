require 'fileutils'
project 'rp5extras', 'https://github.com/jashkenas/ruby-processing' do

  model_version '4.0.0'
  id 'ruby-processing:rp5extras', '2.6.17'
  packaging 'jar'

  description 'rp5extras for ruby-processing'

  organization 'ruby-processing', 'https://ruby-processing.github.io'

  developer 'monkstone' do
    name 'Martin Prout'
    email 'martin_p@lineone.net'
    roles 'developer' 
  end

  issue_management 'https://github.com/jashkenas/ruby-processing/issues', 'Github'

  source_control(
    :url => 'https://github.com/jashkenas/ruby-processing',
    :connection => 'scm:git:git://github.com/jashkenas/ruby-processing.git',
    :developer_connection => 'scm:git:git@github.com/jashkenas/ruby-processing.git'
  )
  
  properties( 'maven.compiler.source' => '1.7',
              'project.build.sourceEncoding' => 'UTF-8',
              'maven.compiler.target' => '1.7',
              'polyglot.dump.pom' => 'pom.xml',
              'processing.api' => "http://processing.github.io/processing-javadocs/core/",
              'jruby.api' => "http://jruby.org/apidocs/"
            )

  pom 'org.jruby:jruby:1.7.24'
  jar 'org.processing:core:2.2.1'
  jar 'org.processing:video:2.2.1'
  plugin_management do
    plugin :resources, '2.6'
    plugin :dependency, '2.8'
    plugin( :compiler, '3.3',
          'source' =>  '1.7',
          'target' =>  '1.7' )
    plugin( :javadoc, '2.10.3',
          'detectOfflineLinks' => 'false',
          'links' => ['${processing.api}', '${jruby.api}']
          )
    plugin( :jar, '2.6',
            'archive' => {
              'manifestFile' => 'MANIFEST.MF'
            }
          )
  end
  build do
    default_goal 'package'
    source_directory 'src'
    final_name 'rpextras'
  end
end
