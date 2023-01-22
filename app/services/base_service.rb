require 'faraday'
require 'nokogiri'

class BaseService
  URL = ''.freeze
  QUERY = ''.freeze

  include CallableService
end
