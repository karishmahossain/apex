class AddMoreFieldsToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :ACT_score, :integer
    add_column :users, :GMAT_score, :integer
    add_column :users, :LSAT_score, :integer
    add_column :users, :MCAT_score, :integer
    add_column :users, :GRE_score, :integer
    add_column :users, :clubs, :string
    add_column :users, :awards, :string
    add_column :users, :graduation, :datetime
    add_column :users, :gpa, :decimal
    add_column :users, :other_accepted_universities, :string
  end

  def self.down
    remove_column :users, :ACT_score
    remove_column :users, :GMAT_score
    remove_column :users, :LSAT_score
    remove_column :users, :MCAT_score
    remove_column :users, :GRE_score
    remove_column :users, :clubs
    remove_column :users, :awards
    remove_column :users, :graduation
    remove_column :users, :gpa
    remove_column :users, :other_accepted_universities
  end
end
