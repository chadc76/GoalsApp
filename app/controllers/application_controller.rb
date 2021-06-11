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

  def current_goal
    @current_goal ||= Goal.find_by(id: params[:id])
  end

  def current_users_goal?
    if current_goal.user_id != current_user.id
      flash[:notices] = ["This is not your Goal!"]
      redirect_to user_url(current_user)
      return
    end
  end
end
