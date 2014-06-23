module Hobostove
  class InputPanel < Panel
    def <<(string)
      @strings = []

      string = string.last(width - 4)

      super(string)
    end

    def message
      @strings.first.to_s
    end

    def update_cursor
      Curses.setpos(Curses.lines - 2, message.size + 2)
    end
  end
end
