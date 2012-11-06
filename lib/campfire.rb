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

class Messages < Array
  def <<(message)
    # puts message
    super
  end
end

class Campfire
  attr_reader :messages

  def connect
    puts "Connecting to #{Configuration.room}..."
    @messages = Messages.new

    start_ncurses

    load_users
    transcript

#    stream

    stop_ncurses
  end

  def stream
    Thread.new do
      room.listen do |message|
        if message[:type] = "TextMessage"
          messages << "#{message.user.name}: #{message[:body]}"
        end
      end
    end.join
  end

  def room
    @room ||= campfire.find_room_by_name(Configuration.room)
  end

  def transcript
    transcript = room.transcript(Date.today)
    transcript.each do |message|
      next unless (7.hours.ago..Time.now).cover?(message[:timestamp])
      if message[:message]
        messages << "#{user(message[:user_id])[:name]}: #{message[:message]}"
      end
    end
  end

  private

  def start_ncurses
    Ncurses.initscr
    Ncurses.cbreak
    Ncurses.noecho

    users = Ncurses.newwin(Ncurses.LINES, 20, 0, Ncurses.COLS - 20)
    Ncurses.box(users, 0, 0)
    users = Ncurses::Panel.new_panel(users)

    messages = Ncurses.newwin(Ncurses.LINES - 3, Ncurses.COLS - 20, 0, 0)
    Ncurses.box(messages, 0, 0)
    messages = Ncurses::Panel.new_panel(messages)

    message = Ncurses.newwin(3, Ncurses.COLS - 20, Ncurses.LINES - 3, 0)
    Ncurses.box(message, 0, 0)
    message = Ncurses::Panel.new_panel(message)

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
#    puts "User list"
#    room.users.each do |user|
#      puts "- #{user["name"]}"
#    end
  end

  def user(user_id)
    @users ||= {}
    @users[user_id] ||= room.user(user_id)
  end

  def campfire
    @campfire ||= Tinder::Campfire.new Configuration.subdomain, :token => Configuration.token
  end
end
