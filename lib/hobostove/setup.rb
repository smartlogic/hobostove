module Hobostove
  class Setup
    def self.run_setup?
      !File.exists?(Hobostove::Configuration.config_file)
    end
  end
end
