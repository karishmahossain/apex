class University < ActiveRecord::Base
  # Associations
  has_many :users
  has_many :projects
  
  # Validations
  validates :name, :presence => true
  
  # Rails Admin
  rails_admin do
    label 'Universities'
    
    list do
      field :name
    end
    
    edit do
      field :name
    end
  end
  
  # Importer
  def csv_load
    file = "db/universities.csv"
    CSV.foreach(file,:col_sep => "\r") do |row|
       University.create(:name => row[0].to_s ) 
     end    
  end
  
end
