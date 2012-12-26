module Hobostove
  class MessageRenderer < Struct.new(:subdomain, :room_id)
    def render(message)
      case message.type
      when "TextMessage"
        "#{message.username}: #{message.body}"
      when "EnterMessage"
        "\t#{message.username} joined"
      when "LeaveMessage"
        "\t#{message.username} left"
      when "TimestampMessage"
        "\t#{message.timestamp.strftime("%H:%M")}"
      when "PasteMessage"
        "#{message.username} (paste message):\n#{message.body}"
      end
    end
  end
end
