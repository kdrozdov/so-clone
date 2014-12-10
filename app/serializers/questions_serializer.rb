class QuestionsSerializer < ActiveModel::Serializer
  include ActionView::Helpers::DateHelper

  attributes :id, :title, :body, :author, :answers_count, :impressionist_count, :author_id, :created_time_ago, :created_at, :updated_at
  def author
    object.author.username
  end

  def created_time_ago
    time_ago_in_words(object.created_at)
  end
end