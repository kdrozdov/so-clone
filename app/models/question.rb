class Question < ActiveRecord::Base
	belongs_to :author, class_name: "User"
	has_many :answers, -> { order "created_at DESC" }, dependent: :destroy
	validates :body, presence: true
	validates :title, presence: true, length: {maximum: 255}
end
