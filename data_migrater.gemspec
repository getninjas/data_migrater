# frozen_string_literal: true

lib = File.expand_path('../lib', __FILE__)

$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'data_migrater/version'

Gem::Specification.new do |spec|
  spec.authors     = ['Washington Botelho', 'GetNinjas']
  spec.description = 'Generates Data Migrations on Migrate style.'
  spec.email       = ['wbotelhos@gmail.com', 'tech@getninjas.com.br']
  spec.files       = Dir['lib/**/*'] + %w[CHANGELOG.md LICENSE README.md]
  spec.homepage    = 'https://github.com/getninjas/data_migrater'
  spec.license     = 'MIT'
  spec.name        = 'data_migrater'
  spec.platform    = Gem::Platform::RUBY
  spec.summary     = 'A Data Migrator gem'
  spec.test_files  = Dir['spec/**/*']
  spec.version     = DataMigrater::VERSION

  spec.add_dependency 'activerecord', '>= 4.1', '< 6'
  spec.add_dependency 'railties',     '>= 4.1', '< 6'
  spec.add_dependency 'smarter_csv',  '~> 1.1'
  spec.add_dependency 'aws-sdk',      '~> 2.9'

  spec.add_development_dependency 'pry-byebug'
  spec.add_development_dependency 'rspec-rails'
  spec.add_development_dependency 'rubocop-rspec'
  spec.add_development_dependency 'sqlite3'
end
