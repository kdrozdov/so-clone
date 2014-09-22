require 'rails_helper'

RSpec.describe QuestionsController do
	let(:question) { create(:question) }
	let(:answer) { create(:answer) }

	describe 'GET #index' do	
		let(:questions) { create_list(:question, 2) }
		before { get :index }

		it 'populates an array of all questions' do
			expect(assigns(:questions)).to match_array(questions)
		end

		it 'renders index view' do
			expect(response).to render_template :index
		end
	end

	describe 'GET #show' do
		before { get :show, id: question } 

		it 'assigns the requested question to @questions' do
			expect(assigns(:question)).to eq question
		end

		it 'assigns a new answer to @answer' do
			expect(assigns(:answer)).to be_a_new(Answer)
		end

		it 'renders show view' do
			expect(response).to render_template :show
		end
	end

	describe 'GET #new' do
		sign_in_user
		before { get :new }

		it 'assigns a new question to @question' do
			expect(assigns(:question)).to be_a_new(Question)
		end

		it 'renders new view' do 
			expect(response).to render_template :new
		end
	end

	describe 'POST #create' do 
		sign_in_user

		context 'with valid attributes' do
			it 'saves the new question' do
				expect { post :create, question: attributes_for(:question) }.to change(@user.questions, :count).by(1)				
			end
			it 'redirects to show view' do
				post :create, question: attributes_for(:question)
				expect(response).to redirect_to question_path(assigns(:question))
			end
		end

		context 'with invalid attributes' do
			it 'does not save the question' do
				expect { post :create, question: attributes_for(:invalid_question) }.to_not change(Question, :count)				
			end

			it 'does not save the question without author' do
				expect { post :create, question: attributes_for(:question_without_author) }.to_not change(Question, :count)				
			end

			it 're-renders new view' do
				post :create, question: attributes_for(:invalid_question)
				expect(response).to render_template :new
			end
		end
	end

	describe 'GET #edit' do
		sign_in_user
		before { get :edit, id: question }

		it 'assigns the requested question to @question' do
			expect(assigns(:question)).to eq question
		end

		it 'renders edit view' do 
			expect(response).to render_template :edit
		end
	end

	describe 'PATCH #update' do
		sign_in_user

		context 'with valid attributes' do
			it 'assigns the requested question to @question' do
				patch :update, id: question, question: attributes_for(:question)

				expect(assigns(:question)).to eq question
			end

			it 'changes question attributes' do
				patch :update, id:question, question: { title: 'new title', body: 'new body' }
				question.reload

				expect(question.title).to eq 'new title'
				expect(question.body).to eq 'new body'
			end

			it 'redirects to the updated question' do
				patch :update, id: question, question: attributes_for(:question)

				expect(response).to redirect_to question
			end
		end

		context 'with invalid attributes' do
			before { patch :update, id:question, question: { title: nil, body: 'new body' } }
			it 'does not change question attributes' do
				question.reload

				expect(question.title).to eq 'MyString'
				expect(question.body).to eq 'MyText'
			end

			it 're-renders edit view' do
				expect(response).to render_template :edit
			end
		end
	end

end