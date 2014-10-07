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

class Answer < ActiveRecord::Base
  belongs_to :author, class_name: 'User'
  belongs_to :question
  validates :body, presence: true
end
