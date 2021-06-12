# == Schema Information
#
# Table name: goal_comments
#
#  id         :bigint           not null, primary key
#  comment    :string           not null
#  goal_id    :integer          not null
#  author_id  :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class GoalComment < ApplicationRecord
  validates :comment, :goal_id, :author_id, presence: true
end
