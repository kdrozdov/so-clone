class Api::V1::ProfilesController < Api::V1::BaseController
  authorize_resource class: User

  def me
    respond_with current_resource_owner, serializer: MeSerializer
  end

  def index
    @users = User.where('id != ?', current_resource_owner.id)
    respond_with @users, each_serializer: ProfilesSerializer
  end
end