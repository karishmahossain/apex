class ProjectTypesController < ApplicationController
  
  before_filter :authenticate_user!, :only => [:show]
  load_and_authorize_resource
  
  def index
    @mentor = User.find(params[:mentor_id])
    @project_types = @mentor.project_types.order("deal DESC").page(params[:page]).per(15)
  end

  def show
    @project_type = ProjectType.find(params[:id])
    @project = Project.new
    3.times { @project.documents.build }
    @mentor = User.mentors.find(params[:mentor_id])
  end

end
