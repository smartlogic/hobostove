module Hobostove
  module Cli
    class Setup
      def self.run_setup?
        !File.exists?(Hobostove::Configuration.config_file)
      end

      def initialize(stdin, stdout)
        @stdin = stdin
        @stdout = stdout
        @settings = {}
      end

      def run
        File.open(Hobostove::Configuration.config_file, "w") do |file|
          @stdout.puts "~/.hobostove.yml not found. Running setup"
          @stdout.puts "Subdomain?"
          @settings["subdomain"] = @stdin.gets.chomp

          @stdout.puts "Token?"
          @settings["token"] = @stdin.gets.chomp

          @stdout.puts "Room (full name)?"
          @settings["room"] = @stdin.gets.chomp

          file.write [@settings].to_yaml
        end
      end
    end
  end
end
