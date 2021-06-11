require 'spec_helper'
require 'rails_helper'

feature  "adding a new goal" do

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