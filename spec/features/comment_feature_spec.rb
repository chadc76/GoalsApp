require 'spec_helper'
require 'rails_helper'

feature "Comment features", type: :feature do
  let(:user) { User.create!(email: 'test@user', password: 'password') }
  let(:goal) { Goal.create!(title: "New Goal", details: "New Goal Details", user_id: user.id) }

  before(:each) { log_in }

  scenario  "commenting on a user" do
    visit user_url(user)
    fill_in("Comment", with: "This is a test comment, yo!")
    click_button('Save Comment')
    expect(current_url).to eq(user_url(user))
    expect(page).to have_content("This is a test comment, yo!")
  end

  scenario  "commenting on a goal"
end