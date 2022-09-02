# frozen_string_literal: true

require_relative 'lib/active_similar/version'

Gem::Specification.new do |spec|
  spec.name          = 'active_similar'
  spec.version       = ActiveSimilar::VERSION
  spec.authors       = ['Jonian Guveli']
  spec.email         = ['jonian@hardpixel.eu']

  spec.summary       = 'Find similar Active Record models through their associations'
  spec.description   = 'Find similar Active Record models through most common associations.'
  spec.homepage      = 'https://github.com/hardpixel/active_similar'
  spec.license       = 'MIT'

  spec.files         = Dir['lib/**/*', '*.{md,txt}']
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 2.6'

  spec.add_dependency 'activerecord', '>= 5.2'

  spec.add_development_dependency 'bundler', '~> 2.0'
  spec.add_development_dependency 'minitest', '~> 5.0'
  spec.add_development_dependency 'rake', '~> 13.0'
end
