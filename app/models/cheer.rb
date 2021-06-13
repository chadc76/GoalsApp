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
class Cheer < ApplicationRecord
  validates :goal_id, :user_id, presence: true
  validates :user_id, uniqueness: { scope: :goal_id, message: "you have already cheered for this goal" }
  validate :does_not_cheer_self

  private

  def does_not_cheer_self
    return if goal_id.nil? || user_id.nil?
    errors.add(:user_id,"cannot cheers themselves!!") if Goal.find(self.goal_id).user_id == self.user_id
  end
end
