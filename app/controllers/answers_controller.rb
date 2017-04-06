class AnswersController < ApplicationController
  before_action :authenticate_user!

  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.new(answer_params.merge(user_id: current_user.id))
    if @answer.save
      @answer.attachments.create!(attachment_params[:attachments]) if params[:answer][:attachments].present?
      flash[:notice] = 'Your answer successfully created.'
    else
      flash[:alert] = "Your answer is not saved."
    end
  end

  def update
    @answer = Answer.find(params[:id])
    @question = @answer.question
    @answer.update_attributes(answer_params) if current_user.author_of?(@answer)
  end

  def set_best
    @answer = Answer.find(params[:id])
    @answer.set_best if current_user.author_of?(@answer.question)
    render plain: "Best answer was successfully set"
  end

  def destroy
    @answer = Answer.find(params[:id])
    @answer.destroy if current_user.author_of?(@answer)
    redirect_to @answer.question
  end

  private

  def answer_params
    params.require(:answer).permit(:body, :best)
  end

  def attachment_params
    params.require(:answer).permit(attachments: [:file])
  end
end
