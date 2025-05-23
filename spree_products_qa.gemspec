# encoding: UTF-8
lib = File.expand_path('../lib/', __FILE__)
$LOAD_PATH.unshift lib unless $LOAD_PATH.include?(lib)

require 'spree_products_qa/version'

Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'spree_products_qa'
  s.version     = SpreeProductsQa::VERSION
  s.summary     = 'Spree extension that adds Q&A support for products'
  s.required_ruby_version = '>= 3.0'

  s.author    = 'Truemark'
  s.email     = 'hello@trueamark.dev'
  s.homepage  = 'https://github.com/your-github-handle/spree_products_qa'
  s.license = 'BSD-3-Clause'

  s.files        = `git ls-files`.split("\n").reject { |f| f.match(/^spec/) && !f.match(/^spec\/fixtures/) }
  s.require_path = 'lib'
  s.requirements << 'none'

  s.add_dependency 'spree', '>= 5.0.3'
  s.add_dependency 'spree_extension'

  s.add_development_dependency 'spree_dev_tools'
end
