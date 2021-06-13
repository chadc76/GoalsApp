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

  describe 'POST #comment' do
    before(:each) { User.create!(email: 'test2@test.com', password: 'password') }
    
    context "with invalid params" do 
      it "doesn't create new comment" do
        user = User.last
        post :comment, params: { id: user.id, comment: "" }, session: { session_token: user.session_token }
        expect(user.comments).to be_empty
      end
  
      it "redirects to User show page" do
        user = User.last
        post :comment, params: { id: user.id, comment: "" }, session: { session_token: user.session_token }
        expect(response).to redirect_to(user_url(user))
        expect(flash[:errors]).to be_present
      end
    end

    context "with valid params" do 
      it "creates new comment" do
        user = User.last
        post :comment, params: { id: user.id, comment: "Test Comment!" }, session: { session_token: user.session_token }
        expect(user.comments).to_not be_empty
        expect(user.comments.first.comment).to eq("Test Comment!")
        expect(flash[:notices]).to be_present
      end
  
      it "redirects to User show page" do
        user = User.last
        post :comment, params: { id: user.id, comment: "Test Comment!" }, session: { session_token: user.session_token }
        expect(response).to redirect_to(user_url(user))
      end
    end
  end

  describe 'GET #cheers' do
    let(:user) { User.create!(email: 'new4@user', password: 'password') }
    let(:goal) { Goal.create!(title: "New Goal", details: "New Goal Details", user_id: user.id) }
    let(:goal2) { Goal.create!(title: "New Goal 2", details: "New Goal Details", user_id: user.id) }
    let(:user2) { User.create!(email: "new2@user", password: 'password') }
    
    context "belongs to current user" do
      before(:each) do
        Cheer.create!(goal_id: goal.id, user_id: user2.id)
        Cheer.create!(goal_id: goal2.id, user_id: user2.id)
      end

      it "renders current users cheers index page" do
        get :cheers, params: { id: user.id }, session: { session_token: user.session_token }
        expect(response).to render_template('cheers')
      end
    end

    context "belongs to another user" do
      before(:each) do
        Cheer.create!(goal_id: goal.id, user_id: user2.id)
        Cheer.create!(goal_id: goal2.id, user_id: user2.id)
      end
  
      it "redirects to current users show page" do
        post :cheers, params: { id: user.id }, session: { session_token: user2.session_token }
        expect(response).to redirect_to(user_url(user2))
        expect(flash[:notices]).to be_present
      end
    end
  end
end
