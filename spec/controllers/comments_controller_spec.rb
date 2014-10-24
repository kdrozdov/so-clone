require 'rails_helper'

RSpec.describe CommentsController do

  describe 'POST #create', login: :user do
    let(:question) { create :question }
    let(:request) do
      post(:create,
      question_id: question,
      comment: attributes_for(:comment),
      format: :json)
    end
    it_behaves_like 'AJAX inhospitable'

    context 'when question is parent' do
      it 'loads question' do
        request
        expect(assigns(:parent)).to eq question
      end
    end

    context 'when answer is parent' do
      let(:answer) { create :answer }
      let(:request) do
        post(:create,
        answer_id: answer,
        comment: attributes_for(:comment),
        format: :json)
      end

      it 'loads answer when parent is answer' do
        request
        expect(assigns(:parent)).to eq answer
      end
    end
  end
end