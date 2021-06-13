require 'rails_helper'

RSpec.describe GoalsController, type: :controller do
  let(:user) { User.create!(email: 'new1@user', password: 'password') }
  let(:goal) { Goal.new(title: "New Goal", details: "New Goal Details", user_id: user.id) }
  let(:user2) { User.create!(email: "new2@user", password: 'password') }

  describe "No current user" do    
    it 'redirects to log in page for all actions' do
      goal.save!
      get :index
      expect(response).to redirect_to(new_session_url)
      get :show, params: { id: goal.id }
      expect(response).to redirect_to(new_session_url)
      get :new
      expect(response).to redirect_to(new_session_url)
      post :create, params: { goal: { title: "test goal", user_id: user.id }}
      expect(response).to redirect_to(new_session_url)
      get :edit, params: {id: goal.id}
      expect(response).to redirect_to(new_session_url)
      patch :update, params: {id: goal.id, goal: { title: "New Title!"}}
      expect(response).to redirect_to(new_session_url)
      delete :destroy, params: {id: goal.id}
      expect(response).to redirect_to(new_session_url)
      post :toggle_complete, params: {id: goal.id}
      expect(response).to redirect_to(new_session_url)
      post :comment, params: { id: goal.id, comment: "Test Comment!" }
      expect(response).to redirect_to(new_session_url)
      post :cheers, params: { id: goal.id }
      expect(response).to redirect_to(new_session_url)
    end
  end

  describe "GET #index" do
      
    it 'renders current users goals index template' do
      get :index, session: { session_token: user.session_token }
      expect(response).to render_template('index')
      expect(response).to have_http_status(200)
    end
  end

  describe "GET #show" do

    context "private goal" do

      context "when goal belongs to another user" do 
    
        it 'redirects to current user show page' do
          goal.toggle!(:private)
          get :show, params: { id: goal.id }, session: { session_token: user2.session_token }
          expect(response).to redirect_to(user_url(user2))
          expect(response).to have_http_status(302)
          expect(flash[:notices]).to be_present
        end
      end

      context "when goal belongs to current user" do 
    
        it 'renders goal show page' do
          goal.toggle!(:private)
          get :show, params: { id: goal.id }, session: { session_token: user.session_token }
          expect(response).to render_template("show")
          expect(response).to have_http_status(200)
        end
      end
    end

    context "non-private goal" do
    
      it 'renders goal show template for all users' do
        goal.save!
        get :show, params: { id: goal.id }, session: { session_token: user.session_token }
        expect(response).to render_template('show')
        expect(response).to have_http_status(200)
        get :show, params: { id: goal.id }, session: { session_token: user2.session_token }
        expect(response).to render_template('show')
        expect(response).to have_http_status(200)
      end
    end
  end

  describe "GET #new" do

    it 'renders goal new template' do
      get :new, session: { session_token: user.session_token }
      expect(response).to render_template('new')
      expect(response).to have_http_status(200)
    end
  end

  describe "POST #create" do

    context "with invalid params" do
      
      it 'renders new template' do
        post :create, params: { goal: { title: "" }}, session: { session_token: user.session_token }
        expect(response).to render_template('new')
        expect(flash[:errors]).to be_present
      end
    end
  
    context "with valid params" do
      
      it 'redirects to goal show page' do
        post :create, params: { goal: { title: "test goal"}}, session: { session_token: user.session_token }
        new_goal = Goal.last
        expect(response).to redirect_to(goal_url(new_goal))
        expect(response).to have_http_status(302)
      end
    end
  end

  describe "GET #edit" do

    context "when goal belongs to another user" do 
      
      it 'redirect to current users show page' do
        goal.save!
        get :edit, params: {id: goal.id}, session: { session_token: user2.session_token }
        expect(response).to redirect_to(user_url(user2))
        expect(response).to have_http_status(302)
        expect(flash[:notices]).to be_present
      end
    end

    context "when goal belongs to current user" do
      
      it 'renders goal edit template' do
        goal.save!
        get :edit, params: {id: goal.id}, session: { session_token: user.session_token }
        expect(response).to render_template('edit')
        expect(response).to have_http_status(200)
      end
    end
  end

  describe "GET #update" do
      
    context "when goal belongs to another user" do 
      
      it 'redirect to current users show page' do
        goal.save!
        patch :update, params: {id: goal.id, goal: { title: "New Title!"} }, session: { session_token: user2.session_token }
        expect(response).to redirect_to(user_url(user2))
        expect(response).to have_http_status(302)
        expect(flash[:notices]).to be_present
      end
    end
  
    context "when goal belongs to current user" do 
      
      context "with invalid params" do 
        
        it 'renders edit template' do
          goal.save!
          patch :update, params: { id: goal.id, goal: { title: "" }}, session: { session_token: user.session_token }
          expect(response).to render_template('edit')
          expect(flash[:errors]).to be_present
        end
      end
  
      context "with valid params" do
        
        it 'redirects to goal show page' do
          goal.save!
          patch :update, params: { id: goal.id, goal: { title: "New Title!"}}, session: { session_token: user.session_token }
          expect(response).to redirect_to(goal_url(goal))
          expect(response).to have_http_status(302)
          updated_goal = Goal.find(goal.id)
          expect(updated_goal.title).to eq("New Title!")
        end
      end
    end
  end

  describe "DELETE #destroy" do
  
    context "when goal belongs to current user" do
      
      it 'deletes goal' do 
        goal.save!
        delete :destroy, params: {id: goal.id }, session: { session_token: user.session_token }
        find_goal = Goal.find_by(id: goal.id) 
        expect(find_goal).to be_nil
      end
      
      it 'redirects to user show page after deletion' do
        goal.save!
        delete :destroy, params: {id: goal.id }, session: { session_token: user.session_token }
        expect(response).to redirect_to(user_url(user))
        expect(response).to have_http_status(302)
        expect(flash[:notices]).to be_present
      end
    end

    context "when goal belongs to another user" do
      
      it 'doesn\'t delete goal' do
        goal.save!
        delete :destroy, params: {id: goal.id }, session: { session_token: user2.session_token }
        find_goal = Goal.find_by(id: goal.id) 
        expect(find_goal).to eq(goal)
      end

      it 'redirects to user show page' do
        goal.save!
        delete :destroy, params: {id: goal.id }, session: { session_token: user2.session_token }
        expect(response).to redirect_to(user_url(user2))
        expect(response).to have_http_status(302)
        expect(flash[:notices]).to be_present
      end
    end
  end

  describe "POST #toggle_complete" do

    context "when goal belongs to current user" do
    
      it 'switches a uncompleted goal to completed' do
        goal.save!
        post :toggle_complete, params: {id: goal.id }, session: { session_token: user.session_token }
        expect(response).to redirect_to("/")
        expect(response).to have_http_status(302)
        expect(Goal.last.complete).to be true
      end

      it 'switches a completed goal to uncompleted' do
        goal.toggle!(:complete)
        post :toggle_complete, params: {id: goal.id }, session: { session_token: user.session_token }
        expect(response).to redirect_to("/")
        expect(response).to have_http_status(302)
        expect(Goal.last.complete).to be false
      end
    end

    context "when goal belongs to another user" do
    
      it 'it doesn\'t toggle goal' do
        goal.save!
        post :toggle_complete, params: {id: goal.id }, session: { session_token: user2.session_token }
        expect(Goal.last.complete).to be false
      end

      it 'redirects to user show page' do
        goal.save!
        post :toggle_complete, params: {id: goal.id }, session: { session_token: user2.session_token }
        expect(response).to redirect_to(user_url(user2))
        expect(response).to have_http_status(302)
        expect(flash[:notices]).to be_present
      end
    end
  end

  describe 'POST #comment' do

    context "private goal" do

      context "when goal belongs to another user" do 
    
        it 'redirects to current user show page' do
          goal.toggle!(:private)
          post :comment, params: { id: goal.id, comment: "Test Comment!" }, session: { session_token: user2.session_token }
          expect(response).to redirect_to(user_url(user2))
          expect(response).to have_http_status(302)
          expect(flash[:notices]).to be_present
        end
      end

      context "when goal belongs to current user" do 
  
        it 'renders goal show page' do
          goal.toggle!(:private)
          post :comment, params: { id: goal.id, comment: "Test Comment!" }, session: { session_token: user.session_token }
          expect(goal.comments).to_not be_empty
          expect(goal.comments.first.comment).to eq("Test Comment!")
          expect(flash[:notices]).to be_present
        end
      end
    end

    context "non-private goal" do
      
      context "with invalid params" do
        before(:each) { goal.save! }

        it "doesn't create new comment" do
          post :comment, params: { id: goal.id, comment: "" }, session: { session_token: user.session_token }
          expect(goal.comments).to be_empty
        end
    
        it "redirects to Goal show page" do
          post :comment, params: { id: goal.id, comment: "" }, session: { session_token: user.session_token }
          expect(response).to redirect_to(goal_url(goal))
          expect(flash[:errors]).to be_present
        end
      end
  
      context "with valid params" do
        before(:each) { goal.save! }

        it "creates new comment" do
          post :comment, params: { id: goal.id, comment: "Test Comment!" }, session: { session_token: user.session_token }
          expect(goal.comments).to_not be_empty
          expect(goal.comments.first.comment).to eq("Test Comment!")
          expect(flash[:notices]).to be_present
        end
    
        it "redirects to Goal show page" do
          post :comment, params: { id: goal.id, comment: "Test Comment!" }, session: { session_token: user.session_token }
          expect(response).to redirect_to(goal_url(goal))
        end
      end
    end
  end

  describe 'POST #cheers' do

    context "private goal" do
    
      it 'redirects to current user show page' do
        goal.toggle!(:private)
        post :cheers, params: { id: goal.id }, session: { session_token: user2.session_token }
        expect(response).to redirect_to(user_url(user2))
        expect(response).to have_http_status(302)
        expect(flash[:notices]).to be_present
      end
    end

    context "non-private goal" do
      
      context "belongs to current user" do
        before(:each) { goal.save! }

        it "doesn't create new cheer" do
          post :cheers, params: { id: goal.id }, session: { session_token: user.session_token }
          expect(goal.cheer_score).to eq(0)
        end
    
        it "redirects to User show page" do
          post :cheers, params: { id: goal.id }, session: { session_token: user.session_token }
          expect(response).to redirect_to(user_url(user))
          expect(flash[:errors]).to be_present
        end
      end
  
      context "belongs to another user" do
        before(:each) { goal.save! }

        it "creates new cheer" do
          post :cheers, params: { id: goal.id }, session: { session_token: user2.session_token }
          expect(goal.cheer_score).to eq(1)
          expect(flash[:notices]).to be_present
        end
    
        it "redirects to User show page" do
          post :cheers, params: { id: goal.id }, session: { session_token: user2.session_token }
          expect(response).to redirect_to(user_url(goal.user_id))
        end
      end
    end
  end
end
