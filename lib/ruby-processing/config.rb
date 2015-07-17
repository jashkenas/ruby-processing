require 'psych'

module Processing
  
  if ENV['EXPORTED'].eql?('true')
    RP_CONFIG = { 'PROCESSING_ROOT' => RP5_ROOT, 'JRUBY' => 'false' }
  end
  unless defined? RP_CONFIG
    begin
      CONFIG_FILE_PATH = File.expand_path('~/.rp5rc')
      RP_CONFIG = (Psych.load_file(CONFIG_FILE_PATH))
    rescue
      warn('WARNING: you need to set PROCESSING_ROOT in ~/.rp5rc')
    end
  end
end
