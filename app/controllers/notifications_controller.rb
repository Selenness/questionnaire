class NotificationsController < ApplicationController
  def create
    Notification.create(notification_params)
    head :ok
  end

  def destroy
    @notification = Notification.find_by_user_id_and_question_id(current_user.id, params[:question_id])
    @notification.destroy if @notification.present?
    head :ok
  end

  private

  def notification_params
    output = params.permit(:question_id)
    output[:user_id] = current_user.id
    output
  end
end
