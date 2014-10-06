class Answer < ActiveRecord::Base
  belongs_to :author, class_name: "User"
	belongs_to :question 
	validates :body, presence: true
end
