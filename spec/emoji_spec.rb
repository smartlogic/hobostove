require 'spec_helper'

module Hobostove
  describe Emoji do
    before do
      FakeFS.deactivate!
    end

    specify "substitute unicode emoji into a string" do
      expect(Emoji.replace("This is :cool:")).to eq("This is \u{1F192}")
    end
  end
end
