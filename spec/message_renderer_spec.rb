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

    it "should render timestamp messages" do
      message = Message.new("id", Time.new(2012, 12, 26, 10, 55, 3), "TimestampMessage", "", nil)
      MessageRenderer.render(message).should == "\t10:55"
    end
  end
end
