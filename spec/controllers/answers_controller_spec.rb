require 'rails_helper'

RSpec.describe AnswersController do
	describe "POST #create" do 
		let(:question) { FactoryGirl.create(:question) }

		context 'with valid attributes' do
			it 'saves the new answer' do
				expect { post :create, question_id: question, answer: attributes_for(:answer) }.to change(Answer, :count).by(1)				
			end
			it 'redirects to question view' do
				post :create, question_id: question, answer: attributes_for(:answer)
				expect(response).to redirect_to  question_path(assigns(:question))
			end
		end

		context 'with invalid attributes' do
			it 'does not save the answer' do
				expect { post :create, question_id: question, answer: attributes_for(:invalid_answer) }.to_not change(Answer, :count)				
			end

			it 'redirects to question view' do
				post :create, question_id: question, answer: attributes_for(:invalid_answer)
				expect(response).to redirect_to  question_path(assigns(:question))
			end
		end
	end
end