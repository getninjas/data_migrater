class DataMigration < ActiveRecord::Base
  validates :version, uniqueness: true
end
