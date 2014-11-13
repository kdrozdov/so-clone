require 'rails_helper'

RSpec.describe 'Profile API' do
  describe 'GET #me' do
    it_behaves_like 'API Authenticable'

    context 'authorized' do
      let(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }

      before { do_request(access_token: access_token.token) }

      it 'returns 200 status' do
        expect(response).to be_success
      end

      %w{email id created_at updated_at}.each do |attr|
        it "contains #{attr}" do
          expect(response.body).to be_json_eql(me.send(attr.to_sym).to_json).at_path("me/#{attr}")
        end
      end

      %w{password encrypted_password}.each do |attr|
        it "does not contain #{attr}" do
          expect(response.body).to_not have_json_path("me/#{attr}")
        end
      end
    end

    def do_request(options={})
      get 'api/v1/profiles/me', { format: :json }.merge(options)
    end
  end

  describe 'GET #index' do
    it_behaves_like 'API Authenticable'

    context 'authorized' do
      let(:owner) { create(:user) }
      let!(:users) { create_list(:user, 2) }
      let(:user) { users.first }
      let(:access_token) { create(:access_token, resource_owner_id: owner.id) }

      before { do_request(access_token: access_token.token) }

      it 'returns 200 status' do
        expect(response).to be_success
      end

      it 'returns list of profiles' do
        puts response.body
        expect(response.body).to have_json_size(2).at_path('profiles')
      end

      %w{id username}.each do |attr|
        it "contains #{attr}" do
          expect(response.body).to be_json_eql(user.send(attr.to_sym).to_json).at_path("profiles/0/#{attr}")
        end
      end

      %w{email password encrypted_password}.each do |attr|
        it "does not contain #{attr}" do
          expect(response.body).to_not have_json_path("profiles/0/#{attr}")
        end
      end
    end

    def do_request(options={})
      get 'api/v1/profiles', { format: :json }.merge(options)
    end
  end
end