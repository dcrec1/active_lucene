module ActiveLucene
  class Reader < IndexReader
    include Index
    
    def self.open
      super directory
    end
  end
end