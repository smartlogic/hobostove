require 'spec_helper'

describe Hobostove::Line do
  specify "taking the first n characters of the line" do
    line = Hobostove::Line.new.tap do |line|
      line.add(:cyan, "Eric: ")
      line.add(:white, "howdy")
    end

    expect(line.first(3).to_s).to eq("Eri")
    expect(line.first(8).to_s).to eq("Eric: ho")
    expect(line.first(11).to_s).to eq("Eric: howdy")
    expect(line.first(12).to_s).to eq("Eric: howdy")
  end

  specify "splitting by console size" do
    line = Hobostove::Line.new.tap do |line|
      line.add(:cyan, "Eric: ")
      line.add(:white, "howdy")
    end

    expect(line.split(5).map(&:to_s)).to eq(["Eric:", " howd", "y"])
  end
end
