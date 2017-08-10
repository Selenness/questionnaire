class SearchForTerm
  def initialize(search_term, options = nil)
    @search_term = search_term
    @options = options
  end

  def call
    if @options.present?
      klass = @options.constantize
    else
      klass = ThinkingSphinx
    end
    klass.search(@search_term)
  end
end