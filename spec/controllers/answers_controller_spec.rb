require 'rails_helper'

RSpec.describe AnswersController do
  let(:question) { create(:question) }
  let(:attributes) { attributes_for(:answer) }

  describe 'POST #create', login: :user do
    let(:request) do
      post(:create,
           question_id: question,
           answer: attributes,
           format: :json)
    end
    it_behaves_like 'AJAX inhospitable'

    context 'with valid attributes' do
      it 'saves the new answer' do
        expect { request }.to change(question.answers, :count).by(1)
      end

      it 'sets the current user as answer author' do
        request
        expect(assigns(:answer).author).to eq @user
      end

      it 'have response status 201' do
        request
        expect(response.status).to eq 201
      end
    end

    context 'with invalid attributes' do
      let(:attributes) { attributes_for(:invalid_answer) }

      it 'does not save the answer' do
        expect { request }.to_not change(Answer, :count)
      end

      it 'have response status 422' do
        request
        expect(response.status).to eq 422
      end
    end
  end

  describe 'PATCH #update', login: :answer_author do
    let(:request) do
      patch(:update,
            id: answer,
            answer: attributes,
            format: :json)
    end
    it_behaves_like 'AJAX inhospitable'
    it_behaves_like 'AJAX owner verifier'

    context 'with valid attributes' do
      it 'assigns the requested answer to @answer' do
        request

        expect(assigns(:answer)).to eq answer
      end

      it 'changes answer attributes' do
        patch(:update,
              id: answer,
              answer: { body: 'new body' },
              format: :json)
        answer.reload

        expect(answer.body).to eq 'new body'
      end

      it 'responses with 200 status' do
        request
        expect(response.status).to eq 200
      end

    end

    context 'with invalid attributes' do
      let(:attributes) { attributes_for(:invalid_answer) }
      it 'does not change answer attributes' do
        request
        answer.reload

        expect(answer.body).to eq 'AnswerBody'
      end

      it 'responses with 422 status' do
        request
        expect(response.status).to eq 422
      end
    end
  end

  describe 'DELETE #destroy', login: :answer_author do
    let(:request) do
      delete(:destroy,
             id: answer,
             question_id: answer.question,
             format: :json)
    end
    it_behaves_like 'AJAX inhospitable'
    it_behaves_like 'AJAX owner verifier'

    it 'deletes answer' do
      expect { request }.to change(@question.answers, :count).by(-1)
    end

   it 'responses with 204 status' do
      request
      expect(response.status).to eq 204
    end
  end
end
