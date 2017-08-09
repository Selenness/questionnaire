class DigestMailer < ApplicationMailer
  def daily(email)
    @questions = Question.where('created_at >= ?', Time.now - 1.day)
    mail(to: email, subject: 'Questionnaire daily digest')
  end
end
