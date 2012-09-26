# -*- encoding: utf-8 -*-
require File.expand_path('../lib/chai-backbone-rails/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Matthijs Groen"]
  gem.email         = ["matthijs.groen@gmail.com"]
  gem.description   = %q{Chai.js matchers for Backbone.js framework}
  gem.summary       = %q{A set of assertion matchers to test Backbone code using Konacha in Rails}
  gem.homepage      = "https://github.com/matthijsgroen/chai-backbone-rails"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "chai-backbone-rails"
  gem.require_paths = ["lib"]
  gem.version       = Chai::Backbone::Rails::VERSION
end
