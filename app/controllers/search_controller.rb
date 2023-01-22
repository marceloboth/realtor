# frozen_string_literal: true

class SearchController < AuthenticatedController
  def index
    @query = House.ransack(params[:query])
    @houses = @query.result(distinct: true)
  end
end
