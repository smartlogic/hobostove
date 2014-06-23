require 'spec_helper'

describe Hobostove::Cli::Upgrade do
  describe ".upgrade_config?" do
    subject { Hobostove::Cli::Upgrade.upgrade_config? }

    before do
      FileUtils.mkdir_p(Dir.home(Etc.getlogin))
    end

    context "multiroom config" do
      before do
        File.open(Hobostove::Configuration.config_file, "w") do |file|
          settings = [{
            "subdomain" => "subdomain",
            "token" => "token",
            "room" => "Room"
          }]
          file.write settings.to_yaml
        end
      end

      specify { expect(subject).to be_falsy }
    end

    context "single room config" do
      before do
        File.open(Hobostove::Configuration.config_file, "w") do |file|
          settings = {
            "subdomain" => "subdomain",
            "token" => "token",
            "room" => "Room"
          }
          file.write settings.to_yaml
        end
      end

      specify { expect(subject).to be_truthy }
    end
  end

  describe "upgrading hobostove config" do
    before do
      FileUtils.mkdir_p(Dir.home(Etc.getlogin))
      File.open(Hobostove::Configuration.config_file, "w") do |file|
        file.write settings.to_yaml
      end
    end

    let(:settings) { {
      "subdomain" => "subdomain",
      "token" => "token",
      "room" => "Room"
    } }

    it "should turn the single room config into multi room config" do
      Hobostove::Cli::Upgrade.perform

      config = YAML.load(File.read(Hobostove::Configuration.config_file))
      expect(config.count).to eq(1)

      expect(config.first).to eq(settings)
    end
  end
end
