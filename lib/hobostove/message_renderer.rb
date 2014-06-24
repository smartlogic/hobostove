module Hobostove
  class MessageRenderer < Struct.new(:window_size)
    def render_lines(message)
      message = render(message)
      return [] if message.nil?
      message.split(window_size).select { |line| line.present? }
    end

    def render(message)
      line = Line.new
      case message.type
      when "TextMessage"
        line.add(:cyan, message.username)
        line.add(:white, ": #{message.body}")
      when "EnterMessage"
        line.add(:white, "    ")
        line.add(:cyan, message.username)
        line.add(:white, " joined")
      when "LeaveMessage"
        line.add(:white, "    ")
        line.add(:cyan, message.username)
        line.add(:white, " left")
      when "TimestampMessage"
        line.add(:white, "    #{message.timestamp.strftime("%H:%M")}")
      when "PasteMessage"
        line.add(:cyan, message.username)
        line.add(:white, " (paste message):\n#{message.body}")
      when "TweetMessage"
        line.add(:cyan, message.username)
        line.add(:white, " (tweet message): #{message.body}")
      when "UploadMessage"
        line.add(:cyan, message.username)
        line.add(:white, " (upload message): #{message.body}")
      end
      line
    end
  end
end
