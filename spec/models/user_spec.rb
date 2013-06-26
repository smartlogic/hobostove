require 'spec_helper'

module Hobostove::Models
  describe User do
    describe "#convert" do
      subject { User.convert(user_data) }

      let(:user_data) { {
        :name => "Eric",
        :id => 10
      } }

      its(:name) { should == "Eric" }
      its(:id) { should == 10 }

      context "empty hash" do
        subject { User.convert({}) }

        its(:name) { should be_nil }
        its(:id) { should be_nil }
      end
    end

    describe "#eql?" do
      it "should make same ids be equal" do
        user_1 = User.new(10, "Eric")
        user_2 = User.new(10, "Eric")

        user_1.should be_eql(user_2)
      end

      it "should make differing ids not be equal" do
        user_1 = User.new(10, "Eric")
        user_2 = User.new(11, "Not Eric")

        user_1.should_not be_eql(user_2)
      end
    end

    describe "#hash" do
      it "should use the id for the hash" do
        user = User.new(10, "Eric")

        user.hash.should == 10.hash
      end
    end
  end
end
