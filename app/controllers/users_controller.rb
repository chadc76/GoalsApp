class UsersController < ApplicationController
  before_action :set_user, only: %i(show comment)
  before_action :logged_in?, only: [:comment]

  def index
    @users = User.all
    render :index
  end

  def new
    @user = User.new
    render :new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      log_in_user!(@user)
    else
      flash.now[:errors] = @user.errors.full_messages
      render :new
    end
  end

  def show
    @goals = @user.goals
    render :show
  end

  def comment
    @comment = UserComment.new(user_id: params[:id], comment: params[:comment], author_id: current_user.id)
    if @comment.save
      flash[:notices] = ["Comment saved!"]
      redirect_to user_url(@user)
    else
      flash[:errors] = @comment.errors.full_messages
      redirect_to user_url(@user)
    end
  end

  private

  def set_user
    @user ||= User.includes(:comments).find_by(id: params[:id])
  end
  
  def user_params
    params.require(:user).permit(:email, :password)
  end
end
