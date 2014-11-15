class Api::V1::AnswersController < Api::V1::BaseController
  authorize_resource

  def index
    @answers = Answer.all
    respond_with @answers, each_serializer: AnswersSerializer
  end

  def show
    respond_with @answer = Answer.find(params[:id])
  end

  def create
    respond_with(@answer = Answer.create(answer_params
      .merge(author: current_resource_owner)))
  end

  private

  def answer_params
    params.require(:answer).permit(:title, :body)
  end
end