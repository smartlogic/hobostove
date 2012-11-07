module Hobostove
  class Panel < Struct.new(:height, :width, :starty, :startx, :options)
    def initialize(*args)
      super
      @win = Ncurses.newwin(height, width, starty, startx)
      Ncurses.box(@win, 0, 0)
      @panel = Ncurses::Panel.new_panel(@win)
      @strings = []
    end

    def options
      super || {}
    end

    def wrap_lines?
      !options[:nowrap]
    end

    def <<(string)
      if wrap_lines?
        @strings << string.first(width - 4)
      else
        @strings << string
      end

      Ncurses.werase(@win)

      @strings.last(height - 2).each_with_index do |string, i|
        @win.mvaddstr(i + 1, 2, string)
      end

      Ncurses.box(@win, 0, 0)

      Ncurses::Panel.update_panels
      Ncurses.doupdate
      Ncurses.refresh
    end
  end
end
