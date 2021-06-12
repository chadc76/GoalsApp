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
class Goal < ApplicationRecord
  validates :title, :user_id, presence: true
  validates :title, length: { minimum: 6 }

  belongs_to :user, inverse_of: :goals

  has_many :comments,
    dependent: :destroy,
    primary_key: :id,
    foreign_key: :goal_id,
    class_name: :GoalComment
end
