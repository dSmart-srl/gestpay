module Gestpay
  class Configuration

    attr_accessor :environment, :account
    def initialize
      @environment = ENV['GESTPAY_ENVIRONMENT'] || :test
      @account = ENV['GESTPAY_ACCOUNT']
    end

  end
end
