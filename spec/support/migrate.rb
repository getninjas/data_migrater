# frozen_string_literal: true

ActiveRecord::Schema.define do
  create_table :data_migrations do |t|
    t.string :version, null: false
  end
end
