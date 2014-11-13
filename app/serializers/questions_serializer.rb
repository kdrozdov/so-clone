class QuestionsSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :author_id, :created_at, :updated_at

  has_many :answers
end