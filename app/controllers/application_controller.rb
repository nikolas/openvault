class ApplicationController < ActionController::Base

  raise 'No HTTP basic authentication password has been set.' unless ENV['http_basic_auth_password']
  http_basic_authenticate_with :name => "ov", :password => ENV['http_basic_auth_password']

  # Adds a few additional behaviors into the application controller 
   include Blacklight::Controller
  # Please be sure to impelement current_user and user_session. Blacklight depends on 
  # these methods in order to perform user specific actions. 
  
  protect_from_forgery
  
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
  end

  def authenticate_admin_user!
    authenticate_user!
    unless current_user.admin?
      flash[:alert] = "Unauthorized Access!"
      redirect_to root_path
    end
  end

  def layout_name
    'application'
  end
  
  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end

  def model_url(kind=nil)
    case kind
    when "Video"
      "video"
    when "Audio"
      "audio"
    when "Program"
      "programs"
    when "Series"
      "series"
    else
      "catalog"
    end
  end
  
end
