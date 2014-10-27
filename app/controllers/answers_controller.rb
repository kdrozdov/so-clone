class AnswersController < ApplicationController
  before_action :authenticate_user!, only: [:create, :update, :destroy]
  before_action :set_answer, only: [:show, :update, :destroy]
  before_action :set_question, only: [:create]
  before_action :verify_authorship, only: [:update, :destroy]
  after_action :publish_answer, only: [:create, :update, :destroy]

  respond_to :json

  def show
    respond_with(@answer)
  end

  def create
    respond_with(@answer = Answer.create(answer_params
      .merge(question: @question, author: current_user)))
  end

  def update
    @answer.update(answer_params)
    respond_with(@answer)
  end

  def destroy
    respond_with(@answer.destroy)
  end

  private

  def publish_answer
    if @answer.valid?
      channel = "/questions/#{@answer.question.id}"
      json = { type: 'answer', action: action_name }

      if action_name == 'destroy'
        json[:answer_id] = @answer.id
      else
        json[:answer] = AnswerSerializer.new(@answer, root: false).to_json
      end
      PrivatePub.publish_to(channel, json)
    end
  end

  def answer_params
    params.require(:answer).permit(:body, attachments_attributes: [:file, :id, :_destroy])
  end

  def verify_authorship
    return head :forbidden unless current_user.author_of?(@answer)
  end

  def set_answer
    @answer = Answer.find(params[:id])
  end

  def set_question
    @question = Question.find(params[:question_id])
  end
end
