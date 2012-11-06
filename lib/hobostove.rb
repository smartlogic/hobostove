#!/usr/bin/env ruby

require 'tinder'
require 'active_support/core_ext'
require 'ncurses'

class Configuration
  class << self
    def method_missing(method)
      config[method.to_s]
    end

    def config
      @config ||= YAML.load(File.open("config.yml"))
    end
  end
end

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

class InputPanel < Panel
  def <<(string)
    @strings = []

    super
  end

  def message
    @strings.first
  end

  def update_cursor
    @win.wmove(1, message.size)
  end
end

class Hobostove
  attr_reader :messages

  def connect
    @current_message = ""
    @running = true

    start_ncurses

    load_users
    transcript

    stream

    main

    stop_ncurses
  end

  def main
    while @running && (ch = Ncurses.getch)
      case ch
      when 10 # enter
        speak
      when 127 # backspace
        @current_message = @current_message.first(@current_message.size - 1)
      else
        @current_message << ch.chr
      end

      @message_panel << @current_message
      @message_panel.update_cursor
    end
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
      room.listen do |message|
        if message[:type] = "TextMessage"
          message = "#{message.user.name}: #{message[:body]}"
          @messages_panel << message
          `notify-send "#{message}"`
        end
      end
    end
  end

  def room
    @room ||= campfire.find_room_by_name(Configuration.room)
  end

  def transcript
    transcript = room.transcript(Date.today)
    transcript.each do |message|
      next unless (7.hours.ago..Time.now).cover?(message[:timestamp])
      if message[:message]
        @messages_panel << "#{user(message[:user_id])[:name]}: #{message[:message]}"
      end
    end
  end

  private

  def start_ncurses
    Ncurses.initscr
    Ncurses.cbreak
    Ncurses.noecho

    @users_panel = Panel.new(Ncurses.LINES, 20, 0, Ncurses.COLS - 20)
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
      @users_panel << user["name"]
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
