module ApplicationHelper
  def auth_token
    "<input type=\"hidden\" name=\"authenticity_token\" value=\"#{form_authenticity_token}\">".html_safe
  end

  def completion_buttons(goal)
    if goal.complete
      button_to("Oops! Did not complete.", toggle_complete_goal_url(goal), method: :post)
    else
      button_to("Complete", toggle_complete_goal_url(goal), method: :post)
    end
  end
end
