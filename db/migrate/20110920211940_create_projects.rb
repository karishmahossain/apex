class CreateProjects < ActiveRecord::Migration
  def self.up
    create_table :projects do |t|
      t.integer :user_id
      t.integer :mentor_id
      t.string :status
      t.datetime :date_accepted
      t.datetime :date_completed
      t.integer :project_type_id

      t.timestamps
    end
  end

  def self.down
    drop_table :projects
  end
end
