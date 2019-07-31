class NotificationMailer < ActionMailer::Base
  default :from => "info.apexadmissions@gmail.com"
  
  #
  # Theses are called in the Service model ...............................................
  #
  
  # When a regular user register
  def welcome_email_regular(user)
    @user = user
    mail(:to => user.email, :subject => "Thank you for registering with ApexAdmissions.com!")
  end
  
  # When a mentor user register
  def welcome_email_mentor(user)
    @user = user
    mail(:to => user.email, :subject => "Your Mentor Application has been received!")
  end
  
  # When a mentor status changes
  def mentor_status_change(user)
    @user = user
    mail(:to => user.email, :subject => "Your mentor status has been updated")
  end
  
  #
  # ... and theses are called in the Project model ...............................................
  #
  
  
  # When there is a status change in a purchased service
  def service_status_change(service)
    @service = service
    @all_addresses = [service.user.email, service.mentor.email]
    mail(:to => @all_addresses, :subject => "Your Project Status has been updated")
  end
  
end
