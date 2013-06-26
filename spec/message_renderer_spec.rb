require 'spec_helper'

module Hobostove
  describe MessageRenderer do
    let(:renderer) { MessageRenderer.new("subdomain", "1234", 100) }

    let(:user) { Models::User.new(10, "Eric") }

    context "small window" do
      let(:renderer) { MessageRenderer.new("subdomain", "1234", 30) }

      it "should split the message to fit the window" do
        message =
          Models::Message.new("id", Time.now, "TextMessage", user, "testing out MessageRenderer")
        renderer.render_lines(message).should == ["Eric: testing out MessageRende", "rer"]
      end

      it "should return an empty array if message type isn't handled" do
        message = Models::Message.new("id", Time.now, "Unknown", user, "won't show")
        renderer.render_lines(message).should == []
      end
    end

    it "should render text messages" do
      message = Models::Message.new("id", Time.now, "TextMessage", user, "testing out MessageRenderer")
      renderer.render(message).should == "Eric: testing out MessageRenderer"
    end

    it "should render enter messages" do
      message = Models::Message.new("id", Time.now, "EnterMessage", user, nil)
      renderer.render(message).should == "\tEric joined"
    end

    it "should render leave messages" do
      message = Models::Message.new("id", Time.now, "LeaveMessage", user, nil)
      renderer.render(message).should == "\tEric left"
    end

    it "should render timestamp messages" do
      message = Models::Message.new("id", Time.new(2012, 12, 26, 10, 55, 3), "TimestampMessage", nil, nil)
      renderer.render(message).should == "\t10:55"
    end

    it "should render paste messages" do
      message =
        Models::Message.new("5678", Time.now, "PasteMessage", user, "a paste message\nwith two lines")
      renderer.render(message).should == "Eric (paste message):\na paste message\nwith two lines"
    end

    it "should render tweet messages" do
      message =
        Models::Message.new("5678", Time.now, "TweetMessage", user, "https://twitter.com/link/to/tweet")
      renderer.render(message).should == "Eric (tweet message): https://twitter.com/link/to/tweet"
    end

    it "should render upload messages" do
      message =
        Models::Message.new("5678", Time.now, "UploadMessage", user, "Screen Shot.png")
      renderer.render(message).should == "Eric (upload message): Screen Shot.png"
    end
  end
end
