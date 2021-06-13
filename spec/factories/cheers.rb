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
FactoryBot.define do
  factory :cheer do
    goal_id { 1 }
    user_id { 1 }
  end
end
