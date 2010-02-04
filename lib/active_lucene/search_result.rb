module ActiveLucene
  class SearchResult < Array
    attr_accessor :total_pages
    
    def add_document(attributes)
      self << eval(attributes.delete(TYPE)).new(attributes)
    end
    
    def suggest
      
    end
  end
end