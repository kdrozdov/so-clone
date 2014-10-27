class CommentSerializer < ActiveModel::Serializer
  attributes :id, :author_id, :parent, :parent_id, :body, :created_at, :updated_at

  def parent
    object.commentable_type.downcase
  end

  def parent_id
    object.commentable_id
  end
end
