require 'rails_helper'

RSpec.describe AnswersController do
	let(:question) { create(:question) }
	let(:attributes) { attributes_for(:answer) }

	describe "POST #create", login: :user do
		let(:request) { post :create, question_id: question, answer: attributes, format: :js }
		it_behaves_like 'AJAX inhospitable'

		context "with valid attributes" do
			it "saves the new answer" do
				expect { request }.to change(question.answers, :count).by(1)
			end

			it 'sets the current user as answer author' do
				request
				expect(assigns(:answer).author).to eq @user
			end

			it "render create template" do
				request
				expect(response).to render_template :create
			end
		end

		context "with invalid attributes" do
			let(:attributes) { attributes_for(:invalid_answer) }

			it "does not save the answer" do
				expect { request }.to_not change(Answer, :count)
			end

			it "render create template" do
				request
				expect(response).to render_template :create
			end
		end
	end

	describe "PATCH #update", login: :answer_author do
		let(:request) { patch :update, id: answer, question_id: answer.question, answer: attributes, format: :js }
		it_behaves_like 'AJAX inhospitable'
		it_behaves_like 'AJAX owner verifier'

		it 'renders update view' do
			request
			expect(response).to render_template :update
		end

		context "with valid attributes" do
			it "assigns the requested answer to @answer" do
				request

				expect(assigns(:answer)).to eq answer
			end

			it "changes answer attributes" do
				patch :update, id:answer, question_id: question, answer: { body: "new body" }, format: :js
				answer.reload

				expect(answer.body).to eq "new body"
			end
		end

		context "with invalid attributes" do
			let(:attributes) { attributes_for(:invalid_answer) }
			it "does not change answer attributes" do
				request
				answer.reload

				expect(answer.body).to eq "MyText"
			end
		end

	end
end