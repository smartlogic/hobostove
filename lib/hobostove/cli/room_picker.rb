module Hobostove
  module Cli
    class RoomPicker
      def initialize(stdin, stdout)
        @stdin = stdin
        @stdout = stdout
      end

      def run
        @config = YAML.load(File.read(Hobostove::Configuration.config_file))

        if @config.count == 1
          Hobostove::Configuration.current_room = 0
        else
          pick_room
        end
      end

      private

      def pick_room
        @stdout.puts "Which room would you like to connect to?"

        @config.each_with_index do |account, index|
          @stdout.puts "#{index + 1}. #{account["subdomain"]} - #{account["room"]}"
        end

        room_index = @stdin.gets.chomp

        Hobostove::Configuration.current_room = room_index.to_i - 1
      end
    end
  end
end
