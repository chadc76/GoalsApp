require 'spec_helper'
require 'rails_helper'

feature "Authentication features", type: :feature do
  feature 'the signup process' do
    scenario 'has a new user page' do
      visit new_user_url
      expect(page).to have_content("Sign up!")
    end
  
    feature 'signing up a user' do
  
      scenario 'shows email on the homepage after signup' do
        visit new_user_url
        fill_in('Email', with: 'test@test.com')
        fill_in('Password', with: 'password')
        click_button("Sign up!")
        expect(page).to have_content('test@test.com')
      end
  
    end
  end
  
  feature 'logging in' do
  
    scenario 'shows username on the homepage after login' do
      User.create!(email: 'test@test.com', password: 'password')
      visit new_session_url
      fill_in('Email', with: 'test@test.com')
      fill_in('Password', with: 'password')
      click_button("Log in!")
      expect(page).to have_content('test@test.com')
    end
  
  end
  
  feature 'logging out' do
    before(:each) do
      User.create!(email: 'test@test.com', password: 'password')
      visit new_session_url
      fill_in('Email', with: 'test@test.com')
      fill_in('Password', with: 'password')
      click_button("Log in!")
    end
  
    scenario 'begins with a logged out state' do
      click_button("Log out")
      expect(page).to have_content("Log in!")
    end
  
    scenario 'doesn\'t show username on the homepage after logout' do
      click_button("Log out")
      expect(page).not_to have_content("test@test.com")
    end
  
  end
end