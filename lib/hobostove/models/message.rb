module Hobostove
  module Models
    class Message < Value.new(:id, :timestamp, :type, :user, :body)
      def username
        user.name
      end
    end
  end
end
