class QuestionsController <  ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_question, only: [:show, :edit, :update, :destroy]
  before_action :verify_authorship, only: [:edit, :update, :destroy]

  def index
    @questions = Question.all
  end

  def show
    @answer = Answer.new
  end

  def new
    @question = Question.new
  end

  def create
    @question = current_user.questions.new(question_params)

    if @question.save
      message = 'Your question successfully created.'
      redirect_to(@question, flash: { success: message })
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @question.update(question_params)
      redirect_to @question
    else
      render :edit
    end
  end

  def destroy
    if @question.destroy
      flash[:success] = 'Your question successfully deleted.'
    end
    redirect_to root_path
  end

  private

  def question_params
    params.require(:question).permit(:title, :body, attachments_attributes: [:file, :id, :_destroy])
  end

  def set_question
    @question = Question.find(params[:id])
  end

  def verify_authorship
    unless current_user.author_of?(@question)
      message = 'You do not have permission to perform this action.'
      redirect_to(@question, flash: { warning: message })
    end
  end
end
