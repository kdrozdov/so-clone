class AnswersController < ApplicationController
	before_action :authenticate_user!, only: [:create]
	def create
		@question = Question.find(params[:question_id])
		@answer = @question.answers.new(answer_params)

		if @answer.save
			flash[:success] = "Your answer successfully created."
		end

		redirect_to @question
	end

	private 
	
	def answer_params
		params.require(:answer).permit(:body)
	end
end