# == Schema Information
#
# Table name: comments
#
#  id               :bigint           not null, primary key
#  comment          :string           not null
#  author_id        :integer          not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  commentable_type :string           not null
#  commentable_id   :bigint           not null
#
class Comment < ApplicationRecord
  validates :comment, :author_id, :commentable_type, :commentable_id, presence: true
  validates :commentable_type, inclusion: %w(User Goal)

  belongs_to :commentable, polymorphic: true

  belongs_to :author,
    primary_key: :id,
    foreign_key: :author_id,
    class_name: :User
end
