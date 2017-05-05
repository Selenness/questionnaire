class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_question, only: [:show, :edit, :update, :destroy]
  before_action :check_author, only: [:edit, :update, :destroy]

  after_action :publish_question, only: [:create]

  def index
    @questions = Question.all
  end

  def show
    @answer = Answer.new
    @answer.attachments.build
    @comment = @question.comments.new
  end

  def new
    @question = Question.new
    @question.attachments.build
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
      redirect_to @question
    else
      render :edit
    end
  end

  def destroy
    @question.destroy!
    redirect_to questions_path
  end

  def publish_question
    return if @question.errors.any?
    renderer = ApplicationController.renderer.new
    renderer.instance_variable_set(:@env, {
        "HTTP_HOST"=>"localhost:3000",
       "HTTPS"=>"off",
       "REQUEST_METHOD"=>"GET",
       "SCRIPT_NAME"=>"",
       "warden" => env["warden"]
    })
    ActionCable.server.broadcast('questions', renderer.render(
        partial: 'questions/question',
        locals: { question: @question }
    ))
  end

  private

  def check_author
    redirect_to questions_path unless current_user.author_of?(@question)
  end

  def load_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body, attachments_attributes: [:file])
  end
end
