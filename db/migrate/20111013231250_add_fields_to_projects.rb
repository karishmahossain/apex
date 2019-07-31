class AddFieldsToProjects < ActiveRecord::Migration
  def self.up
    add_column :projects, :university_id, :integer
    add_column :projects, :university_other, :string
    add_column :projects, :essay_prompt, :text
  end

  def self.down
    remove_column :projects, :university_id
    remove_column :projects, :university_other
    remove_column :projects, :essay_prompt
  end
end
