class QuestionAnswersChannel < ApplicationCable::Channel
  def subscribed
    stream_from "answers_for_#{params[:question_id]}"
  end
end