require 'rails_helper'

RSpec.describe UsersController do
  
  describe 'GET #finish_signup' do
    let(:user) { create(:user) }
    let(:other_user) { create(:user) }
    let(:request) { get :finish_signup, id: user }
    
    before do |e|
      unless e.metadata[:skip_login]
        login(user)
      end
    end

    it_behaves_like 'inhospitable'

    it 'assigns user to @user' do
      request
      expect(assigns(:user)).to eq user
    end

    it 'renders finish signup view' do
      request
      expect(response).to render_template :finish_signup
    end

    it 'redirects to root path when user is not current user' do
      get :finish_signup, id: other_user
      expect(response).to redirect_to root_path
    end
  end

  describe 'GET #update_profile' do
    let(:user) { create(:user, email: 'change@me-123456-twitter.com') }
    let(:other_user) { create(:user) }
    let(:request) { patch(:update_profile,
                    id: user,
                    user: { email: 'new@test.com' })}
    
    before do |e|
      unless e.metadata[:skip_login]
        login(user)
      end
    end

    it_behaves_like 'inhospitable'

    context 'with valid attributes' do
      it 'assigns uset to @user' do
        request
        expect(assigns(:user)).to eq user
      end

      it 'changes user attributes' do
        request
        user.reload
        user.confirm!

        expect(user.email).to eq 'new@test.com'
      end

      it 'redirects to root path' do
        request
        expect(response).to redirect_to root_path
      end
    end

    context 'with invalid attributes' do
      let(:request) { patch(:update_profile,
                      id: user,
                      user: { email: '' })}

      it 'does not change question attributes' do
        request
        user.reload

        expect(user.email).to eq 'change@me-123456-twitter.com'
      end

      it 're-renders finish signup view' do
        request
        expect(response).to render_template :finish_signup
      end
    end
  end
end