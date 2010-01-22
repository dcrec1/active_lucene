require 'java'
require 'rubygems'
require 'active_support'

Dir[File.expand_path(File.dirname(__FILE__) + "/*.jar")].each { |path| require path.split('/').last.gsub('.jar', '') }
import org.apache.lucene.document.Field
import org.apache.lucene.store.FSDirectory
import org.apache.lucene.index.IndexWriter
import org.apache.lucene.analysis.standard.StandardAnalyzer
import org.apache.lucene.queryParser.standard.StandardQueryParser

import org.apache.lucene.search.IndexSearcher
import org.apache.lucene.search.BooleanClause
import org.apache.lucene.search.BooleanQuery
import org.apache.lucene.search.MatchAllDocsQuery
import org.apache.lucene.search.WildcardQuery

import org.apache.lucene.search.highlight.QueryScorer
import org.apache.lucene.search.highlight.Highlighter

import org.apache.lucene.util.Version

APP_ROOT ||= RAILS_ROOT if defined?(RAILS_ROOT)
APP_ENV ||= RAILS_ENV if defined?(RAILS_ENV)

%w(analyzer document index query searcher term writer).each { |name| require "active_lucene/#{name}" }

module ActiveLucene
  ID = 'id'
  ALL = '_all'
end
