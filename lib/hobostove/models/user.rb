module Hobostove
  module Models
    class User < Value.new(:id, :name)
      def eql?(other)
        id == other.id
      end

      def hash
        id.hash
      end
    end
  end
end
