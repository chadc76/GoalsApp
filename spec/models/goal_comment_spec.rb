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
require 'rails_helper'

RSpec.describe GoalComment, type: :model do
  context "validations" do
    it { should validate_presence_of(:comment) }
    it { should validate_presence_of(:goal_id) }
    it { should validate_presence_of(:author_id) }
  end

  context "associations" do
    it { should belong_to(:author) }
    it { should belong_to(:goal) }
  end
end
