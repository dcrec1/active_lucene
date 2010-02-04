module ActiveLucene
  module Dictionary
    PATH = "#{Index::PATH}/dictionary"
    
    def directory
      FSDirectory.open java.io.File.new(PATH)
    end
  end
end