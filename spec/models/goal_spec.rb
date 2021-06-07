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
require 'rails_helper'

RSpec.describe Goal, type: :model do
  let(:user) { User.create!(email: 'new@user', password: 'password') }
  subject(:goal) { Goal.new(title: "New Goal", details: "New Goal Details", user_id: user.id) }
  it { should validate_presence_of(:title) }
  it { should validate_length_of(:title).is_at_least(6) }
  it { should validate_presence_of(:user_id) }
end
