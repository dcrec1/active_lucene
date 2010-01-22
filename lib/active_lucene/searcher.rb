module ActiveLucene
  class Searcher < IndexSearcher
    include Index

    attr_reader :attributes, :total_pages

    def initialize
      super directory, true
    end

    def self.search(param)
      returning new do |searcher|
        searcher.search param
      end
    end

    def search(param)
      query = Query.for(param)
      top_docs = super(query, nil, Document::PER_PAGE)
      @attributes = top_docs.scoreDocs.map do |score_doc|
        attributes = {}
        doc(score_doc.doc).fields.each do |field|
          attributes.store field.name, field.string_value
          highlight = Highlighter.new(QueryScorer.new(query)).get_best_fragment(Analyzer.new, ALL, field.string_value)
          attributes[:highlight] = highlight if highlight
        end
        attributes
      end
      @total_pages = (top_docs.totalHits / Document::PER_PAGE.to_f).ceil
    end

  end
end
