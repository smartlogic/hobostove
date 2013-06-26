module Hobostove
  module Models
    class User < Value.new(:id, :name)
      def self.convert(tinder_user)
        new(
          tinder_user[:id],
          tinder_user[:name]
        )
      end

      def eql?(other)
        id == other.id
      end

      def hash
        id.hash
      end
    end
  end
end
