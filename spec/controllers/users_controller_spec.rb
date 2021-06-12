require 'rails_helper'

RSpec.describe UsersController, type: :controller do

  describe "GET #index" do
    it "renders user index template" do
      get :index
      expect(response).to render_template('index')
      expect(response).to have_http_status(200)
    end
  end

  describe "GET #new" do
    it "renders user new template" do
      get :new
      expect(response).to render_template('new')
      expect(response).to have_http_status(200)
    end
  end

  describe "POST #create" do
    context 'with invalid params' do 
      it "validates the presence of email and password" do
        post :create, params: { user: { email: 'test@test.com' } }
        expect(response).to render_template('new')
        expect(flash[:errors]).to be_present
      end
    end

    context 'with valid params' do 
      it "redirects to user show page" do
        get :create, params: { user: { email: 'test@test.com', password: 'password' } }
        expect(response).to redirect_to(user_url(User.last))
      end

      it "logs user in after sign up" do
        get :create, params: { user: { email: 'test@test.com', password: 'password' } }
        expect(session[:session_token]).to eq(User.last.session_token)
      end
    end
  end

  describe "GET #show" do
    it "renders user show template" do
      user = User.create!(email: 'test2@test.com', password: 'password')
      get :show, params: { id: user.id }
      expect(response).to render_template('show')
    end
  end

end
