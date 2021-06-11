class GoalsController < ApplicationController
  before_action :logged_in?
  
  def index
    @goals = current_user.goals
    render :index
  end

  def show
    @goal = Goal.find_by(id: params[:id])
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
      redirect_to user_url(current_user)
    else
      flash.now[:errors] = @goal.errors.full_messages
      render :new
    end
  end

  def edit
    @goal = Goal.find_by(id: params[:id])
    render :edit
  end

  private

  def goal_params
    params.require(:goal).permit(:title, :details, :private, :complete)
  end
end
