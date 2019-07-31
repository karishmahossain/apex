class CreateProjectTypes < ActiveRecord::Migration
  def self.up
    create_table :project_types do |t|
      t.string :name
      t.decimal :price
      t.text :description
      t.boolean :deal

      t.timestamps
    end
  end

  def self.down
    drop_table :project_types
  end
end
