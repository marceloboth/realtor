# frozen_string_literal: true

class SearchController < AuthenticatedController
  def index
    @houses = House.all
  end
end
