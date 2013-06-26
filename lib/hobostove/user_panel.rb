module Hobostove
  class UserPanel < Panel
    def initialize(*args)
      super

      @users = Set.new
    end

    def user_names
      @users.map(&:name)
    end

    def add_user(user)
      @users.add(user)

      refresh
    end

    def remove_user(user)
      @users.delete(user)

      refresh
    end

    def refresh
      @strings = @users.map(&:name)
      @strings.sort!

      super
    end
  end
end
