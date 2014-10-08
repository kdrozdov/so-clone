# == Schema Information
#
# Table name: answers
#
#  id          :integer          not null, primary key
#  body        :text
#  created_at  :datetime
#  updated_at  :datetime
#  question_id :integer
#  author_id   :integer          not null
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :answer do
    body 'AnswerBody'
    association :question
    association :author, factory: :user
  end

  factory :invalid_answer, class: 'Answer' do
    body nil
    association :question
    association :author, factory: :user
  end
end
