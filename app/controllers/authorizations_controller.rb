class AuthorizationsController < ApplicationController
  before_action :set_user, only: [:update_profile]

  def update_profile
    if @user.update(user_params)
      sign_in(@user, bypass: true) #bypass?
      redirect_to root_path, notice: 'Your profile was successfully updated.'
    else
      render 'finish_signup'
    end
  end

  def finish_signup
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:email)
  end
end