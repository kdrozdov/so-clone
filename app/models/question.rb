class Question < ActiveRecord::Base
	has_many :answers, -> { order "created_at DESC" }
	validates :body, :title, presence: true
	validates :title, length: {maximum: 255}
end
