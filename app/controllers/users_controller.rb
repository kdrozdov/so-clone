class UsersController < ApplicationController
  before_action :authenticate_user!, only: [:finish_signup, :update_profile]
  before_action :set_user, only: [:finish_signup, :update_profile]
  before_action :current_user?, only: [:finish_signup, :update_profile]

  authorize_resource

  def update_profile
    if @user.update(user_params)
      sign_in(@user, bypass: true)
      notice = 'Your profile was successfully updated. A message with a confirmation link has been sent to your email address.'
      redirect_to root_path, notice: notice
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

  def current_user?
    unless @user == current_user
      respond_with do |format|
        format.json { render json: nil, status: 403 }
        format.html { redirect_to root_path }
      end
    end
  end
end