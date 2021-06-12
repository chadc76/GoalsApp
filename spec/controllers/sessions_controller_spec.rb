require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  describe "GET #new" do
    it "renders session new template" do
      get :new
      expect(response).to render_template('new')
      expect(response).to have_http_status(200)
    end
  end

  describe "POST #create" do
    before { User.create!(email: "test@test.com", password: "password") }

    context 'with invalid params' do
      it 'verfies email and password match' do
        post :create, params: { user: { email: "test@test.com", password: "" } }
        expect(response).to render_template('new')
        expect(flash[:errors]).to be_present
      end
    end

    context 'with valid params' do
      it 'sets session session token to user session token' do
        post :create, params: { user: { email: "test@test.com", password: "password" } }
        expect(session[:session_token]).to eq(User.last.session_token)
      end

      it 'redirects to user show page' do
        post :create, params: { user: { email: "test@test.com", password: "password" } }
        expect(response).to redirect_to(user_url(User.last))
      end
    end
  end

  describe "DELETE #destroy" do
    it "sets session session token to nil" do
      User.create!(email: "test@test.com", password: "password")
      get :destroy, session: { session_token: User.last.session_token }
      expect(response).to redirect_to(new_session_url)
      expect(session[:session_token]).to be_nil
    end
  end

end
