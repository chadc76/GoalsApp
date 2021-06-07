require 'rails_helper'

RSpec.describe GoalsController, type: :controller do
  let(:user) { User.create!(email: 'new@user', password: 'password') }
  let(:goal) { Goal.new(title: "New Goal", details: "New Goal Details", user_id: user.id) }

  describe "GET #index" do
    it 'redirects to log in page if no current user' do
      get :index
      expect(response).to redirect_to(new_session_url)
    end

    it 'renders current users goals index template' do
      get :index, session: { session_token: user.session_token }
      expect(response).to render_template('index')
      expect(response).to have_http_status(200)
    end
  end

  describe "GET #show" do
    it 'redirects to log in page if no current user' do
      goal.save!
      get :show, params: { id: goal.id }
      expect(response).to redirect_to(new_session_url)
    end

    it 'renders goal show template' do
      goal.save!
      get :show, params: { id: goal.id }, session: { session_token: user.session_token }
      expect(response).to render_template('show')
      expect(response).to have_http_status(200)
    end
  end

  describe "GET #new" do
    it 'redirects to log in page if no current user' do
      get :new
      expect(response).to redirect_to(new_session_url)
    end
  end

  describe "POST #create" do
  end

  describe "GET #edit" do
    it 'redirects to log in page if no current user' do
      get :edit
      expect(response).to redirect_to(new_session_url)
    end
  end

  describe "GET #update" do

  end

  describe "DELETE #destroy" do

  end
end
