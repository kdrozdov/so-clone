class UsersController < ApplicationController
  before_action :authenticate_user!, only: [:finish_signup, :update_profile]
  before_action :set_user, only: [:finish_signup, :update_profile]

  authorize_resource

  def update_profile
    if @user.update(user_params)
      sign_in(@user, bypass: true)
      notice = 'A message with a confirmation link has been sent to your email address.'
      redirect_to root_path, notice: notice
    else
      render 'finish_signup'
    end
  end

  def finish_signup
  end

  private

  def set_user
    @user = current_user
  end

  def user_params
    params.require(:user).permit(:email)
  end
end