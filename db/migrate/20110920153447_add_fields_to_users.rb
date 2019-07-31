class AddFieldsToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :phone_number, :string
    add_column :users, :skype_id, :string
    add_column :users, :SAT_score, :integer
    add_column :users, :university_other, :string
    add_column :users, :paypal_account, :string
    add_column :users, :bio, :text
  end

  def self.down
    remove_column :users, :bio
    remove_column :users, :paypal_account
    remove_column :users, :university_other
    remove_column :users, :SAT_score
    remove_column :users, :skype_id
    remove_column :users, :phone_number
  end
end
