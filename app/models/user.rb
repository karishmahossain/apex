class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :first_name, :last_name, :photo, :resume, :writing_sample, :is_mentor, :university_id, :university_other, :bio, :SAT_score, :major_list, :areas_of_expertise_list, :paypal_account, :skype_id, :phone_number, :mentor_status, :ACT_score, :GMAT_score, :LSAT_score, :MCAT_score, :GRE_score, :clubs, :awards, :graduation, :gpa, :other_accepted_universities
  
  attr_protected [:admin], :as => :admin
  
  MENTOR_STATUS_OPTIONS = %w{Pending Available Unavailable}

   
  attr_protected [:mentor_status], :as => :admin, :if => :mentor_status.nil? || :mentor_status == MENTOR_STATUS_OPTIONS[0]
    
  # Associations
  belongs_to :university
  has_many :projects
  has_and_belongs_to_many :project_types

  # Presence
  validates_presence_of :first_name, :last_name
  validates_presence_of :graduation, :bio, :major_list, :areas_of_expertise_list, :paypal_account, :clubs, :if => :is_mentor?

  # University
  validate :university_present?, :if => :is_mentor?
  def university_present?
    if university_id.blank? && university_other.blank?
      errors.add(:university_id, "can't be blank, please either select a school or type in your own.")
    end
  end

  # SAT/ACT
  validate :sat_act_present?, :if => :is_mentor?
  def sat_act_present?
    if self.SAT_score.nil? && self.ACT_score.nil?
      errors.add(:SAT_score, "can't be blank")
      errors.add(:ACT_score, "")
    else
      validates_inclusion_of :SAT_score, :in => 0..2400, :message => "must be between 0 and 2400." if self.SAT_score
      validates_inclusion_of :ACT_score, :in => 0..36, :message => "must be between 0 and 36." if self.ACT_score
    end
  end
  
  
  validates_inclusion_of :gpa, :in => 0..4.0, :message => "must be between 0 and 4.0.", :if => :is_mentor? && :gpa?
  validates_inclusion_of :LSAT_score, :in => 0..180, :message => "must be between 0 and 180.", :if => :is_mentor? && :LSAT_score?
  validates_inclusion_of :GMAT_score, :in => 0..800, :message => "must be between 0 and 800.", :if => :is_mentor? && :GMAT_score?


  # Phone Number Validation
  validates_format_of :phone_number,
    :message => "must be a valid US telephone number.",
    :with => /^ *\(?\d{3}\)? ?[\-\.]? ?\d{3} ?[\-\.]? ?\d{4} *$/ # fancy regex
  
  # Email Validation (for mentor)
  validates_format_of :email,
    :with => /\A([\w\.%\+\-]+)@([\w\-]+\.)+edu$/i,
    :if => :is_mentor?


  # Files Uploads
  has_attached_file :photo, 
    :styles => { 
      :medium => "175x300>", 
      :thumb => "120x120#"
    },
    :storage => :s3,
    :s3_credentials => S3_CREDENTIALS,
    :path => ":class/:attachment/:id_:style.:extension",
    :default_url => "/images/default.jpg"

  validates_attachment_size :photo, :less_than => 1.megabyte
  validates_attachment_content_type :photo, :content_type => ['image/jpg', 'image/jpeg', 'image/png', 'image/gif']
   
  
  has_attached_file :resume, 
    :url => "/assets/:class/:id/:style/:basename.:extension",
    :storage => :s3,
    :s3_credentials => S3_CREDENTIALS

  validates_attachment_size :resume, :less_than => 1.megabyte
  validates_attachment_content_type :resume, :content_type => [
      'application/pdf', 'text/plain',
      'application/msword',
      'application/vnd.openxmlformats-officedocument.wordprocessingml.document'
  ]

  has_attached_file :writing_sample,
    :url => "/assets/:class/:id/:style/:basename.:extension",
    :storage => :s3,
    :s3_credentials => S3_CREDENTIALS
    
  validates_attachment_size :writing_sample, :less_than => 1.megabyte
  validates_attachment_content_type :writing_sample, :content_type => [
      'application/pdf', 'text/plain',
      'application/msword',
      'application/vnd.openxmlformats-officedocument.wordprocessingml.document'
  ]
  
  # Validate Presence of File Attachement
    validates_attachment_presence :photo, :if => Proc.new{|o| o.is_mentor == true }
    validates_attachment_presence :resume, :if => Proc.new{|o| o.is_mentor == true }
    validates_attachment_presence :writing_sample, :if => Proc.new{|o| o.is_mentor == true }

  # Tagging
  acts_as_taggable
  acts_as_taggable_on :majors, :areas_of_expertise
  
 
  
  def is_pending?
    self.mentor_status == MENTOR_STATUS_OPTIONS[0]
  end
  
  def is_available?
    return true if self.mentor_status == MENTOR_STATUS_OPTIONS[1]
  end
  
  def is_unavailable?
    return true if self.mentor_status == MENTOR_STATUS_OPTIONS[2]
  end
  
  # Scopes
  scope :mentors, where("is_mentor = ? AND mentor_status != ?", true, MENTOR_STATUS_OPTIONS[0])
  scope :mentors_pending, where(:is_mentor => true, :mentor_status => MENTOR_STATUS_OPTIONS[0])
  scope :mentors_available, where(:is_mentor => true, :mentor_status => MENTOR_STATUS_OPTIONS[1])
  scope :mentors_unavailable, where(:is_mentor => true, :mentor_status => MENTOR_STATUS_OPTIONS[2])
  
  def full_name
    return "#{first_name} #{last_name}"
  end
  
  def university_selected
    if university
      return university.name
    elsif university_other
      return university_other
    else
      return nil
    end
    
  end

  
  before_create :if_mentor_mentor_status
  
  def if_mentor_mentor_status
    if self.is_mentor? == nil
      self.mentor_status = nil
    elsif self.is_mentor? && self.mentor_status.nil?
      self.mentor_status = MENTOR_STATUS_OPTIONS[0]
    end    
  end
  
  # bypasses Devise's requirement to re-enter current password to edit
  def update_with_password(params={}) 
    if params[:password].blank? 
      params.delete(:password) 
      params.delete(:password_confirmation) if params[:password_confirmation].blank? 
    end 
    update_attributes(params) 
  end
  
  
  # Mailers ..................................................................................
  
  after_create :mail_after_user_creation
  after_update :mail_mentor_status_update
  
  def mail_after_user_creation
    if self.is_mentor?
      # Mentor Registration
      NotificationMailer.welcome_email_mentor(self).deliver
    else
      # Is a regular user...
      NotificationMailer.welcome_email_regular(self).deliver
    end
  end
  
  # ---
  
  def mail_mentor_status_update
    # Notify mentor that his/her status have changed
    NotificationMailer.mentor_status_change(self).deliver if self.mentor_status_changed?
  end
  
  # ---
  
  
  
  
  # Rails Admin ...............................................................................
  rails_admin do
    label 'Users'
    
    # List
    list do
      
      field :id
      field :is_mentor do
        label "Mentor"
      end
      field :mentor_status
      field :full_name
      field :email
    end
    
    # Edit
    edit do
      
      group :basic_information do
        field :first_name
        field :last_name
        field :email
        field :password
        field :password_confirmation
        field :phone_number
        field :skype_id
      end
      
      group :mentor_information do
        field :photo
        field :university
        field :university_other
        field :other_accepted_universities
        field :gpa
        field :graduation
        field :bio
        field :clubs
        field :awards
        field :SAT_score
        field :ACT_score
        field :GMAT_score
        field :LSAT_score
        field :MCAT_score
        field :GRE_score
        field :major_list
        field :areas_of_expertise_list
        field :resume
        field :writing_sample
        field :paypal_account
        field :is_mentor
        # field :active_mentor
        field :mentor_status, :enum do
          required true
          help 'The user will be notifying via e-mail of any changes in his/her mentor status.'
          enum do
            User::MENTOR_STATUS_OPTIONS
          end
        end
      end
      
      group :services do
        field :project_types
      end
      
      group :admin_access do
        field :admin
      end
      
    end
    
    show do
      group :basic_information do
        field :full_name
        field :email
        field :phone_number
        field :skype_id
      end
      
      group :mentor_information do
        
        field :photo

        unless :university.nil?
          field :university
        else
          field :university_other
        end
        
        field :other_accepted_universities
        field :gpa
        field :graduation
        field :bio
        field :clubs
        field :awards
        field :SAT_score
        field :ACT_score
        field :GMAT_score
        field :LSAT_score
        field :MCAT_score
        field :GRE_score
        field :major_list
        field :areas_of_expertise_list do
          label "Expertise"
        end
        field :resume
        field :writing_sample
        field :paypal_account
        field :is_mentor do
          label "User a mentor?"
        end
        # field :active_mentor
        field :mentor_status
      end
      
      group :services do
        field :project_types
      end
      
      group :projects do
        field :projects
      end
      
      
    end
    
  end  
  
  
  
end
