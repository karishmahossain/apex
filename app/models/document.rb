class Document < ActiveRecord::Base
  
  belongs_to :project
  
  has_attached_file :file, 
    :storage => :s3,
    :s3_credentials => S3_CREDENTIALS,
    :path => ":class/:attachment/:id_:style.:extension"
    
  validates_attachment_size :file, :less_than => 5.megabyte
  validates_attachment_content_type :file, :content_type => [
      'application/pdf', 'text/plain',
      'application/msword',
      'application/vnd.openxmlformats-officedocument.wordprocessingml.document'
  ]
  validates_attachment_presence :file
  
  # RailsAdmin .......................................................................................
  
  rails_admin do
    visible false
  end
  
end
