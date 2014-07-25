require 'psych'

module Processing

  if Processing.exported?
    CONFIG = {'PROCESSING_ROOT' => RP5_ROOT}	
    CONFIG = {'JRUBY' => "false"}	
  end	  

  unless defined? CONFIG
    begin
      CONFIG_FILE_PATH=File.expand_path("~/.rp5rc")
      CONFIG = (Psych.load_file(CONFIG_FILE_PATH))
    rescue 
      warn("WARNING: you need to set PROCESSING_ROOT in ~/.rp5rc")  
    end
  end
end
