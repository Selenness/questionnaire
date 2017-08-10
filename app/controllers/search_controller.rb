class SearchController < ApplicationController
  before_action :escape_term

  def search
    @result = SearchForTerm.new(@term, params[:options]).call
  end

  private

  def escape_term
    @term = Riddle.escape(params[:term])
  end
end
