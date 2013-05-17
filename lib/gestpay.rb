require 'savon'

require "gestpay/version"
require "gestpay/digest"
require "gestpay/configuration"

require "gestpay/error"

module Gestpay

  def self.setup
    yield self.config
  end

  def self.config
    @config ||= Configuration.new
  end

  # def self.client(options={})
  #   @client ||= Client.new(options)
  # end

end
