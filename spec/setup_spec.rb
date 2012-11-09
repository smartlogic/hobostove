require 'spec_helper'

describe Hobostove::Setup do
  describe "#run_setup?" do
    subject { Hobostove::Setup.run_setup? }

    context "config file exists" do
      before do
        FileUtils.mkdir_p(Dir.home(Etc.getlogin))
        FileUtils.touch(Hobostove::Configuration.config_file)
      end

      it { should be_false }
    end

    context "config file does not exist" do
      it { should be_true }
    end
  end
end
