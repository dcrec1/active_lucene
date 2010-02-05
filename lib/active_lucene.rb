require 'active_support'
require 'java_classes'

if defined? RAILS_ROOT
  APP_ROOT = RAILS_ROOT
  APP_ENV  = RAILS_ENV
elsif not defined? APP_ROOT
  APP_ROOT = '.'
  APP_ENV  = 'default'
end

%w(analyzer document index index/reader index/writer index/searcher dictionary query search_result suggest term).each do |name| 
  require "active_lucene/#{name}"
end

module ActiveLucene
  ID = 'id'
  ALL = '_all'
  TYPE = '_type'
end