# frozen_string_literal: true

class DataMigration < ActiveRecord::Base
  validates :version, uniqueness: true
end
