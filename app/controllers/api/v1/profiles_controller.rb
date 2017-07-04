class Api::V1::ProfilesController < Api::V1::BaseController
  def me
    respond_with current_resource_owner
  end

  def profiles_list
    respond_with User.where.not(id: doorkeeper_token.resource_owner_id)
  end
end