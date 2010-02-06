module ActiveLucene
  module Index
    class Searcher < IndexSearcher
      def self.search(param, opts = {})
        new.search param, opts
      end

      def initialize
        super Index.directory, true
      end

      def search(param, opts)
        query = Query.for(param)
        highlighter = Highlighter.new(QueryScorer.new(query))
        top_docs = super(query, nil, Document::PER_PAGE)
        returning SearchResult.new(param) do |search_result|
          top_docs.scoreDocs.each do |score_doc|
            attributes = {}
            doc(score_doc.doc).fields.each do |field|
              attributes.store field.name, field.string_value
              highlight = highlighter.get_best_fragment(Analyzer.new, ALL, field.string_value)
              attributes[:highlight] = highlight if highlight
            end
            search_result.add_document attributes
          end
          search_result.current_page = opts[:page] || 1
          search_result.total_pages = (top_docs.totalHits / Document::PER_PAGE.to_f).ceil
        end
      end
    end
  end
end
