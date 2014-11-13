require 'rails_helper'

RSpec.describe 'Questions API' do
  describe 'GET #index' do
    it_behaves_like 'API Authenticable'

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:questions) { create_list(:question, 2) }
      let(:question) { questions.first }
      let!(:answer) { create(:answer, question: question) }

      before { do_request(access_token: access_token.token) }
      
      it 'returns 200 status code' do
        expect(response).to be_success
      end

      it 'returns list of questions' do
        expect(response.body).to have_json_size(2).at_path('questions')
      end

      %w{id title body created_at updated_at author_id}.each do |attr|
        it "question object contains #{attr}" do
          expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path("questions/0/#{attr}")
        end
      end

      context 'answers' do
        it 'included in question object' do
          expect(response.body).to have_json_size(1).at_path('questions/0/answers')
        end

        %w{id body created_at updated_at author_id}.each do |attr|
          it "contains #{attr}" do
            expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("questions/0/answers/0/#{attr}")
          end
        end
      end
    end

    def do_request(options={})
      get 'api/v1/questions', { format: :json }.merge(options)
    end
  end

  describe 'GET #show' do
    let(:question) { create(:question) }
    
    it_behaves_like 'API Authenticable'

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:comment) { create(:comment, commentable: question) }
      let!(:attachment) { create(:attachment, attachmentable: question) }
      
      before { do_request(access_token: access_token.token) }

      it 'returns 200 status code' do
        expect(response).to be_success
      end

      %w{id title body created_at updated_at author_id}.each do |attr|
        it "question object contains #{attr}" do
          expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path("question/#{attr}")
        end
      end

      context 'comments' do
        
        it 'included in question object' do
          expect(response.body).to have_json_size(1).at_path('question/comments')
        end

        %w{id body created_at updated_at author_id}.each do |attr|
          it "contains #{attr}" do
            expect(response.body).to be_json_eql(comment.send(attr.to_sym).to_json).at_path("question/comments/0/#{attr}")
          end
        end

        it 'contains parent' do
           expect(response.body).to be_json_eql(comment.commentable_type.downcase.to_json).at_path("question/comments/0/parent")
        end

        it 'contains parent_id' do
           expect(response.body).to be_json_eql(comment.commentable_id.to_json).at_path("question/comments/0/parent_id")
        end
      end

      context 'attachments' do

        it 'included in question object' do
          expect(response.body).to have_json_size(1).at_path('question/attachments')
        end

        %w{id file_url}.each do |attr|
          it "contains #{attr}" do
            expect(response.body).to be_json_eql(attachment.send(attr.to_sym).to_json).at_path("question/attachments/0/#{attr}")
          end
        end

        it 'contains filename' do
          expect(response.body).to be_json_eql(attachment.file.identifier.to_json).at_path('question/attachments/0/filename')
        end
      end
    end

    def do_request(options={})
      get "api/v1/questions/#{question.id}", { format: :json }.merge(options)
    end
  end

  describe 'POST #create' do
    let(:question) { create(:question) }

    it_behaves_like 'API Authenticable'

    context 'authorized' do
      let(:user) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: user.id) }

      context 'with valid attributes' do
        let(:attributes) { attributes_for(:question) }

        it 'saves the new question' do
          expect { do_request(access_token: access_token.token, question: attributes) }.to change(user.questions, :count).by(1) 
        end

        it 'response with 201 status code' do
          do_request(access_token: access_token.token, question: attributes)
          expect(response.status).to eq 201
        end
      end

      context 'with invalid attributs' do
        let(:attributes) { attributes_for(:invalid_question) }

        it 'does not save the question' do
          expect { do_request(access_token: access_token.token, question: attributes) }.not_to change(user.questions, :count)
        end

        it 'response with 422 status code' do
          do_request(access_token: access_token.token, question: attributes)
          expect(response.status).to eq 422
        end
      end
    end

    def do_request(options={})
      post "api/v1/questions", { format: :json }.merge(options)
    end
  end
end