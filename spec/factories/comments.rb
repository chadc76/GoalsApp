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
FactoryBot.define do
  factory :comment do
    comment { "MyString" }
    author_id { 1 }
    commentable_type { "MyString" }
    commentable_id { 1 }
  end
end
