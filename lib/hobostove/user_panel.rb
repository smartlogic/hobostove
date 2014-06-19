module Hobostove
  class UserPanel < Panel
    def initialize(*args)
      super

      @users = Set.new
    end

    def user_names
      @users.map(&:name)
    end

    def add_user(user, do_refresh = true)
      @users.add(user)

      refresh if do_refresh
    end

    def remove_user(user, do_refresh = true)
      @users.delete(user)

      refresh if do_refresh
    end

    def refresh
      @strings = @users.map(&:name)
      @strings.sort!

      super
    end
  end
end
