#encoding: utf-8

source 'https://rubygems.org'

if RUBY_VERSION > '1.9'
  gem 'levenshtein-c'
else
  gem 'levenshtein'
end
gem 'htmlentities'

group :test, :development do
  gem 'rspec', :require => 'spec'
  gem "simplecov"
  gem 'awesome_print'
end