class QuestionsController <  ApplicationController
	before_action :load_question, only: [:show, :edit, :update]
	before_action :authenticate_user!, except: [:index, :show]
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
			flash[:success] = "Your question successfully created."
			redirect_to @question
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

	private 

	def question_params
		params.require(:question).permit(:title, :body)
	end

	def load_question
		@question = Question.find(params[:id])
	end
end