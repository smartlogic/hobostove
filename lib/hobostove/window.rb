module Hobostove
  class Window
    attr_reader :messages

    def connect
      @current_message = ""
      @running = true
      @user_names = []
      @messages = []

      start_ncurses

      load_users

      stream

      main

      stop_ncurses
    end

    def main
      room.join

      while @running && (ch = Ncurses.getch)
        Hobostove.logger.debug("#{ch} - #{ch.chr} pressed")

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
          @current_message = "#{@user_names.find { |user| user =~ /^#@current_message/ }}: "
        else
          @current_message << ch.chr
        end

        @message_panel << @current_message
        @message_panel.update_cursor
      end

      room.leave
    end

    def speak
      if @current_message == "/quit"
        @running = false
        return
      end

      room.speak @current_message
      @current_message = ""
    end

    def stream
      Thread.new do
        loop do
          recent = room.recent(10)
          recent.each do |message|
            next if messages.include?(message[:id])
            messages << message[:id]

            handle_message(message)
          end

          sleep 1
        end
      end
    end

    def handle_message(message)
      Hobostove.logger.debug(message.inspect)

      # Tinder explicitly sets nil for "user"
      user = message.fetch("user", {}) || {}
      username = user.fetch("name", "Nil")

      Hobostove.logger.debug("Username: #{username}")

      case message.type
      when "TextMessage"
        Notify.notify username, message[:body]
        @messages_panel <<   "#{username}: #{message[:body]}"
      when "EnterMessage"
        @messages_panel << "\t#{username} joined"
        @users_panel.add_user(username)
      when "LeaveMessage"
        @messages_panel << "\t#{username} left"
        @users_panel.remove_user(username)
      end
    rescue => e
      Hobostove.logger.fatal(e.inspect)
    end

    def room
      @room ||= campfire.find_room_by_name(Configuration.room)
    end

    private

    def start_ncurses
      Ncurses.initscr
      Ncurses.cbreak
      Ncurses.noecho

      @users_panel = UserPanel.new(Ncurses.LINES, 20, 0, Ncurses.COLS - 20)
      @messages_panel = Panel.new(Ncurses.LINES - 3, Ncurses.COLS - 20, 0, 0, :nowrap => true)
      @message_panel = InputPanel.new(3, Ncurses.COLS - 20, Ncurses.LINES - 3, 0)

      Ncurses::Panel.update_panels

      Ncurses.move(Ncurses.LINES - 2, 2)

      Ncurses.doupdate
      Ncurses.refresh
    end

    def stop_ncurses
      Ncurses.echo
      Ncurses.endwin
    end

    def load_users
      room.users.each do |user|
        @user_names << user["name"]
        @users_panel.add_user(user["name"])
      end
    end

    def user(user_id)
      @users ||= {}
      @users[user_id] ||= room.user(user_id)
    end

    def campfire
      @campfire ||= Tinder::Campfire.new Configuration.subdomain, :token => Configuration.token
    end
  end
end
