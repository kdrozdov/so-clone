module ControllerSharedExamples
  shared_examples_for 'inhospitable' do
    it 'redirects to sign in when user is not logged in', skip_login: true do
      request

      expect(response).to redirect_to new_user_session_path
    end
  end

  shared_examples_for 'AJAX inhospitable' do
    it 'responses with 401 Unauthorized', skip_login: true do
      request

      expect(response.status).to eq 401
    end
  end

  shared_examples_for 'owner verifier' do
    it 'response shoud be redirect', skip_login: true do
      login_user
      request

      expect(response).to be_redirect
    end
  end

  shared_examples_for 'AJAX owner verifier' do
    it 'responses with 403 Forbidden', skip_login: true do
      login_user
      request

      expect(response.status).to eq 403
    end
  end
end
