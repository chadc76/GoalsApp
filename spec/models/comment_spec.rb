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
require 'rails_helper'

RSpec.describe Comment, type: :model do
  context "validations" do
    it { should validate_presence_of(:comment) }
    it { should validate_presence_of(:author_id) }
    it { should validate_presence_of(:commentable_id) }
    it { should validate_presence_of(:commentable_type) }
    it { should validate_inclusion_of(:commentable_type).in_array(%w(User Goal)) }
  end

  context "associations" do
    it { should belong_to(:author) }
    it { should belong_to(:commentable) }
  end
end
