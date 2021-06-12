class SessionsController < ApplicationController
  def new
    @user = User.new
    render :new
  end

  def create
    @user = User.find_by_credentials(
      params[:user][:email],
      params[:user][:password]
    )
    if @user.nil?
      flash[:errors] = ["Credentials do not match"]
      render :new
    else
      log_in_user!(@user)
    end
  end

  def destroy
    log_out_user!
    redirect_to new_session_url
  end
end
