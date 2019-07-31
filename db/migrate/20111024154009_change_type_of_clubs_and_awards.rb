class ChangeTypeOfClubsAndAwards < ActiveRecord::Migration
  def self.up
    change_column :users, :clubs, :text
    change_column :users, :awards, :text
  end

  def self.down
    change_column :users, :clubs, :string
    change_column :users, :awards, :string
  end
end
