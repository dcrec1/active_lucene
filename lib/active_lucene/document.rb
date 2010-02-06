module ActiveLucene
  class Document
    PER_PAGE = 20

    attr_reader :attributes, :id, :highlight

    def initialize(attributes = {})
      @attributes = attributes.stringify_keys
      @highlight = @attributes.delete('highlight')
      @id = @attributes.delete('id') || object_id.to_s
    end

    def save
      document = org.apache.lucene.document.Document.new
      _all = []
      @attributes.each do |key, value|
        document.add Field.new key, value, Field::Store::YES, Field::Index::ANALYZED
        _all << value
      end
      document.add Field.new ID, @id, Field::Store::YES, Field::Index::NOT_ANALYZED
      document.add Field.new ALL, _all.join(' '), Field::Store::NO, Field::Index::ANALYZED
      document.add Field.new TYPE, self.class.to_s, Field::Store::YES, Field::Index::NOT_ANALYZED
      Index::Writer.write document
    end

    def destroy
      Index::Writer.delete @id
    end

    def update_attributes(new_attributes)
      destroy
      self.class.create! attributes.merge(new_attributes.merge(:id => @id))
    end
    alias :update_attributes! :update_attributes

    def to_param
      @id
    end
    
    def self.all
      find :all
    end

    def self.create!(attributes = {})
      returning new(attributes) do |model|
        model.save
      end
    end

    def self.find(param)
      if param.instance_of? Symbol
        search :all
      else
        search(:id => param).first
      end
    end

    def self.search(param, opts = {})
      Index::Searcher.search(param, opts)
    end

    def self.columns
      []
    end

    private

    def method_missing(method_name, *args)
      @attributes[method_name.to_s]
    end
  end
end
