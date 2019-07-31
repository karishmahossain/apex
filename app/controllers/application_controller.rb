class ApplicationController < ActionController::Base
  protect_from_forgery
  
  rescue_from CanCan::AccessDenied do |exception|
      redirect_to root_url, :alert => exception.message
  end
   
  def after_sign_in_path_for(resource)
    current_user.admin? ? rails_admin_dashboard_path : projects_path
  end
  
  
  before_filter :global_variables
  before_filter :mailer_set_url_options
  
  def global_variables
    if current_user
      if current_user.is_mentor
        @projects_count = Project.where(:mentor_id => current_user.id).count
      else
        @projects_count = current_user.projects.count
      end
    end
  end

  def mailer_set_url_options
    ActionMailer::Base.default_url_options[:host] = request.host_with_port
  end
  
  
end
