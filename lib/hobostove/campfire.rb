module Hobostove
  class Campfire
    def initialize
      load_current_room

      @users = []
    end

    def recent_messages
      messages = connection.get("/room/#{@room_id}/recent.json?limit=10").body
      messages = JSON.parse(messages)["messages"]
      messages.map do |message|
        Hobostove::Models::Message.new(
          message["id"],
          Time.parse(message["created_at"]),
          message["type"],
          user(message["user_id"]),
          message["body"]
        )
      end
    end

    def send_message(message)
      connection.post("/room/#{@room_id}/speak.json") do |req|
        req.body = {
          :message => {
            :type => "TextMessage",
            :body => message,
          }
        }.to_json
      end
    end

    def current_users
      room = connection.get("/room/#{@room_id}.json").body
      room = JSON.parse(room)["room"]
      room["users"].map do |user|
        Hobostove::Models::User.new(user["id"], user["name"])
      end
    end

    private

    def base_uri
      "https://#{Configuration.subdomain}.campfirenow.com"
    end

    def connection
      return @connection if @connection
      @connection = Faraday.new(base_uri) do |faraday|
        faraday.adapter *Faraday.default_adapter
      end
      @connection.basic_auth(Configuration.token, "x")
      @connection
    end

    def load_current_room
      rooms = connection.get("/rooms.json").body
      rooms = JSON.parse(rooms)["rooms"]
      @room_id = rooms.find do |room|
        room["name"] == Configuration.room
      end["id"]
    end

    def user(user_id)
      return @users[user_id] if @users[user_id]
      user = connection.get("/users/#{user_id}.json").body
      @users[user_id] = Hobostove::Models::User.new(user_id, user["name"])
    end
  end
end
