class DigestMailer < ApplicationMailer
  def daily
    @mails = User.pluck(:email)
    @questions = Question.where('created_at >= ?', Time.now - 1.day)
    mail(to: @mails, subject: 'Questionnaire daily digest')
  end
end
