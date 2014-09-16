class Question < ActiveRecord::Base
	belongs_to :answers
	validates :body, presence: true
end
