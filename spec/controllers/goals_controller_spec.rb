require 'rails_helper'

RSpec.describe GoalsController, type: :controller do
  let(:user) { User.create!(email: 'new@user', password: 'password') }
  let(:goal) { Goal.new(title: "New Goal", details: "New Goal Details", user_id: user.id) }

  describe "GET #index" do
    describe "with no current user" do 
      it 'redirects to log in page' do
        get :index
        expect(response).to redirect_to(new_session_url)
      end
    end

    describe "with a current user" do
      it 'renders current users goals index template' do
        get :index, session: { session_token: user.session_token }
        expect(response).to render_template('index')
        expect(response).to have_http_status(200)
      end
    end
  end

  describe "GET #show" do
    describe "with no current user" do 
      it 'redirects to log in page' do
        goal.save!
        get :show, params: { id: goal.id }
        expect(response).to redirect_to(new_session_url)
      end
    end

    describe "with private goal that doesn\'t belong to current user" do
      it 'redirects to current user show page' do
        goal.private = true
        goal.save!
        user2 = User.create!(email: "new2@user", password: 'password')
        get :show, params: { id: goal.id }, session: { session_token: user2.session_token }
        expect(response).to redirect_to(user_url(user2))
        expect(response).to have_http_status(302)
        expect(flash[:notices]).to be_present
      end
    end

    describe "with a current user" do
      it 'renders goal show template' do
        goal.save!
        get :show, params: { id: goal.id }, session: { session_token: user.session_token }
        expect(response).to render_template('show')
        expect(response).to have_http_status(200)
      end
    end
  end

  describe "GET #new" do
    describe "with no current user" do 
      it 'redirects to log in page' do
        get :new
        expect(response).to redirect_to(new_session_url)
      end
    end

    describe "with a current user" do
      it 'renders goal new template' do
        get :new, session: { session_token: user.session_token }
        expect(response).to render_template('new')
        expect(response).to have_http_status(200)
      end
    end
  end

  describe "POST #create" do
    describe "with no current user" do 
      it 'redirects to log in page' do
        post :create, params: { goal: { title: "test goal", user_id: user.id }}
        expect(response).to redirect_to(new_session_url)
      end
    end

    describe "with invalid params" do
      it 'renders new template' do
      post :create, params: { goal: { title: "" }}, session: { session_token: user.session_token }
      expect(response).to render_template('new')
      expect(flash[:errors]).to be_present
      end
    end

    describe "with valid params" do
      it 'redirects to goal show page' do
        post :create, params: { goal: { title: "test goal"}}, session: { session_token: user.session_token }
        new_goal = Goal.last
        expect(response).to redirect_to(goal_url(new_goal))
        expect(response).to have_http_status(302)
      end
    end
  end

  describe "GET #edit" do
    describe "with no current user" do 
      it 'redirects to log in page' do
        goal.save!
        get :edit, params: {id: goal.id}
        expect(response).to redirect_to(new_session_url)
      end
    end

    describe "when goal does not belong to current user" do 
      it 'redirect to current users show page' do
        user2 = User.create!(email: "new2@user", password: 'password')
        goal.save!
        get :edit, params: {id: goal.id}, session: { session_token: user2.session_token }
        expect(response).to redirect_to(user_url(user2))
        expect(response).to have_http_status(302)
        expect(flash[:notices]).to be_present
      end
    end

    describe "with a current user" do
      it 'renders goal edit template' do
        goal.save!
        get :edit, params: {id: goal.id}, session: { session_token: user.session_token }
        expect(response).to render_template('edit')
        expect(response).to have_http_status(200)
      end
    end
  end

  describe "GET #update" do
    describe "with no current user" do 
      it 'redirects to log in page if no current user' do
        goal.save!
        post :update, params: {id: goal.id, goal: {title: "New Title!"}}
        expect(response).to redirect_to(new_session_url)
      end
    end
    describe "when goal does not belong to current user" do 
      it 'redirect to current users show page' do
        user2 = User.create!(email: "new2@user", password: 'password')
        goal.save!
        post :update, params: {id: goal.id, goal: { title: "New Title!"} }, session: { session_token: user2.session_token }
        expect(response).to redirect_to(user_url(user2))
        expect(response).to have_http_status(302)
        expect(flash[:notices]).to be_present
      end
    end

    describe "with invalid params" do 
      it 'renders edit template' do
        goal.save!
        post :update, params: { id: goal.id, goal: { title: "" }}, session: { session_token: user.session_token }
        expect(response).to render_template('edit')
        expect(flash[:errors]).to be_present
      end
    end

    describe "with valid params" do
      it 'redirects to goal show page' do
        goal.save!
        post :update, params: { id: goal.id, goal: { title: "New Title!"}}, session: { session_token: user.session_token }
        expect(response).to redirect_to(goal_url(goal))
        expect(response).to have_http_status(302)
        updated_goal = Goal.find(goal.id)
        expect(updated_goal.title).to eq("New Title!")
      end
    end
  end

  describe "DELETE #destroy" do

  end
end
