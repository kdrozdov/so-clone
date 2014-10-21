class AnswersController < ApplicationController
  before_action :authenticate_user!, only: [:create, :update, :destroy]
  before_action :create_answer, only: [:create]
  before_action :set_answer, only: [:show, :update, :destroy]
  before_action :verify_authorship, only: [:update, :destroy]
  after_action :publish_answer, only: [:create, :update, :destroy]

  respond_to :json

  def show
    respond_with(@answer) 
  end

  def create
    respond_with(@answer)    
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
    case action_name
    when 'destroy'
      PrivatePub.publish_to("/questions/#{@answer.question.id}/answers",
                            answer_id: @answer.id,
                            action: action_name)
    else
      PrivatePub.publish_to("/questions/#{@answer.question.id}/answers",
                            answer: AnswerSerializer.new(@answer, root: false).to_json,
                            action: action_name) if @answer.valid?
    end
  end

  def create_answer
    @question = Question.find(params[:question_id])
    @answer = @question.answers.build(answer_params)
    @answer.author = current_user
    @answer.save
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
end
