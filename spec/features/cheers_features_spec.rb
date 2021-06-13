require 'spec_helper'
require 'rails_helper'

feature "Cheers features", type: :feature do
  feature "with cheers remaining" do
      
    scenario "cheers a goal" do
      user = User.create!(email: 'test@user', password: 'password')
      goal = Goal.create!(title: "New Goal", details: "New Goal Details", user_id: user.id)
      log_in
      expect(page).to have_content("Cheers Remaining: 12")
      visit user_url(user)
      click_button("Cheer!")
      expect(current_url).to eq(user_url(user))
      expect(page).not_to have_button("Cheer!")
      expect(page).to have_content("Cheers Remaining: 11")
      expect(page).to have_content("You cheered #{user.email} goal!")
    end
  end

  feature "with no cheers remaining" do

    scenario "has not cheers buttons" do
      user = User.create!(email: 'test@user', password: 'password')
      goal = Goal.create!(title: "New Goal", details: "New Goal Details", user_id: user.id)
      log_in
      expect(page).to have_content("Cheers Remaining: 12")
      twelve_cheers(User.last, user)
      visit user_url(user)
      expect(page).to have_content("Cheers Remaining: 0")
      expect(page).not_to have_button("Cheer!")
    end
  end

  feature  "viewing cheers" do

    scenario "User show page has button to view cheers" do
      user = User.create!(email: 'test@user', password: 'password')
      goal = Goal.create!(title: "New Goal", details: "New Goal Details", user_id: user.id)
      log_in
      u2 = User.last
      visit user_url(u2)
      click_link("My Cheers!")
      expect(current_url).to eq(cheers_user_url(u2))
      expect(page).to have_content("My Cheers")
    end

    scenario "Cheers page shows users cheers" do
      user = User.create!(email: 'test@user', password: 'password')
      goal = Goal.create!(title: "New Goal", details: "New Goal Details", user_id: user.id)
      log_in
      u2 = User.last
      goal = FactoryBot.create(:goal, title: "test goal", user_id: u2.id)
      FactoryBot.create(:cheer, user_id: user.id, goal_id: goal.id)
      visit user_url(u2)
      click_link("My Cheers!")
      expect(page).to have_content("Cheer given by:")
      expect(page).to have_content("#{user.email}")
      expect(page).to have_content("For goal of:")
      expect(page).to have_content("#{goal.title}")
    end
  end
end