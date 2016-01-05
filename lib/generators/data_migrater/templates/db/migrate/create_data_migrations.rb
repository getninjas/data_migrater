class CreateDataMigrations < ActiveRecord::Migration
  def change
    create_table :data_migrations do |t|
      t.string :version, null: false
    end
  end
end
