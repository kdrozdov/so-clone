require 'rails_helper'

RSpec.describe 'Profile API' do
  describe 'GET #index' do
    let(:question) { create(:question) }

    it_behaves_like 'API Authenticable'

    context 'authorized' do
      let!(:answers) { create_list(:answer, 2, question: question) }
      let(:access_token) { create(:access_token) }
      let(:answer) { answers.first }

      before { do_request(access_token: access_token.token) }
      
      it 'returns 200 status code' do
        expect(response).to be_success
      end

      it 'returns list of answers' do
        expect(response.body).to have_json_size(2).at_path('answers')
      end

      %w{id body question_id created_at updated_at}.each do |attr|
        it "answer object contains #{attr}" do
          expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("answers/0/#{attr}")
        end
      end

      it 'answer object contains author_id' do
        expect(response.body).to be_json_eql(answer.author.id.to_json).at_path('answers/0/author_id')
      end
    end

    def do_request(options = {})
      get "api/v1/questions/#{question.id}/answers", { format: :json }.merge(options)
    end
  end

  describe 'GET #show' do
    let(:answer) { create(:answer) }

    it_behaves_like 'API Authenticable'

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:comment) { create(:comment, commentable: answer) }
      let!(:attachment) { create(:attachment, attachmentable: answer) }

      before { do_request(access_token: access_token.token) }

      it 'returns 200 status code' do
        expect(response).to be_success
      end

      %w{id body question_id created_at updated_at}.each do |attr|
        it "contains #{attr}" do
          expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("answer/#{attr}")
        end
      end

      it 'contains author_id' do
        expect(response.body).to be_json_eql(answer.author.id.to_json).at_path('answer/author_id')
      end

      context 'attachments' do
        it 'included in answer object' do
          expect(response.body).to have_json_size(1).at_path('answer/attachments')
        end

         %w{id file_url}.each do |attr|
          it "contains #{attr}" do
            expect(response.body).to be_json_eql(attachment.send(attr.to_sym).to_json).at_path("answer/attachments/0/#{attr}")
          end
        end

        it 'contains filename' do
          expect(response.body).to be_json_eql(attachment.file.identifier.to_json).at_path('answer/attachments/0/filename')
        end
      end

      context 'comments' do
        it 'included in answer object' do
          expect(response.body).to have_json_size(1).at_path('answer/comments')
        end
      end
    end

    def do_request(options = {})
      get "api/v1/answers/#{answer.id}", { format: :json }.merge(options)
    end
  end

  describe 'POST #create' do
    let(:question) { create(:question) }

    it_behaves_like 'API Authenticable'

    context 'authorized' do
      let(:user) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: user.id) }

      context 'with valid attributes' do
        let(:attributes) { attributes_for(:answer) }

        it 'saves the new answer' do
          expect { do_request(access_token: access_token.token, answer: attributes) }.to change(user.answers, :count).by(1) 
        end

        it 'response with 201 status code' do
          do_request(access_token: access_token.token, answer: attributes)
          expect(response.status).to eq 201
        end
      end

      context 'with invalid attributs' do
        let(:attributes) { attributes_for(:invalid_answer) }

        it 'does not save the answer' do
          expect { do_request(access_token: access_token.token, answer: attributes) }.not_to change(user.answers, :count)
        end

        it 'response with 422 status code' do
          do_request(access_token: access_token.token, answer: attributes)
          expect(response.status).to eq 422 
        end
      end
    end

    def do_request(options={})
      post "api/v1/questions/#{question.id}/answers", { format: :json }.merge(options)
    end
  end
end