require 'spec_helper'

module Hobostove
  describe MessageRenderer do
    let(:renderer) { MessageRenderer.new("subdomain", "1234", 100) }

    context "small window" do
      let(:renderer) { MessageRenderer.new("subdomain", "1234", 30) }

      it "should split the message to fit the window" do
        message =
          Message.new("id", Time.now, "TextMessage", "Eric", "testing out MessageRenderer")
        renderer.render_lines(message).should == ["Eric: testing out MessageRende", "rer"]
      end
    end

    it "should render text messages" do
      message = Message.new("id", Time.now, "TextMessage", "Eric", "testing out MessageRenderer")
      renderer.render(message).should == "Eric: testing out MessageRenderer"
    end

    it "should render enter messages" do
      message = Message.new("id", Time.now, "EnterMessage", "Eric", nil)
      renderer.render(message).should == "\tEric joined"
    end

    it "should render leave messages" do
      message = Message.new("id", Time.now, "LeaveMessage", "Eric", nil)
      renderer.render(message).should == "\tEric left"
    end

    it "should render timestamp messages" do
      message = Message.new("id", Time.new(2012, 12, 26, 10, 55, 3), "TimestampMessage", "", nil)
      renderer.render(message).should == "\t10:55"
    end

    it "should render paste messages" do
      renderer = MessageRenderer.new("subdomain", "1234")
      message =
        Message.new("5678", Time.now, "PasteMessage", "Eric", "a paste message\nwith two lines")
      renderer.render(message).should == "Eric (paste message):\na paste message\nwith two lines"
    end
  end
end
