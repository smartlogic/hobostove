module Hobostove
  class Upgrade
    def self.upgrade_config?
      !YAML.load(File.read(Hobostove::Configuration.config_file)).is_a?(Array)
    end

    def self.perform
      settings = YAML.load(File.read(Hobostove::Configuration.config_file))
      File.open(Hobostove::Configuration.config_file, "w") do |file|
        file.write [settings].to_yaml
      end
    end
  end
end
