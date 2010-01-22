module ActiveLucene
  module Index
    PATH = File.expand_path(File.dirname(__FILE__) + "/db/lucene/#{RAILS_ENV rescue ''}")

    def directory
      FSDirectory.open java.io.File.new(PATH)
    end
  end
end
