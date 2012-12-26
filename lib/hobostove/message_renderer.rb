module Hobostove
  class MessageRenderer
    def self.render(message)
      case message.type
      when "TextMessage"
        "#{message.username}: #{message.body}"
      when "EnterMessage"
        "\t#{message.username} joined"
      when "LeaveMessage"
        "\t#{message.username} left"
      end
    end
  end
end
