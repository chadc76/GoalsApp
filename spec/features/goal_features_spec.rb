require 'spec_helper'
require 'rails_helper'

feature "Goal features", type: :feature do
  feature  "adding a new goal" do
    before(:each) { log_in }
  
    scenario "has new goal page" do
      visit new_goal_url
      expect(page).to have_content("New Goal")
    end
    
    scenario "with invalid params" do
      create_goal("")
      expect(current_path).to eq("/goals")
      expect(page).to have_content("Title can't be blank")
    end
  
    scenario "with valid params" do
      create_goal("Test Title", "Test details")
      expect(page).to have_content("Test Title")
      expect(current_path).to eq("/goals/#{Goal.last.id}")
    end

    scenario "able to add goal from user show page" do
      visit user_url(User.last)
      click_link("New Goal")
      expect(current_path).to eq("/goals/new")
    end
  end
  
  feature  "editing a goal" do
    before(:each) do
      log_in
      create_goal("Test Title", "Test details")
    end
  
    scenario "has edit goal page" do
      visit edit_goal_url(Goal.last)
      expect(page).to have_content("Edit Goal")
    end
    
    scenario "with invalid params" do
      edit_goal("")
      expect(current_path).to eq("/goals/#{Goal.last.id}")
      expect(page).to have_content("Title can't be blank")
    end
  
    scenario "with valid params" do
      edit_goal("New Test Title", "new Test details", true, true)
      expect(page).to have_content("New Test Title")
      expect(current_path).to eq("/goals/#{Goal.last.id}")
    end
  end

  feature "deleting a goal" do
    before(:each) do
      log_in
      create_goal("Test Title", "Test details")
    end
  
    scenario "able to delete from user show page" do
      visit user_url(User.last)
      click_button("delete #{Goal.last.title} goal")
    end
  
    scenario "able to delete from users goal index page" do
      visit goals_url
      click_button("delete #{Goal.last.title} goal")
    end
  end

  feature "completing a goal" do
    before(:each) do 
      log_in
      create_goal("Test Title", "Test details")
    end

    scenario "able to complete goal from user show page" do
      user = User.last
      visit user_url(user)
      click_button("Complete")
      expect(current_url).to eq(user_url(user))
      expect(page).to have_selector(:link_or_button, "Oops! Did not complete.")
    end

    scenario "able to complete goal from goal show page" do
      goal = Goal.last
      visit goal_url(goal)
      click_button("Complete")
      expect(current_url).to eq(goal_url(goal))
      expect(page).to have_selector(:link_or_button, "Oops! Did not complete.")
    end

    scenario "able to complete goal from goals index page" do
      visit goals_url
      click_button("Complete")
      expect(current_url).to eq(goals_url)
      expect(page).to have_selector(:link_or_button, "Oops! Did not complete.")
    end

    scenario "able to uncomplete goal from user show page" do
      goal = Goal.last
      goal.toggle!(:complete)
      user = User.last
      visit user_url(user)
      click_button("Oops! Did not complete.")
      expect(current_url).to eq(user_url(user))
      expect(page).to have_selector(:link_or_button,"Complete")
    end

    scenario "able to uncomplete goal from goal show page" do
      goal = Goal.last
      goal.toggle!(:complete)
      visit goal_url(goal)
      goal.save
      click_button("Oops! Did not complete.")
      expect(current_url).to eq(goal_url(goal))
      expect(page).to have_selector(:link_or_button,"Complete")
    end

    scenario "able to uncomplete goal from goals index page" do
      goal = Goal.last
      goal.toggle!(:complete)
      visit goals_url
      click_button("Oops! Did not complete.")
      expect(current_url).to eq(goals_url)
      expect(page).to have_selector(:link_or_button,"Complete")
    end
  end
end