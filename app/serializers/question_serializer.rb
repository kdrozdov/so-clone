class QuestionSerializer < ActiveModel::Serializer
  attributes :id, :title, :author_id, :body, :created_at, :updated_at

  has_many :attachments
  has_many :comments
end