class AnswersController < ApplicationController
  before_action :authenticate_user!, only: [:create, :update, :destroy]
  before_action :set_question, only: [:create]
  before_action :set_answer, only: [:update, :destroy, :show]
  before_action :verify_authorship, only: [:update, :destroy]

  def show
  end

  def create
    @answer = @question.answers.build(answer_params)
    @answer.author = current_user
    @answer.save

    if @answer.save
      PrivatePub.publish_to("/questions/#{@question.id}/answers",
                            answer: (render template: 'answers/show.json.jbuilder'),
                            action: 'create')
    else
      render json: @answer.errors.full_messages, status: :unprocessable_entity
    end
  end

  def update
    if @answer.update(answer_params)
      PrivatePub.publish_to("/questions/#{@answer.question.id}/answers",
                            answer: (render template: 'answers/show.json.jbuilder'),
                            action: 'update')
    else
      render json: @answer.errors.full_messages, status: :unprocessable_entity
    end
  end

  def destroy
    PrivatePub.publish_to("/questions/#{@answer.question.id}/answers",
                          answer_id: @answer.id,
                          action: 'destroy')
    @answer.destroy
    head :no_content
  end

  private

  def answer_params
    params.require(:answer).permit(:body, attachments_attributes: [:file, :id, :_destroy])
  end

  def verify_authorship
    return head :forbidden unless current_user.author_of?(@answer)
  end

  def set_question
    @question = Question.find(params[:question_id])
  end

  def set_answer
    @answer = Answer.find(params[:id])
  end
end
