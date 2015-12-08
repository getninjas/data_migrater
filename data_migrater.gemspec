lib = File.expand_path('../lib', __FILE__)

$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'data_migrater/version'

Gem::Specification.new do |spec|
  spec.author      = "GetNinjas"
  spec.description = 'Generates Data Migrations on Migrate style.'
  spec.email       = "tech@getninjas.com.br"
  spec.files       = Dir.glob("{lib}/**/*") + %w[CHANGELOG.md LICENSE README.md]
  spec.homepage    = 'https://github.com/getninjas/data_migrater'
  spec.license     = 'MIT'
  spec.name        = 'data_migrater'
  spec.platform    = Gem::Platform::RUBY
  spec.summary     = 'A Data Migrator gem'
  spec.test_files  = Dir.glob("{spec}/**/*")
  spec.version     = DataMigrater::VERSION.dup

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'pry-byebug'
  spec.add_development_dependency 'rails'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'sqlite3'
end
