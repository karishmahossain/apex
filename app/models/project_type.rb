class ProjectType < ActiveRecord::Base
  # Associations
  has_many :projects
  has_and_belongs_to_many :users
  
  # Rails Admin
  rails_admin do
    label "Services"
    
    edit do
      field :name
      field :price
      field :description
      field :deal
    end
    
  end
  
end
