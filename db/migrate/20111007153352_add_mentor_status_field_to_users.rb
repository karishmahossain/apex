class AddMentorStatusFieldToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :mentor_status, :string
  end

  def self.down
    remove_column :users, :mentor_status
  end
end
