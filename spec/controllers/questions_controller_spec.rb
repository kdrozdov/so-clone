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
    before { |e| do_request unless e.metadata[:skip_request] }
    it_behaves_like 'authenticable'

    it 'assigns a new question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end

    def do_request
      get :new
    end
  end

  describe 'POST #create', login: :user do
    before { |e| do_request unless e.metadata[:skip_request] }
    it_behaves_like 'authenticable'

    context 'with valid attributes' do
      it 'saves the new question', skip_request: true do
        expect { do_request }.to change(@user.questions, :count).by(1)
      end

      it 'redirects to show view' do
        expect(response).to redirect_to question_path(assigns(:question))
      end

      it 'sets the current user as question author' do
        expect(assigns(:question).author).to eq @user
      end

      it 'publishes a message to questions channel', skip_request: true do
        expect(PrivatePub).to receive(:publish_to).with('/questions', anything)
        do_request
      end
    end

    context 'with invalid attributes' do
      let(:attributes) { attributes_for(:invalid_question) }

      it 'does not save the question', skip_request: true do
        expect { do_request }.to_not change(Question, :count)
      end

      it 're-renders new view' do
        expect(response).to render_template :new
      end

      it 'does not publish a message to PrivatePub', skip_request: true do
        expect(PrivatePub).to_not receive(:publish_to)
        do_request
      end
    end

    def do_request
      post :create, question: attributes
    end
  end

  describe 'GET #edit', login: :question_author do
    before { |e| do_request unless e.metadata[:skip_request] }
    it_behaves_like 'authenticable'

    it 'assigns the requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'renders edit view', sign_in: :question_author do
      expect(response).to render_template :edit
    end

    def do_request
      get :edit, id: question
    end
  end

  describe 'PATCH #update', login: :question_author do
    let(:attributes) {{ title: 'new title', body: 'new body' }}
    before { |e| do_request unless e.metadata[:skip_request] }

    it_behaves_like 'authenticable'

    context 'with valid attributes' do
      it 'assigns the requested question to @question' do
        expect(assigns(:question)).to eq question
      end

      it 'changes question attributes' do
        question.reload

        expect(question.title).to eq 'new title'
        expect(question.body).to eq 'new body'
      end

      it 'redirects to the updated question' do
        expect(response).to redirect_to question
      end

      it 'publishes a message to questions channel', skip_request: true do
        expect(PrivatePub).to receive(:publish_to).with('/questions', anything)
        do_request
      end
    end

    context 'with invalid attributes' do
      let(:attributes) { attributes_for(:invalid_question) }

      it 'does not change question attributes' do
        question.reload

        expect(question.title).to eq 'QuestionTitle'
        expect(question.body).to eq 'QuestionBody'
      end

      it 're-renders edit view' do
        expect(response).to render_template :edit
      end

      it 'does not publish a message to PrivatePub', skip_request: true do
        expect(PrivatePub).to_not receive(:publish_to)
        do_request
      end
    end

    def do_request
        patch :update, id: question, question: attributes
    end
  end

  describe 'DELETE #destroy', login: :question_author do
    it_behaves_like 'authenticable'

    it 'deletes question' do
      expect { do_request }.to change(@user.questions, :count).by(-1)
    end

    it 'redirects to index view' do
      do_request
      expect(response).to redirect_to questions_path
    end

    it 'publishes a message to questions channel', skip_request: true do
      expect(PrivatePub).to receive(:publish_to).with('/questions', anything)
      do_request
    end

    def do_request
      delete :destroy, id: question
    end
  end
end
