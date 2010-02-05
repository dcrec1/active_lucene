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