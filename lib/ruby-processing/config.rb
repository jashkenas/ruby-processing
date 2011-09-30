require "yaml"

module Processing
  CONFIG_FILE_PATH = File.expand_path("~/.rp5rc")
  CONFIG = (YAML::load_file(CONFIG_FILE_PATH) rescue {}).freeze 
end
