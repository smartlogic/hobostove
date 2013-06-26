module Hobostove
  module Models
    class Message < Value.new(:id, :timestamp, :type, :user, :body)
      def self.convert(tinder_message)
        # Tinder explicitly sets nil for "user"
        tinder_user = tinder_message.fetch("user", {}) || {}
        user = User.convert(tinder_user)

        new(
          tinder_message["id"],
          tinder_message["created_at"],
          tinder_message["type"],
          user,
          tinder_message["body"]
        )
      end

      def username
        user.name
      end
    end
  end
end
