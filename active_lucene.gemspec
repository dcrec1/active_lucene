# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{active_lucene}
  s.version = "0.6"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Diego Carrion"]
  s.date = %q{2010-06-10}
  s.email = %q{dc.rec1@gmail.com}
  s.files = ["lib/active_lucene", "lib/active_lucene/analyzer.rb", "lib/active_lucene/dictionary.rb", "lib/active_lucene/document.rb", "lib/active_lucene/index", "lib/active_lucene/index/reader.rb", "lib/active_lucene/index/searcher.rb", "lib/active_lucene/index/writer.rb", "lib/active_lucene/index.rb", "lib/active_lucene/query.rb", "lib/active_lucene/search_result.rb", "lib/active_lucene/suggest.rb", "lib/active_lucene/term.rb", "lib/active_lucene.rb", "lib/java_classes.rb", "lib/lucene-core-3.0.0.jar", "lib/lucene-highlighter-3.0.0.jar", "lib/lucene-memory-3.0.0.jar", "lib/lucene-queryparser-3.0.0.jar", "lib/lucene-spellchecker-3.0.0.jar", "Rakefile", "README.textile"]
  s.homepage = %q{http://www.diegocarrion.com}
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.6}
  s.summary = %q{ActiveRecord/ActiveModel's like interface for Lucene}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
