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
end
