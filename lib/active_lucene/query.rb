module ActiveLucene
  class Query

    def self.for(param)
      if param.instance_of? Hash
        for_attributes param
      elsif param.instance_of? Symbol
        MatchAllDocsQuery.new
      else
        for_string param
      end
    end

    private

    def self.for_attributes(attributes)
      returning BooleanQuery.new do |query|
        attributes.each do |key, value|
          query.add WildcardQuery.new(ActiveLucene::Term.for(key, value)), BooleanClause::Occur::MUST
        end
      end
    end

    def self.for_string(string)
      StandardQueryParser.new(Analyzer.new).parse(string, ALL)
    end
  end
end
