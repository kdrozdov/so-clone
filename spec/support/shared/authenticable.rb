shared_examples_for 'authenticable' do
  it 'redirects to sign in when user is not logged in', skip_login: true, skip_request: true do
    do_request

    expect(response).to redirect_to new_user_session_path
  end
end


shared_examples_for 'AJAX authenticable' do
  it 'responses with 401 status code', skip_login: true, skip_request: true do
    do_request

    expect(response.status).to eq 401
  end
end