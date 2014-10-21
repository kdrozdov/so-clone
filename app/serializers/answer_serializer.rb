class AnswerSerializer < ActiveModel::Serializer
  attributes :id, :question_id, :body, :created_at, :updated_at

  has_many :attachments
end
