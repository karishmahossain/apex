RailsAdmin.config do |config|
  config.authorize_with :cancan
  config.included_models = ["User", "Project", "Document", "ProjectType", "University", "Feed"] 
end
