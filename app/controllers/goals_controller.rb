class GoalsController < ApplicationController
  before_action :logged_in?
  before_action :current_users_private_goal?, only: %i(show comment)
  before_action :current_users_goal?, only: %i(edit update destroy toggle_complete)
  before_action :set_goal, only: %i(show edit update destroy toggle_complete comment)

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
    @comment = GoalComment.new(goal_id: params[:id], comment: params[:comment], author_id: current_user.id)
    if @comment.save
      flash[:notices] = ["Comment saved!"]
      redirect_to goal_url(@goal)
    else
      flash[:errors] = @comment.errors.full_messages
      redirect_to goal_url(@goal)
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
end
