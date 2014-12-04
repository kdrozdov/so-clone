require 'rails_helper'

RSpec.describe AnswersController do
  let(:question) { create(:question) }
  let(:attributes) { attributes_for(:answer) }

  describe 'POST #create', login: :user do
    it_behaves_like 'AJAX authenticable'
    before { |e| do_request unless e.metadata[:skip_request] }

    context 'with valid attributes' do
      it 'saves the new answer', skip_request: true do
        expect { do_request }.to change(question.answers, :count).by(1)
      end

      it 'sets the current user as answer author' do
        expect(assigns(:answer).author).to eq @user
      end

      it 'have response status 201' do
        expect(response.status).to eq 201
      end
    end

    context 'with invalid attributes' do
      let(:attributes) { attributes_for(:invalid_answer) }

      it 'does not save the answer', skip_request:true do
        expect { do_request }.to_not change(Answer, :count)
      end

      it 'have response status 422' do
        expect(response.status).to eq 422
      end
    end

    def do_request
      post :create, question_id: question, answer: attributes, format: :json
    end
  end

  describe 'PATCH #update', login: :answer_author do
    let(:attributes) {{ body: 'new body' }}
    it_behaves_like 'AJAX authenticable'

    before { |e| do_request unless e.metadata[:skip_request] }

    context 'with valid attributes' do
      it 'assigns the requested answer to @answer' do
        expect(assigns(:answer)).to eq answer
      end

      it 'changes answer attributes' do
        answer.reload
        expect(answer.body).to eq 'new body'
      end

      it 'responses with 204 status' do
        expect(response.status).to eq 204
      end
    end

    context 'with invalid attributes' do
      let(:attributes) { attributes_for(:invalid_answer) }

      it 'does not change answer attributes' do
        answer.reload
        expect(answer.body).to eq 'AnswerBody'
      end

      it 'responses with 422 status' do
        expect(response.status).to eq 422
      end
    end

    def do_request
      patch :update, id: answer, answer: attributes, format: :json
    end
  end

  describe 'DELETE #destroy', login: :answer_author do
    it_behaves_like 'AJAX authenticable'

    it 'deletes answer' do
      expect { do_request }.to change(@question.answers, :count).by(-1)
    end

    it 'responses with 204 status' do
      do_request
      expect(response.status).to eq 204
    end

    def do_request
       delete :destroy, id: answer, question_id: answer.question, format: :json
    end
  end
end
