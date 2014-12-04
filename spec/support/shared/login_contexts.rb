shared_context 'login user', login: :user do
  before do |e|
    unless e.metadata[:skip_login]
      @user = create(:user)
      @request.env['devise.mapping'] = Devise.mappings[:user]
      sign_in @user
    end
  end
end

shared_context 'login question author', login: :question_author do
  let(:question) { create(:question) }
  before do |e|
    unless e.metadata[:skip_login]
      @user = question.author
      @request.env['devise.mapping'] = Devise.mappings[:user]
      sign_in @user
    end
  end
end

shared_context 'login answer author', login: :answer_author do
  let(:answer) { create(:answer) }
  before do |e|
    unless e.metadata[:skip_login]
      @user = answer.author
      @question = answer.question
      @request.env['devise.mapping'] = Devise.mappings[:user]
      sign_in @user
    end
  end
end