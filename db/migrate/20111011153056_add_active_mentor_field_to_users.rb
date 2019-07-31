class AddActiveMentorFieldToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :active_mentor, :boolean
  end

  def self.down
    remove_column :users, :active_mentor
  end
end
