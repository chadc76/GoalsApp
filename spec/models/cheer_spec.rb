# == Schema Information
#
# Table name: cheers
#
#  id         :bigint           not null, primary key
#  goal_id    :integer          not null
#  user_id    :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require 'rails_helper'

RSpec.describe Cheer, type: :model do
  let(:user) {FactoryBot.create(:user)}
  let(:user2) {FactoryBot.create(:user)}
  let(:goal) {FactoryBot.create(:goal, user_id: user.id)}
  subject(:cheer) {FactoryBot.build(:cheer, user_id: user2.id, goal_id: goal.id)}
  let(:self_cheer) {FactoryBot.build(:cheer, user_id: user.id, goal_id: goal.id)}

  context "validations" do
    it { should validate_presence_of(:goal_id) }
    it { should validate_presence_of(:user_id) }

    it 'should validate a user can\'t cheer for the same goal more than once' do
      cheer.save!
      cheer1 = FactoryBot.build(:cheer, user_id: user2.id, goal_id: goal.id)
      cheer1.valid?
      expect(cheer1.errors[:user_id]).to eq(["you have already cheered for this goal"])
    end

    it 'should not allow you to cheers your own goal' do
      self_cheer.valid?
      expect(self_cheer.errors[:user_id]).to eq(["cannot cheers themselves!!"])
    end

    it 'should not allow a user to cheers when they have no cheers left' do
      twelve_cheers(user, user2)
      goal2 = FactoryBot.create(:goal, user_id: user2.id)
      cheer1 = FactoryBot.build(:cheer, user_id: user.id, goal_id: goal2.id)
      cheer1.valid?
      expect(cheer1.errors[:user_id]).to eq(["is out of cheers"])
    end

  end

  context "associations" do
    it { should belong_to(:user) }
    it { should belong_to(:goal) }
  end
end