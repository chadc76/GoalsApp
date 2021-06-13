# == Schema Information
#
# Table name: goals
#
#  id         :bigint           not null, primary key
#  title      :string           not null
#  details    :text
#  user_id    :integer          not null
#  private    :boolean          default(FALSE)
#  complete   :boolean          default(FALSE)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require 'rails_helper'

RSpec.describe Goal, type: :model do
  let(:user) {FactoryBot.build(:user)}
  subject(:goal) { FactoryBot.build(:goal, user_id: user.id) }
  
  describe 'validations' do
    it { should validate_presence_of(:title) }
    it { should validate_length_of(:title).is_at_least(6) }
    it { should validate_presence_of(:user_id) }
  end

  describe 'associations' do
    it { should belong_to(:user) }
    it { should have_many(:comments) }
    it { should have_many(:cheers) }
  end

  describe 'instance methods' do
    describe 'Goal#cheer_score' do
      before(:each) do
        user.save!
        goal.save!
      end

      it 'returns the number of cheers for a particular goal' do
        expect(goal.cheer_score).to eq(0)
        user2 = FactoryBot.create(:user)
        FactoryBot.create(:cheer, user_id: user2.id, goal_id: goal.id)
        expect(goal.cheer_score).to eq(1)
      end
    end
  end
end
