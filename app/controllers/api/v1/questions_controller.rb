class Api::V1::QuestionsController < Api::V1::BaseController

  def index
    @questions = Question.all
    render json: @questions, each_serializer: QuestionsSerializer
  end

  def show
    @question = Question.find(params[:question_id])
    render json: @question, serializer: QuestionSerializer
  end
end