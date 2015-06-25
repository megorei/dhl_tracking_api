require 'nokogiri'
require 'patron'
# require "dhl_tracking_api/version"
require "dhl_tracking_api/api_wrapper"
require "dhl_tracking_api/response"


class DhlTrackingApi

  Config = Struct.new(:username, :password)

  def initialize
    @api_wrapper = ApiWrapper.new
  end

  def request(tracking_code)
    tracking_code = tracking_code.to_s.gsub(/[^\w]/, '')
    @api_wrapper.process(tracking_code)
    Response.new(@api_wrapper)
  end

  def self.config
    @config ||= Config.new
  end


end
