require 'rails_helper'

RSpec.describe AnswersController do
	describe "POST #create" do 
		sign_in_user
		let(:question) { create(:question) }

		context "with valid attributes" do
			it "saves the new answer" do
				expect { post :create, question_id: question, answer: attributes_for(:answer), format: :js }.to change(question.answers, :count).by(1)				
			end

			it "render create template" do
				post :create, question_id: question, answer: attributes_for(:answer), format: :js
				expect(response).to render_template :create
			end
		end

		context "with invalid attributes" do
			it "does not save the answer" do
				expect { post :create, question_id: question, answer: attributes_for(:invalid_answer), format: :js }.to_not change(Answer, :count)				
			end

			it "render create template" do
				post :create, question_id: question, answer: attributes_for(:invalid_answer), format: :js
				expect(response).to render_template :create
			end
		end
	end
end