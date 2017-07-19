class Api::V1::QuestionsController < Api::V1::BaseController
  authorize_resource

  def index
    @questions = Question.all
    render json: @questions, each_serializer: QuestionsSerializer
  end

  def show
    @question = Question.find(params[:question_id])
    render json: @question, serializer: QuestionSerializer
  end

  def create
    @question = Question.create(question_params.merge(user_id: current_resource_owner.id))
    respond_with(@question)
  end

  private

  def question_params
    params.require(:question).permit(:title, :body)
  end
end