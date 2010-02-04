module ActiveLucene
  class Searcher < IndexSearcher
    include Index

    attr_reader :attributes, :total_pages

    def initialize
      super directory, true
    end

    def search(param)
      search_result = SearchResult.new param
      query = Query.for(param)
      top_docs = super(query, nil, Document::PER_PAGE)
      top_docs.scoreDocs.each do |score_doc|
        attributes = {}
        doc(score_doc.doc).fields.each do |field|
          attributes.store field.name, field.string_value
          highlight = Highlighter.new(QueryScorer.new(query)).get_best_fragment(Analyzer.new, ALL, field.string_value)
          attributes[:highlight] = highlight if highlight
        end
        search_result.add_document attributes
      end
      search_result.total_pages = (top_docs.totalHits / Document::PER_PAGE.to_f).ceil
      search_result
    end
  end
end
