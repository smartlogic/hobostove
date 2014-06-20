require 'spec_helper'

describe Hobostove::Campfire do
  Message = Hobostove::Models::Message

  let(:stubs) { Faraday::Adapter::Test::Stubs.new }

  let(:campfire) { Hobostove::Campfire.new }

  before do
    FakeFS.deactivate!

    Faraday.default_adapter = [:test, stubs]

    stubs.get("/rooms.json") do
      [200, {}, File.read("spec/fixtures/rooms.json")]
    end

    Hobostove::Configuration.stub(:config).and_return({
      "subdomain" => "company",
      "token" => "token",
      "room" => "Chat room",
    })
  end

  let(:user) do
    Hobostove::Models::User.new(5, "Eric")
  end

  specify "getting messages" do
    stubs.get("/room/27/recent.json") do
      [200, {}, File.read("spec/fixtures/messages.json")]
    end

    stubs.get("/users/5.json") do
      [200, {}, File.read("spec/fixtures/user.json")]
    end

    expect(campfire.recent_messages).to eq([
      Message.new(10, Time.parse("2014-06-20 10:19"), "TextMessage", user, "Hi"),
      Message.new(11, Time.parse("2014-06-20 10:20"), "TextMessage", user, "hello"),
    ])
  end

  specify "sending a message" do
    stubs.post("/room/27/speak.json") do
      [200, {}, ""]
    end

    campfire.send_message("Hi")

    stubs.verify_stubbed_calls
  end

  specify "getting current users" do
    stubs.get("/room/27.json") do
      [200, {}, File.read("spec/fixtures/room.json")]
    end

    expect(campfire.current_users).to eq([
      Hobostove::Models::User.new(63, "User 1"),
      Hobostove::Models::User.new(79, "User 2"),
    ])
  end
end
