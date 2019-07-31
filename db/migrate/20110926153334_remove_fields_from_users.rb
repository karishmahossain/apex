class RemoveFieldsFromUsers < ActiveRecord::Migration
  def self.up
    remove_column :users, :essay_file_name
    remove_column :users, :essay_content_type
    remove_column :users, :essay_file_size
    remove_column :users, :essay_updated_at
  end

  def self.down
    add_column :users, :essay_file_name, :string
    add_column :users, :essay_content_type, :string
    add_column :users, :essay_file_size, :integer
    add_column :users, :essay_updated_at, :datetime
  end
end
