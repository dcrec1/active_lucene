module ActiveLucene
  module Index
    class Reader < IndexReader
      def self.open
        super Index.directory
      end
    end
  end
end