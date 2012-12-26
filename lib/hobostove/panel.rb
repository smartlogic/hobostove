module Hobostove
  class Panel < Struct.new(:height, :width, :starty, :startx, :options)
    def initialize(*args)
      super
      @win = Ncurses.newwin(height, width, starty, startx)
      Ncurses.box(@win, 0, 0)
      @panel = Ncurses::Panel.new_panel(@win)
      @strings = []
      @scroll = 0
    end

    def options
      super || {}
    end

    def wrap_lines?
      !options[:nowrap]
    end

    def <<(string)
      return if string.nil?

      if wrap_lines?
        @strings << string.first(width - 4)
      else
        word_wrap(string, width - 5).each do |line|
          @strings << line
        end
      end

      refresh
    end

    def scroll_up
      if @strings.size > printable_area + @scroll
        @scroll += 1
      end
      refresh
    end

    def scroll_down
      if @scroll > 0
        @scroll -= 1
      end
      refresh
    end

    private

    def printable_area
      height - 2
    end

    def refresh
      Ncurses.werase(@win)

      @strings.last(printable_area + @scroll).first(printable_area).each_with_index do |string, i|
        @win.mvaddstr(i + 1, 2, string)
      end

      Ncurses.box(@win, 0, 0)

      Ncurses::Panel.update_panels
      Ncurses.doupdate
      Ncurses.refresh
    end

    def word_wrap(text, line_width)
      text.scan(/.{1,#{line_width}}/).each_with_index.map do |line, index|
        if index > 0
          " #{line}"
        else
          line
        end
      end
    end
  end
end
