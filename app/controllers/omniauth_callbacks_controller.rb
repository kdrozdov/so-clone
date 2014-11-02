class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  before_action :find_user, only: [:facebook, :twitter]
  before_action :soc_net_sign_in, only: [:facebook, :twitter]

  def facebook
  end

  def twitter
  end

  private

  def find_user
    @user = User.find_for_oauth(request.env['omniauth.auth'])
  end

  def soc_net_sign_in
    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: action_name) if is_navigational_format?
    end
  end

  def after_sign_in_path_for(resource)
    if resource.email_verified?
      super resource
    else
      finish_signup_path(resource)
    end
  end
end