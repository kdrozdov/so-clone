class Answer < ActiveRecord::Base
	belongs_to :question, dependent: :destroy 
	validates :body, presence: true
end
