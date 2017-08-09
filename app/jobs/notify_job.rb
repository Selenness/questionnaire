class NotifyJob < ApplicationJob
  queue_as :mailers

  def perform(answer)
    answer.question.subscribers.each do |subscriber|
      NotificationsMailer.new_answer(
          user: subscriber,
          question: answer.question,
          answer: answer
      ).deliver_later
    end
  end
end