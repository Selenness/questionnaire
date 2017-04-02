class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_question, only: [:show, :edit, :update, :destroy]

  def index
    @questions = Question.all
  end

  def show
    @answer = Answer.new
  end

  def new
    @question = Question.new
  end

  def edit
  end

  def create
    @question = Question.new(question_params.merge(user_id: current_user.id))
    if @question.save
      flash[:notice] = 'Your question successfully created.'
      redirect_to @question
    else
      flash[:notice] = 'Your question failed to create.'
      render :new
    end
  end

  def update
    if @question.update(question_params)
      if params[:question][:best_answer_id].present?
        render plain: "Best answer was successfully set"
      else
        redirect_to @question
      end
    else
      render :edit
    end
  end

  def destroy
    @question.destroy! if current_user.author_of?(@question)
    redirect_to questions_path
  end

  private
  def load_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body, :best_answer_id)
  end
end
