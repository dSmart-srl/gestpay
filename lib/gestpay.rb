require 'savon'
require 'active_support/core_ext'

require "gestpay/version"
require "gestpay/custom_info"
require "gestpay/digest"
require "gestpay/gateway"
require "gestpay/configuration"
require "gestpay/result"
require "gestpay/iframe"

require "gestpay/error"

module Gestpay

  def self.setup
    yield self.config
  end

  def self.config
    @config ||= Configuration.new
  end

end
