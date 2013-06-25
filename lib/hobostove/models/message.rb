module Hobostove
  module Models
    class Message < Value.new(:id, :timestamp, :type, :username, :body)
      def self.convert(tinder_message)
        # Tinder explicitly sets nil for "user"
        user = tinder_message.fetch("user", {}) || {}
        username = user.fetch("name", "")

        new(
          tinder_message["id"],
          tinder_message["created_at"],
          tinder_message["type"],
          username,
          tinder_message["body"]
        )
      end
    end
  end
end
