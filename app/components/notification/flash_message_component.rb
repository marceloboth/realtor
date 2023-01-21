# frozen_string_literal: true

module Notification
  class FlashMessageComponent < ViewComponent::Base
    def initialize(flash)
      @flash = flash
    end
  end
end
