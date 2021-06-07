# == Schema Information
#
# Table name: users
#
#  id              :bigint           not null, primary key
#  email           :string           not null
#  password_digest :string           not null
#  session_token   :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
require 'rails_helper'

RSpec.describe User, type: :model do
  subject(:user) {User.new(email: 'test@test.com', password: 'password')}

  describe 'validations' do
    it {should validate_presence_of(:email)}
    it {should validate_presence_of(:password_digest).with_message('Password can\'t be blank')}
    it {should validate_uniqueness_of(:email)}
    it {should validate_length_of(:password).is_at_least(6)}

    it 'creates a password digest when a password is given' do
      expect(user.password_digest).not_to be_nil
    end
  
    it 'creates a session token before validation' do
      user.valid?
      expect(user.session_token).not_to be_nil
    end
  end

  describe 'class methods' do
    describe 'User::find_by_credentials' do
      before { user.save! }
  
      context 'valid credentials' do 
        it 'returns the appropraite user' do 
          expect(User.find_by_credentials('test@test.com', 'password')).to eq(user)
        end
      end
  
      context 'invalid credentials' do
        it 'returns nil' do
          expect(User.find_by_credentials('wrong@wrong.com', 'password')).to be_nil
          expect(User.find_by_credentials('test@test.com', 'wrong')).to be_nil
        end
      end
    end
  end

  describe 'User#reset_session_token!' do
    it 'sets a new session token on the user' do
      user.save!
      old_session_token = user.session_token
      user.reset_session_token!
      expect(user.session_token).not_to eq(old_session_token)
    end

    it 'returns the session token' do
      user.save!
      expect(user.reset_session_token!).to eq(user.session_token)
    end
  end

  describe 'instance methods' do
    describe 'User#is_password?' do
    let(:wrong_pass) {'wrong pass'}
    let(:right_pass) {'password'}

    it 'verifies password is correct' do
      expect(user.is_password?(right_pass)).to be true
    end

    it 'verifies password is not correct' do
      expect(user.is_password?(wrong_pass)).to be false
    end
    end
  end

  describe 'associations' do
    it { should have_many(:goals) }
  end
end
