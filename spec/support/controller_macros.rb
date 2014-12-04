module ControllerMacros
  def login_user
    @user = create(:user)
    @request.env['devise.mapping'] = Devise.mappings[:user]
    sign_in @user
  end

  def login(user)
    @request.env['devise.mapping'] = Devise.mappings[:user]
    sign_in user
  end
end
