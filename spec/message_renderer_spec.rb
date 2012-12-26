require 'spec_helper'

module Hobostove
  describe MessageRenderer do
    it "should render text messages" do
      message = Message.new("id", Time.now, "TextMessage", "Eric", "testing out MessageRenderer")
      MessageRenderer.render(message).should == "Eric: testing out MessageRenderer"
    end

    it "should render enter messages" do
      message = Message.new("id", Time.now, "EnterMessage", "Eric", nil)
      MessageRenderer.render(message).should == "\tEric joined"
    end

    it "should render leave messages" do
      message = Message.new("id", Time.now, "LeaveMessage", "Eric", nil)
      MessageRenderer.render(message).should == "\tEric left"
    end
  end
end
