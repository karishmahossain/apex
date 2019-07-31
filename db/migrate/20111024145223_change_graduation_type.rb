class ChangeGraduationType < ActiveRecord::Migration
  def self.up
    change_column :users, :graduation, :date
  end

  def self.down
    change_column :users, :graduation, :datetime
  end
end
