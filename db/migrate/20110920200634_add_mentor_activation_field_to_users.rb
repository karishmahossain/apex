class AddMentorActivationFieldToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :is_mentor, :boolean
  end

  def self.down
    remove_column :users, :is_mentor
  end
end
