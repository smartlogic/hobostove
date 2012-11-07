require 'etc'

module Hobostove
  class Configuration
    class << self
      def method_missing(method)
        config[method.to_s]
      end

      def config
        @config ||= YAML.load(File.open(config_file))
      end

      def config_file
        user = Etc.getlogin
        config_file = File.join(Dir.home(user), ".hobostove.yml")
      end
    end
  end
end
