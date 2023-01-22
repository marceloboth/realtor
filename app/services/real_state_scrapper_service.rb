require 'faraday'
require 'nokogiri'

class RealStateScrapperService
  def self.run
    SimobScrapperService.call
  end
end
