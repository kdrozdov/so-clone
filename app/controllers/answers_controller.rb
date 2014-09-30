class AnswersController < ApplicationController
	before_action :authenticate_user!, only: [:create]
	def create
		@question = Question.find(params[:question_id])
		@question.answers.create(answer_params)
		# @answer = @question.answers.build(answer_params)
		# if @answer.save
		# 	flash[:success] = "Your answer successfully created."
		# end

	end

	private 
	
	def answer_params
		params.require(:answer).permit(:body)
	end
end