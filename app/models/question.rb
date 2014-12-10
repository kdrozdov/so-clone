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

  default_scope { order(created_at: :desc) }

  belongs_to :author, class_name: 'User'
  has_many :answers, -> { order 'created_at DESC' }, dependent: :destroy
  has_many :attachments, as: :attachmentable, dependent: :destroy
  has_many :comments, as: :commentable, dependent: :destroy

  validates :body, presence: true
  validates :title, presence: true, length: { maximum: 255 }

  paginates_per 15
  is_impressionable counter_cache: true, unique: :request_hash

  accepts_nested_attributes_for :attachments, reject_if: :all_blank, allow_destroy: true
end
