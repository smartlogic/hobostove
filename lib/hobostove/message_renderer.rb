module Hobostove
  class MessageRenderer < Struct.new(:subdomain, :window_size)
    def render_lines(message)
      message = render(message)
      return [] if message.nil?
      message.scan(/.{1,#{window_size}}/)
    end

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
      when "TweetMessage"
        "#{message.username} (tweet message): #{message.body}"
      when "UploadMessage"
        "#{message.username} (upload message): #{message.body}"
      end
    end
  end
end
