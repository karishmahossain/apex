class MentorsController < ApplicationController
  
  before_filter :authenticate_user!, :only => [:update]
  load_and_authorize_resource :class => User
  
  def index
    @mentors = User.mentors_available.order("created_at").page(params[:page]).per(16)
    @universities = University.find(:all, :order => "name")
    @majors = Project.connection.select_all("SELECT DISTINCT tags.id, tags.name FROM tags JOIN taggings ON taggings.tag_id = tags.id WHERE context = 'majors' ORDER BY tags.name")
    
    
    if params[:by_school] && params[:by_school] != ""
      @mentors = @mentors.where(:university_id => params[:by_school])
    end
    
    if params[:by_major] && params[:by_major] != ""
      @mentors = @mentors.tagged_with(params[:by_major], :on => :majors)
    end
    
    @filter_params = [ :by_major => params[:by_major], :by_school => params[:by_school] ]
    
  end
  
  def update
    @mentor = User.mentors.find(params[:id])
    if @mentor.update_attributes(params[:user])
      redirect_to :back, :success => "Your changes have beens saved."
    else
      redirect_to :back, :success => "We are sorry but we couldn't save your changes. Please try again."
    end
  end

  def show
    @mentor = User.mentors.find(params[:id])
  end

end
