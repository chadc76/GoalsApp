# == Schema Information
#
# Table name: user_comments
#
#  id         :bigint           not null, primary key
#  comment    :string           not null
#  user_id    :integer          not null
#  author_id  :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class UserComment < ApplicationRecord
  validates :comment, :user_id, :author_id, presence: true

  belongs_to :user, inverse_of: :comments
  belongs_to :author,
    primary_key: :id,
    foreign_key: :author_id,
    class_name: :User
end
