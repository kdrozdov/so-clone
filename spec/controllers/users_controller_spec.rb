require 'rails_helper'

RSpec.describe UsersController do
  
  describe 'GET #finish_signup' do
    let(:user) { create(:user, email: 'change@me-123456-twitter.com') }
    
    before { |e| login(user) unless e.metadata[:skip_login] }
    before { |e| do_request unless e.metadata[:skip_request] }

    it_behaves_like 'authenticable'

    it 'assigns user to @user' do
      expect(assigns(:user)).to eq user
    end

    it 'renders finish signup view' do
      expect(response).to render_template :finish_signup
    end

    def do_request
      get :finish_signup, id: user
    end
  end

  describe 'GET #update_profile' do
    let(:user) { create(:user, email: 'change@me-123456-twitter.com') }
    let(:attributes) {{ email: 'new@test.com' }}
    
    before { |e| login(user) unless e.metadata[:skip_login] }
    before { |e| do_request unless e.metadata[:skip_request] }
    
    it_behaves_like 'authenticable'

    context 'with valid attributes' do
      it 'assigns uset to @user' do
        expect(assigns(:user)).to eq user
      end

      it 'changes user attributes' do
        user.reload
        user.confirm!

        expect(user.email).to eq 'new@test.com'
      end

      it 'redirects to root path' do
        expect(response).to redirect_to root_path
      end
    end

    context 'with invalid attributes' do
      let(:attributes) {{ email: '' }}

      it 'does not change question attributes' do
        user.reload
        expect(user.email).to eq 'change@me-123456-twitter.com'
      end

      it 're-renders finish signup view' do
        expect(response).to render_template :finish_signup
      end
    end

    def do_request
      patch :update_profile, id: user, user: attributes
    end
  end
end