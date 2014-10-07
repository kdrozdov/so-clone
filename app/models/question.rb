# == Schema Information
#
# Table name: questions
#
#  id         :integer          not null, primary key
#  title      :string(255)
#  body       :text
#  created_at :datetime
#  updated_at :datetime
#  author_id  :integer          not null
#

class Question < ActiveRecord::Base
  belongs_to :author, class_name: 'User'
  has_many :answers, -> { order 'created_at DESC' }, dependent: :destroy
  has_many :attachments, dependent: :destroy
  validates :body, presence: true
  validates :title, presence: true, length: { maximum: 255 }
end
