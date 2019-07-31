class Project < ActiveRecord::Base
  # Associations
  belongs_to :project_type
  belongs_to :user
  belongs_to :university
  belongs_to :mentor, :class_name => "User", :foreign_key => "mentor_id"
  
  has_many :documents, :dependent => :destroy
  accepts_nested_attributes_for :documents, :allow_destroy => true
  
  validates :documents, :presence => true
  
  validate :any_present?
  
  def any_present?
    if university.blank? && university_other.blank?
      errors.add(:university, "can't be blank, please select the school you are applying to")
    else
      #...
    end
  end
  
  PROJECT_STATUS =  ["Pending", "Accepted", "In Progress", "Completed"]
  
  def project_status
    PROJECT_STATUS
  end

  
  # Mailers .........................................................................................
  
  after_update :mail_service_status_update
  
  # ---
  
  def mail_service_status_update
    NotificationMailer.service_status_change(self).deliver if self.status_changed?
  end
  
  # RailsAdmin .......................................................................................
  
  rails_admin do
    
    list do
      field :user
      field :mentor
      field :status
      field :date_accepted
      field :date_completed
      field :project_type do
        label "Service Name"
      end
    end
    
    show do
      field :user
      field :mentor
      field :status
      field :documents
      field :date_accepted
      field :date_completed
      field :project_type do
        label "Service Name"
      end
    end
    
    edit do
      field :user
      field :mentor
      field :status, :enum do
        enum do
          PROJECT_STATUS
        end
      end
      field :date_accepted
      field :date_completed
      field :project_type do
        label "Service Name"
      end
    end
  end
end
