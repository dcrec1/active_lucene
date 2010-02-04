$:.unshift(File.dirname(__FILE__) + "/../lib")

APP_ROOT = File.dirname(__FILE__)
APP_ENV = 'test'

require 'active_lucene'

def index_path
  ActiveLucene::Index::PATH
end

def clean_index
  system "rm -Rf #{index_path}"
end

def directory
  file = java.io.File.new index_path
  org.apache.lucene.store.FSDirectory.open file
end

def get_writer
  analizer = org.apache.lucene.analysis.SimpleAnalyzer.new
  writer = org.apache.lucene.index.IndexWriter
  writer.new directory, analizer, true, writer::MaxFieldLength::UNLIMITED
end

def get_field(name, value)
  field = org.apache.lucene.document.Field
  field.new name, value, field::Store::YES, field::Index::ANALYZED
end

def search(params)
  searcher = org.apache.lucene.search.IndexSearcher.new directory, true
  term = org.apache.lucene.index.Term.new params.keys.first.to_s, params.values.first
  query = org.apache.lucene.search.TermQuery.new(term)
  searcher.search(query, nil, 10).scoreDocs.map do |score_doc|
    searcher.doc score_doc.doc
  end
end
