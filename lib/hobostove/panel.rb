module Hobostove
  class Panel < Struct.new(:height, :width, :starty, :startx, :options)
    def initialize(*args)
      super

      @win = Curses::Window.new(height, width, starty, startx)
      @win.box(0, 0)

      Curses.refresh
      @win.refresh

      @strings = []
      @scroll = 0
    end

    def options
      super || {}
    end

    def wrap_lines?
      !options[:nowrap]
    end

    def <<(string, do_update = true)
      if wrap_lines?
        @strings << string.first(width - 4)
      else
        @strings << string
      end

      refresh if do_update
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

    def refresh!
      @win.refresh
    end

    def refresh
      @win.clear

      @win.box(0, 0)

      printable_lines.each_with_index do |string, i|
        @win.setpos(i + 1, 2)
        @win.addstr(string)
      end

      refresh!
    end

    private

    def printable_lines
      @strings.last(printable_area + @scroll).first(printable_area)
    end

    def printable_area
      height - 2
    end
  end
end
