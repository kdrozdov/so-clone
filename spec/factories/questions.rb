# == Schema Information
#
# Table name: questions
#
#  id         :integer          not null, primary key
#  title      :string(255)
#  body       :text
#  created_at :datetime
#  updated_at :datetime
#  author_id  :integer          not null
#

FactoryGirl.define do
  factory :question do
    title 'MyString'
    body 'MyText'
    association :author, factory: :user
  end

  factory :invalid_question, class: 'Question' do
    title nil
    body nil
    association :author, factory: :user
  end
end
