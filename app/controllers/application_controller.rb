class ApplicationController < ActionController::Base
  helper_method :current_user

  def current_user
    @current_user ||= User.find_by(session_token: session[:session_token])
  end

  def logged_in?
    if current_user.nil?
      redirect_to new_session_url
      return
    end
  end
end
