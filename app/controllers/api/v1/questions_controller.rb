class Api::V1::QuestionsController < Api::V1::BaseController
  authorize_resource

  def index
    @questions = Question.all
    respond_with @questions, each_serializer: QuestionsSerializer
  end

  def show
    respond_with @question = Question.find(params[:id])
  end

  def create
    respond_with(@questoion = Question.create(question_params
      .merge(author: current_resource_owner)))
  end

  private
  
  def question_params
    params.require(:question).permit(:title, :body)
  end
end