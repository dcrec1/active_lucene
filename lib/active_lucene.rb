require 'java'
require 'rubygems'
require 'active_support'

Dir[File.expand_path(File.dirname(__FILE__) + "/*.jar")].each do |path| 
  require path.split('/').last.gsub('.jar', '')
end

import org.apache.lucene.document.Field

import org.apache.lucene.store.FSDirectory

import org.apache.lucene.index.IndexReader
import org.apache.lucene.index.IndexWriter

import org.apache.lucene.analysis.standard.StandardAnalyzer

import org.apache.lucene.queryParser.standard.StandardQueryParser

import org.apache.lucene.search.IndexSearcher
import org.apache.lucene.search.BooleanClause
import org.apache.lucene.search.BooleanQuery
import org.apache.lucene.search.MatchAllDocsQuery
import org.apache.lucene.search.WildcardQuery

import org.apache.lucene.search.spell.LuceneDictionary;
import org.apache.lucene.search.spell.SpellChecker;

import org.apache.lucene.search.highlight.QueryScorer
import org.apache.lucene.search.highlight.Highlighter

import org.apache.lucene.util.Version

if defined? RAILS_ROOT
  APP_ROOT = RAILS_ROOT
  APP_ENV  = RAILS_ENV
elsif not defined? APP_ROOT
  APP_ROOT = '.'
  APP_ENV  = 'default'
end

%w(analyzer document index dictionary query reader search_result searcher suggest term writer).each do |name| 
  require "active_lucene/#{name}"
end

module ActiveLucene
  ID = 'id'
  ALL = '_all'
  TYPE = '_type'
end