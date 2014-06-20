module Hobostove
  class Window
    attr_reader :messages

    def connect
      @current_message = ""
      @running = true
      @messages = []

      begin
        start_curses
        load_users
        stream
        main
      ensure
        Hobostove.logger.debug("terminated")
        stop_curses
      end
    end

    def main
      campfire.join

      while @running && (ch = Curses.getch)
        Hobostove.logger.debug("#{ch} - #{ch.chr.inspect} pressed")

        case ch
        when 14 # C+n
          @messages_panel.scroll_down
        when 16 # C+p
          @messages_panel.scroll_up
        when 10 # enter
          speak
        when 21 # C-u
          @current_message = ""
        when 127 # backspace
          @current_message = @current_message.first(@current_message.size - 1)
        when 9 # tab
          @current_message = "#{@users_panel.user_names.find { |user| user =~ /^#@current_message/ }}: "
        else
          @current_message << ch.chr
        end

        @message_panel << @current_message
        @message_panel.update_cursor
      end

      campfire.leave
    end

    def speak
      if @current_message == "/quit"
        @running = false
        return
      end

      campfire.send_message @current_message
      @current_message = ""
    end

    def stream
      Thread.new do
        loop do
          recent = campfire.recent_messages
          recent.each do |message|
            next if messages.include?(message.id)
            messages << message.id
            handle_message(message)
          end

          @messages_panel.refresh

          sleep 1
        end
      end
    end

    def handle_message(message)
      Hobostove.logger.debug(message.inspect)

      case message.type
      when "TextMessage"
        Notify.notify message.username, message.body
      when "EnterMessage"
        @users_panel.add_user(message.user)
      when "LeaveMessage"
        @users_panel.remove_user(message.user)
      end

      message_renderer.render_lines(message).each do |line|
        @messages_panel.<<(line, false)
      end
    rescue => e
      Hobostove.logger.fatal(e.inspect)
    end

    private

    def message_renderer
      @message_renderer ||=
        MessageRenderer.new(Curses.cols - 25)
    end

    def start_curses
      Curses.init_screen
      Curses.cbreak
      Curses.noecho

      @users_panel = UserPanel.new(Curses.lines, 20, 0, Curses.cols - 20)
      @messages_panel = Panel.new(Curses.lines - 3, Curses.cols - 20, 0, 0, :nowrap => true)
      @message_panel = InputPanel.new(3, Curses.cols - 20, Curses.lines - 3, 0)

      Curses.setpos(Curses.lines - 2, 2)

      @users_panel.refresh!
      @messages_panel.refresh!
      @message_panel.refresh!
    end

    def stop_curses
      Curses.echo
    end

    def load_users
      campfire.current_users.each do |user|
        Hobostove.logger.info user.name
        @users_panel.add_user(user, false)
      end
      @users_panel.refresh
    end

    def campfire
      @campfire ||= Campfire.new
    end
  end
end
