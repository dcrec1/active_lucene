module ActiveLucene
  class SearchResult < Array
    include Dictionary
    
    attr_reader :query
    attr_accessor :total_pages
    
    def initialize(query)
      @query = query
    end
    
    def add_document(attributes)
      self << eval(attributes.delete(TYPE)).new(attributes)
    end
    
    def suggest
      spell_checker = SpellChecker.new directory
      spell_checker.index_dictionary LuceneDictionary.new(Index::Reader.open, ALL)
      query.split(' ').map do |word|
        spell_checker.suggest_similar(word, 1).first || word
      end.join(' ')
    end
  end
end