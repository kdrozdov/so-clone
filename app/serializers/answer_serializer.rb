class AnswerSerializer < ActiveModel::Serializer
  attributes :id, :author_id, :question_id, :body, :created_at, :updated_at

  has_many :attachments

  def author_id
    object.author.id
  end
end
