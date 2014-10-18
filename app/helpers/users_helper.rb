module UsersHelper
  def current_user?(user)
    user == current_user
  end

  def user_is_author_of?(object)
    user_signed_in? && current_user == object.author
  end
end
