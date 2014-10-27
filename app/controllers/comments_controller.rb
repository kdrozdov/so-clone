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
    if @comment.valid?
      question_id = @comment.commentable.id if @comment.commentable.instance_of? Question
      question_id ||= @comment.commentable.question.id
      channel = "/questions/#{question_id}"
      json = { type: 'comment', action: action_name }

      if action_name == 'destroy'
        json[:comment_id] = @comment.id
      else
        json[:comment] = CommentSerializer.new(@comment, root: false).to_json
      end
      PrivatePub.publish_to(channel, json)
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