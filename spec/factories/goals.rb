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
FactoryBot.define do
  factory :goal do
    title { Faker::Lorem.sentence(word_count: 3) }
    details { Faker::Lorem.paragraph(sentence_count: 7) }
    user_id { 1 }
    private { false }
    complete { false }
  end
end
