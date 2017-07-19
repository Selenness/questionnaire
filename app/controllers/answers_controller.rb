class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_answer, only: [:update, :set_best, :destroy]
  after_action :publish_answers, only: [:create]

  respond_to   :js

  authorize_resource

  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.create(answer_params.merge(user_id: current_user.id))
    respond_with @answer
  end

  def update
    @question = @answer.question
    @answer.update_attributes(answer_params) if current_user.author_of?(@answer)
  end

  def set_best
    render plain: 'Best answer was successfully set'
  end

  def destroy
    @answer.destroy if current_user.author_of?(@answer)
    redirect_to @answer.question
  end

  private

  def load_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body, :best, attachments_attributes: [:file])
  end

  def publish_answers
    return if @answer.errors.any?
    renderer = ApplicationController.renderer.new
    renderer.instance_variable_set(:@env, {
        "HTTP_HOST"=>"localhost:3000",
        "HTTPS"=>"off",
        "REQUEST_METHOD"=>"GET",
        "SCRIPT_NAME"=>"",
        "warden" => env["warden"]
    })
    ActionCable.server.broadcast("answers_for_#{@question.id}", renderer.render(
        assigns: { question: @question },
        partial: 'answers/answer',
        locals: { answer: @answer })
    )
  end
end
