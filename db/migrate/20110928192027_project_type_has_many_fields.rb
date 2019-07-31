class ProjectTypeHasManyFields < ActiveRecord::Migration
  def self.up
    create_table :project_types_users, :id => false do |t|
      t.references :user, :project_type
    end
  end

  def self.down
    drop_table :project_types_users
  end
end
