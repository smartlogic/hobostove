require 'csv'

module Hobostove
  class Emoji
    def self.replace(string)
      csv = File.expand_path("../../../data/emoji.csv", __FILE__)
      CSV.foreach(csv) do |row|
        if string =~ /:#{row[0]}:/
          character = [row[1].hex].pack("U")
          string.gsub!(":#{row[0]}:", character)
        end
      end

      string
    end
  end
end
