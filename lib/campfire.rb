#!/usr/bin/env ruby

require 'tinder'
require 'active_support/core_ext'

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
    puts message
    super
  end
end

class Campfire
  attr_reader :messages

  def connect
    puts "Connecting to #{Configuration.room}..."
    @messages = Messages.new

    load_users
    transcript

    stream
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

  def load_users
    puts "User list"
    room.users.each do |user|
      puts "- #{user["name"]}"
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

campfire = Campfire.new
campfire.connect
