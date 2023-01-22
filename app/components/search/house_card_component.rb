# frozen_string_literal: true

class Search::HouseCardComponent < ViewComponent::Base
  def initialize(house)
    @house = house
  end
end
