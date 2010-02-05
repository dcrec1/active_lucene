module ActiveLucene
  module Index
    PATH = "#{APP_ROOT}/db/lucene/#{APP_ENV}"

    def self.directory
      FSDirectory.open java.io.File.new(PATH)
    end
  end
end