require 'rails_helper'

RSpec.describe CommentsController do

  describe 'POST #create', login: :user do
    let(:question) { create :question }
    let(:attributes) { attributes_for(:comment) }

    it_behaves_like 'AJAX authenticable'

    context 'when question is parent' do
      it 'loads question' do
        do_request
        expect(assigns(:parent)).to eq question
      end
    end

    context 'when answer is parent' do
      let(:answer) { create :answer }

      it 'loads answer when parent is answer' do
        do_request answer_id: answer
        expect(assigns(:parent)).to eq answer
      end
    end

    def do_request(options = { question_id: question })
      post :create, { comment: attributes, format: :json }.merge(options)
    end
  end
end