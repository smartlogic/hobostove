require 'etc'

module Hobostove
  class Configuration
    class << self
      attr_accessor :current_room

      def method_missing(method)
        config[method.to_s]
      end

      def config
        @config ||= YAML.load(File.open(config_file))[current_room]
      end

      def config_file
        user = Etc.getlogin
        File.join(Dir.home(user), ".hobostove.yml")
      end
    end
  end
end
