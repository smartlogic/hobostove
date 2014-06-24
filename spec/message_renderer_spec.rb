require 'spec_helper'

module Hobostove
  describe MessageRenderer do
    let(:renderer) { MessageRenderer.new(100) }

    let(:user) { Models::User.new(10, "Eric") }

    context "small window" do
      let(:renderer) { MessageRenderer.new(30) }

      it "should split the message to fit the window" do
        message =
          Models::Message.new("id", Time.now, "TextMessage", user, "testing out MessageRenderer")
        expect(renderer.render_lines(message).map(&:to_s)).to eq(["Eric: testing out MessageRende", "rer"])
      end

      it "should return an empty array if message type isn't handled" do
        message = Models::Message.new("id", Time.now, "Unknown", user, "won't show")
        expect(renderer.render_lines(message)).to eq([])
      end
    end

    it "should render text messages" do
      message = Models::Message.new("id", Time.now, "TextMessage", user, "testing out MessageRenderer")
      expect(renderer.render(message).to_s).to eq("Eric: testing out MessageRenderer")
    end

    it "should render enter messages" do
      message = Models::Message.new("id", Time.now, "EnterMessage", user, nil)
      expect(renderer.render(message).to_s).to eq("    Eric joined")
    end

    it "should render leave messages" do
      message = Models::Message.new("id", Time.now, "LeaveMessage", user, nil)
      expect(renderer.render(message).to_s).to eq("    Eric left")
    end

    it "should render timestamp messages" do
      message = Models::Message.new("id", Time.new(2012, 12, 26, 10, 55, 3), "TimestampMessage", nil, nil)
      expect(renderer.render(message).to_s).to eq("    10:55")
    end

    it "should render paste messages" do
      message =
        Models::Message.new("5678", Time.now, "PasteMessage", user, "a paste message\nwith two lines")
      expect(renderer.render(message).to_s).to eq("Eric (paste message):\na paste message\nwith two lines")
    end

    it "should render tweet messages" do
      message =
        Models::Message.new("5678", Time.now, "TweetMessage", user, "https://twitter.com/link/to/tweet")
      expect(renderer.render(message).to_s).to eq("Eric (tweet message): https://twitter.com/link/to/tweet")
    end

    it "should render upload messages" do
      message =
        Models::Message.new("5678", Time.now, "UploadMessage", user, "Screen Shot.png")
      expect(renderer.render(message).to_s).to eq("Eric (upload message): Screen Shot.png")
    end
  end
end
