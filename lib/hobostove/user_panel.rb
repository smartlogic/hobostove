module Hobostove
  class UserPanel < Panel
    def add_user(username)
      @strings.push(username)
      @strings.sort!
      refresh
    end

    def remove_user(username)
      @strings.delete(username)
      @strings.sort!
      refresh
    end
  end
end
