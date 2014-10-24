# == Schema Information
#
# Table name: comments
#
#  id               :integer          not null, primary key
#  body             :string(255)
#  commentable_id   :integer
#  commentable_type :string(255)
#  created_at       :datetime
#  updated_at       :datetime
#  author_id        :integer          not null
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :comment, class: "Comment" do
    body "Question comment"
    association :author, factory: :user
  end 

  # factory :answer_comment, class: "Comment" do
  #   body "Answer comment"
  #   association :author, factory: :user
  # end
end
