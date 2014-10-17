class AnswersController < ApplicationController
  before_action :authenticate_user!, only: [:create, :update, :destroy]
  before_action :set_question, only: [:create]
  before_action :set_answer, only: [:update, :destroy, :show]
  before_action :verify_authorship, only: [:update, :destroy]

  def create
    @answer = @question.answers.build(answer_params)
    @answer.author = current_user
    @answer.save

    if @answer.save
      render :show, status: :created
    else
      render json: @answer.errors.full_messages, status: :unprocessable_entity
    end
  end

  def update
    if @answer.update(answer_params)
      render :show, status: :ok
    else
      render json: @answer.errors.full_messages, status: :unprocessable_entity
    end
  end

  def show
  end

  def destroy
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
