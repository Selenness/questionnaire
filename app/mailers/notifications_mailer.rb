class NotificationsMailer < ApplicationMailer
  def new_answer(notification_params)
    @user = notification_params[:user]
    @question = notification_params[:question]
    @answer = notification_params[:answer]

    mail(to: @user.email, subject: "New answer was created")
  end
end
