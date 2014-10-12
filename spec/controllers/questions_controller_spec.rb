require 'rails_helper'

RSpec.describe QuestionsController do
  let(:question) { create(:question) }
  let(:attributes) { attributes_for(:question) }

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

  describe 'GET #new', login: :user do
    let(:request) { get :new }
    it_behaves_like 'inhospitable'

    it 'assigns a new question to @question' do
      request
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'renders new view' do
      request
      expect(response).to render_template :new
    end
  end

  describe 'POST #create', login: :user do
    let(:request) { post :create, question: attributes }
    it_behaves_like 'inhospitable'

    context 'with valid attributes' do
      it 'saves the new question' do
        expect { request }.to change(@user.questions, :count).by(1)
      end

      it 'redirects to show view' do
        request
        expect(response).to redirect_to question_path(assigns(:question))
      end

      it 'sets the current user as question author' do
        request
        expect(assigns(:question).author).to eq subject.current_user
      end
    end

    context 'with invalid attributes' do
      let(:attributes) { attributes_for(:invalid_question) }

      it 'does not save the question' do
        expect { request }.to_not change(Question, :count)
      end

      it 're-renders new view' do
        request
        expect(response).to render_template :new
      end
    end
  end

  describe 'GET #edit', login: :question_author do
    let(:request) { get :edit, id: question }
    it_behaves_like 'inhospitable'
    it_behaves_like 'owner verifier'

    it 'assigns the requested question to @question' do
      request
      expect(assigns(:question)).to eq question
    end

    it 'renders edit view', sign_in: :question_author do
      request
      expect(response).to render_template :edit
    end
  end

  describe 'PATCH #update', login: :question_author do
    let(:request) { patch :update, id: question, question: attributes }
    it_behaves_like 'inhospitable'
    it_behaves_like 'owner verifier'

    context 'with valid attributes' do
      it 'assigns the requested question to @question' do
        request

        expect(assigns(:question)).to eq question
      end

      it 'changes question attributes' do
        patch(:update,
              id: question,
              question: { title: 'new title', body: 'new body' })
        question.reload

        expect(question.title).to eq 'new title'
        expect(question.body).to eq 'new body'
      end

      it 'redirects to the updated question' do
        request

        expect(response).to redirect_to question
      end
    end

    context 'with invalid attributes' do
      let(:attributes) { attributes_for(:invalid_question) }
      before { request }
      it 'does not change question attributes' do
        question.reload

        expect(question.title).to eq 'QuestionTitle'
        expect(question.body).to eq 'QuestionBody'
      end

      it 're-renders edit view' do
        expect(response).to render_template :edit
      end
    end

  end

  describe 'DELETE #destroy', login: :question_author do
    let(:request) { delete :destroy, id: question }
    it_behaves_like 'inhospitable'
    it_behaves_like 'owner verifier'

    it 'deletes question' do
      expect { request }.to change(@user.questions, :count).by(-1)
    end

    it 'redirects to root path' do
      request
      expect(response).to redirect_to root_path
    end
  end
end
