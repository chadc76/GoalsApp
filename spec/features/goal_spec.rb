require 'spec_helper'
require 'rails_helper'

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