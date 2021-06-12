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
require 'rails_helper'

RSpec.describe UserComment, type: :model do
  context "validations" do
    it { should validate_presence_of(:comment) }
    it { should validate_presence_of(:user_id) }
    it { should validate_presence_of(:author_id) }
  end
end
