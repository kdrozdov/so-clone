class QuestionsController <  ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_question, only: [:show, :edit, :update, :destroy]
  before_action :verify_authorship, only: [:edit, :update, :destroy]
  before_action :set_answer, only: [:show]
  after_action :publish_question, only: [:create, :update, :destroy]

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

  def question_params
    params.require(:question).permit(:title, :body, attachments_attributes: [:file, :id, :_destroy])
  end

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

  def set_question
    @question = Question.find(params[:id])
  end

  def set_answer
    @answer = Answer.new
  end

  def verify_authorship
    unless current_user.author_of?(@question)
      message = 'You do not have permission to perform this action.'
      redirect_to(@question, flash: { warning: message })
    end
  end
end
