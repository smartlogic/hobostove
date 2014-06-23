require 'spec_helper'

describe Hobostove::Cli::Setup do
  describe "#run_setup?" do
    subject { Hobostove::Cli::Setup.run_setup? }

    context "config file exists" do
      before do
        FileUtils.mkdir_p(Dir.home(Etc.getlogin))
        FileUtils.touch(Hobostove::Configuration.config_file)
      end

      specify { expect(subject).to be_falsy }
    end

    context "config file does not exist" do
      specify { expect(subject).to be_truthy }
    end
  end

  describe "Setup" do
    let(:stdout) { StringIO.new }
    let(:stdin) { StringIO.new("subdomain\nkey\nroom\n") }

    before { FileUtils.mkdir_p(Dir.home(Etc.getlogin)) }

    subject { Hobostove::Cli::Setup.new(stdin, stdout) }

    it "should walk through setup" do
      subject.run

      config = YAML.load(File.read(Hobostove::Configuration.config_file))
      expect(config).to eq([{
        "subdomain" => "subdomain",
        "token" => "key",
        "room" => "room"
      }])
    end
  end
end
