class GoalsController < ApplicationController
  before_action :logged_in?
  before_action :current_users_private_goal?, only: %i(show comment cheers)
  before_action :not_current_users_goal?, only: %i(edit update destroy toggle_complete)
  before_action :is_current_users_goal?, only: %i(cheers)
  before_action :set_goal, only: %i(show edit update destroy toggle_complete comment cheers)

  def index
    @goals = current_user.goals
    render :index
  end

  def show
    render :show
  end

  def new
    @goal = Goal.new
    render :new
  end

  def create
    @goal = Goal.new(goal_params)
    @goal.user_id = current_user.id

    if @goal.save
      redirect_to goal_url(@goal)
    else
      flash.now[:errors] = @goal.errors.full_messages
      render :new
    end
  end

  def edit
    render :edit
  end

  def update
    if @goal.update(goal_params)
      redirect_to goal_url(@goal)
    else
      flash.now[:errors] = @goal.errors.full_messages
      render :edit
    end
  end

  def destroy
    @goal.destroy
    flash[:notices] = ["goal has been delete"]
    redirect_to user_url(current_user)
  end

  def toggle_complete
    @goal.toggle(:complete)
    @goal.save
    redirect_back(fallback_location: root_path)
  end

  def comment
    @comment = Comment.new(
      commentable_type: 'Goal', 
      commentable_id: params[:id], 
      comment: params[:comment], 
      author_id: current_user.id
      )
    if @comment.save
      flash[:notices] = ["Comment saved!"]
      redirect_to goal_url(@goal)
    else
      flash[:errors] = @comment.errors.full_messages
      redirect_to goal_url(@goal)
    end
  end
  

  def cheers
    @cheer = Cheer.new(
      goal_id: params[:id], 
      user_id: current_user.id
      )
    if @cheer.save
      flash[:notices] = ["You cheered #{@goal.user.email} goal!"]
      redirect_to user_url(@goal.user_id)
    else
      flash[:errors] = @cheer.errors.full_messages
      redirect_to user_url(@goal.user_id)
    end
  end

  private

  def goal_params
    params.require(:goal).permit(:title, :details, :private, :complete)
  end

  def set_goal
    @goal ||= Goal.includes(:comments).find_by(id: params[:id])
  end

  def current_users_private_goal?
    if current_goal.private && current_goal.user_id != current_user.id
      flash[:notices] = ["Sorry that goal is private"]
      redirect_to user_url(current_user)
      return
    end
  end

  def is_current_users_goal?
    if current_goal.user_id == current_user.id
      flash[:errors] = ["You can't cheers your own goal"]
      redirect_to user_url(current_user)
      return
    end
  end
end
