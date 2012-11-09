module FakeFS
  class Dir
    def self.home(user)
      "/Users/#{user}/"
    end
  end
end
