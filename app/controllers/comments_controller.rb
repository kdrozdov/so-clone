class CommentsController < ApplicationController
  before_action :authenticate_user!, only: [:create, :update, :destroy]
  before_action :set_comment, only: [:show, :update, :destroy]
  before_action :load_parent, only: [:create]
  after_action :publish_comment, only: [:create, :update, :destroy]

  respond_to :json

  def show
    respond_with(@comment)
  end

  def create
    respond_with(@comment = Comment.create(comment_params
      .merge(commentable: @parent, author: current_user)))
  end

  def update
    @comment.update(comment_params)
    respond_with(@comment)
  end

  def destroy
    respond_with(@comment.destroy)
  end

  private

  def publish_comment
    question_id = @comment.commentable.id if @comment.commentable.instance_of? Question
    question_id ||= @comment.commentable.question.id

    case action_name
    when 'destroy'
      PrivatePub.publish_to("/questions/#{question_id}",
                            comment_id: @comment.id,
                            type: @comment.class.name.downcase,
                            parent: @comment.commentable_type.downcase,
                            parent_id: @comment.commentable_id,
                            action: action_name)
    else
      PrivatePub.publish_to("/questions/#{question_id}",
                            comment: @comment.to_json,
                            type: @comment.class.name.downcase,
                            parent: @comment.commentable_type.downcase,
                            parent_id: @comment.commentable_id,
                            action: action_name) if @comment.valid?
    end
  end

  def load_parent
    @parent = Question.find(params[:question_id]) if params[:question_id]
    @parent ||= Answer.find(params[:answer_id])
  end

  def set_comment
    @comment = Comment.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end