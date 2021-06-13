# == Schema Information
#
# Table name: comments
#
#  id               :bigint           not null, primary key
#  comment          :string           not null
#  author_id        :integer          not null
#  commentable_type :string
#  commentable_id   :bigint
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
require 'rails_helper'

RSpec.describe Comment, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
