class AnswersController < ApplicationController
  before_action :authenticate_user!

  # def new
  #   @question = Question.find(params[:question_id])
  #   @answer = Answer.new
  # end

  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.new(answer_params.merge(user_id: current_user.id))
    if @answer.save
      flash[:notice] = 'Your answer successfully created.'
    else
      flash[:notice] = 'Your answer failed to create.'
    end
    redirect_to @question
  end

  def destroy
    @answer = Answer.find(params[:id])
    @answer.destroy if current_user == @answer.user
    redirect_to @answer.question
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end
end
