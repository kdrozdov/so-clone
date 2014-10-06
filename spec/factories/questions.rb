FactoryGirl.define do
  factory :question do
    title "MyString"
    body "MyText"
    association :author, factory: :user
  end

  factory :invalid_question, class: "Question" do
  	title nil
  	body nil
  	association :author, factory: :user
  end
end
