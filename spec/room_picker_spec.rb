require 'spec_helper'

describe Hobostove::Cli::RoomPicker do
  let(:stdout) { StringIO.new }

  before do
    FileUtils.mkdir_p(Dir.home(Etc.getlogin))
    File.open(Hobostove::Configuration.config_file, "w") do |file|
      file.write settings.to_yaml
    end
  end

  subject { Hobostove::Cli::RoomPicker.new(stdin, stdout) }

  before do
    Hobostove::Configuration.send(:instance_variable_set, :@config, nil)
  end

  context "multiple rooms set up" do
    let(:stdin) { StringIO.new("2\n") }

    let(:settings) do
      [
        {
          "subdomain" => "subone",
          "token" => "token",
          "room" => "roomone"
        },
        {
          "subdomain" => "subtwo",
          "token" => "token",
          "room" => "roomtwo"
        }
      ]
    end

    it "should pick a room" do
      subject.run

      stdout.rewind
      lines = stdout.read.split("\n")

      expect(lines[1]).to eq("1. subone - roomone")
      expect(lines[2]).to eq("2. subtwo - roomtwo")

      expect(Hobostove::Configuration.current_room).to eq(1)
      expect(Hobostove::Configuration.room).to eq("roomtwo")
    end
  end

  context "single room set up" do
    let(:stdin) { StringIO.new }
    let(:settings) do
      [
        {
          "subdomain" => "subone",
          "token" => "token",
          "room" => "roomone"
        },
      ]
    end

    it "should pick the only room for you" do
      subject.run

      expect(Hobostove::Configuration.current_room).to eq(0)
      expect(Hobostove::Configuration.room).to eq("roomone")
    end
  end
end
