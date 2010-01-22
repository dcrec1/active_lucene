module ActiveLucene
  class Analyzer < StandardAnalyzer
    def initialize
      super Version::LUCENE_30
    end
  end
end
