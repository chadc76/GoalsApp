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
      session[:session_token] = @user.session_token
      redirect_to user_url(@user)
    end
  end

  def destroy
    session[:session_token] = nil
    redirect_to new_session_url
  end
end
