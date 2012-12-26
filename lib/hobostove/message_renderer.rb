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
      when "TimestampMessage"
        "\t#{message.timestamp.strftime("%H:%M")}"
      end
    end
  end
end
