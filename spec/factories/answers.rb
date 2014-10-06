# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :answer do
    body "MyText"
 	  association :question
    association :author, factory: :user
  end

  factory :invalid_answer, class: "Answer" do
  	body nil
    association :question
    association :author, factory: :user
  end
end
