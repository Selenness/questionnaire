class SearchController < ApplicationController
  before_action :escape_term

  def search
    if params[:options].present?
      klass = params[:options].constantize
    else
      klass = ThinkingSphinx
    end
    @result = klass.search(@term)
  end

  private

  def escape_term
    @term = Riddle.escape(params[:term])
  end
end
