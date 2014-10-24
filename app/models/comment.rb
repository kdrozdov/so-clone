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

class Comment < ActiveRecord::Base
  belongs_to :commentable, polymorphic: true
  belongs_to :author, class_name: 'User'

  validates :body, presence: true
end
