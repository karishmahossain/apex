require 'net/https'
require 'open-uri'

class ProjectsController < ApplicationController
  
  before_filter :authenticate_user!
  load_and_authorize_resource
  
  def index
    unless current_user.is_mentor?
      @projects = current_user.projects.order("created_at").page(params[:page]).per(10)
    else
      @projects = Project.where(:mentor_id => current_user.id).order("created_at").page(params[:page]).per(10)
      
      @feeds = Feed.limit(3).reverse
    end
           
    @services = current_user.project_types
  end
  
  
  def update
    @project = Project.where(:id => params[:id], :mentor_id => current_user.id).first
    if @project.update_attributes(params[:project]) 
      redirect_to :back, :success => "The service has been updated."
    else
      redirect_to :back, :alert => "We couldn't process your request. #{@project.errors.collect{|x,m| "#{x} #{m}. ".capitalize}.join}"
    end
  end
  
  def show
    @project = Project.find(params[:id])
  end
  
  
  def create
    @project = Project.new(params[:project])
    @project.user_id = current_user.id
    @project.status = "Pending"
    
    if @project.save
      
      # Send to PayPal
      url = "https://www.paypal.com/cgi-bin/webscr" # Production 
      sandbox_url = "https://www.sandbox.paypal.com/cgi-bin/webscr" # Sandbox
      
      paypal_url = url # "url" for production; "sandbox_url" for testing
      paypal_url += "?cmd=_xclick"
      paypal_url += "&business=info@apexadmissions.com"
      paypal_url += "&currenct_code=USD&item_name#{@project.project_type.name}"
      paypal_url += "&amount=#{@project.project_type.price}"
      paypal_url += "&item_number=#{@project.id}"
      paypal_url += "&item_name=#{@project.project_type.name}"
      paypal_url += "&return=#{projects_url}"
      
      redirect_to URI.encode(paypal_url)

    else
      # not created
      flash[:alert] = "We couldn't process your request. #{@project.errors.collect{|x,m| "#{x} #{m}. ".capitalize}.join}"
      redirect_to :back
    end
    
  end
end
