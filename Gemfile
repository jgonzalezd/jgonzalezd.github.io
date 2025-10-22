# frozen_string_literal: true

source "https://rubygems.org"

gem "jekyll-theme-chirpy", "~> 7.3"

gem 'jekyll-compose', group: [:jekyll_plugins]

gem "html-proofer", "~> 5.0", group: :test

platforms :mingw, :x64_mingw, :mswin, :jruby do
  gem "tzinfo", ">= 1", "< 3"
  gem "tzinfo-data"
end

gem "wdm", "~> 0.2.0", :platforms => [:mingw, :x64_mingw, :mswin]

# Development utilities for auto taxonomy task
group :development do
  gem "front_matter_parser", "~> 1.0"
  gem "pragmatic_tokenizer", "~> 0.4"
  gem "engtagger", "~> 0.2"
  gem "tf-idf-similarity", "~> 0.1"
  gem "activesupport", "~> 7.1"
end
