class Question < ActiveRecord::Base
	has_many :answers, -> { order "created_at DESC" }
	validates :body, presence: true
	validates :title, presence: true, length: {maximum: 255}
end
