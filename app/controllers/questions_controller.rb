class QuestionsController <  ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_question, only: [:show, :edit, :update, :destroy]
  before_action :set_answer, only: [:show]
  after_action :publish_question, only: [:create, :update, :destroy]

  authorize_resource
  respond_to :html

  def index
    respond_with(@questions = Question.all)
  end

  def show
    respond_with(@question)
  end

  def new
    respond_with(@question = Question.new)
  end

  def create
    respond_with(@question = current_user.questions.create(question_params))
  end

  def edit
  end

  def update
    @question.update(question_params)
    respond_with(@question)
  end

  def destroy
    respond_with(@question.destroy)
  end

  private

  def publish_question
    case action_name
    when 'destroy'
      PrivatePub.publish_to('/questions',
                            question_id: @question.id,
                            action: action_name)
    else
      PrivatePub.publish_to('/questions',
                            question: @question.to_json,
                            action: action_name) if @question.valid?
    end
  end

  def question_params
    params.require(:question).permit(:title, :body, attachments_attributes: [:file, :id, :_destroy])
  end

  def set_question
    @question = Question.find(params[:id])
  end

  def set_answer
    @answer = Answer.new
  end
end
