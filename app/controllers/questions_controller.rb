class QuestionsController <  ApplicationController
	before_action :authenticate_user!, except: [:index, :show]
	def index
		@questions = Question.all
	end

	def show
		@question = Question.find(params[:id])
		@answer = Answer.new
	end

	def new 
		@question = Question.new
	end

	def create
		@question = Question.create(question_params)

		if @question.save
			flash[:success] = "Your question successfully created."
			redirect_to @question
		else 
			render :new
		end
	end

	private 

	def question_params
		params.require(:question).permit(:title, :body)
	end
end