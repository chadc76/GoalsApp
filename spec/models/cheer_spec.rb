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
require 'rails_helper'

RSpec.describe Cheer, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
