class NotificationsController < ApplicationController
  def create
    Notification.create(notification_params)
    head :ok
  end

  def destroy
    @notification = Notification.where(user_id: current_user.id, question_id: params[:question_id]).delete_all
    head :ok
  end

  private

  def notification_params
    output = params.permit(:question_id)
    output[:user_id] = current_user.id
    output
  end
end
