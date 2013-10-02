module Gestpay
  class Configuration

    CURRENCY_MAPPING = {
      'EUR' => '242',
      'ITL' => '18',
      'BRL' => '234',
      'USD' => '1',
      'JPY' => '71',
      'HKD' => '103'
    }

    LANGUAGE_MAPPING = {
      'ITA' => '1'
    }

    attr_accessor :environment, :account, :currency, :language
    def initialize
      @environment = ENV['GESTPAY_ENVIRONMENT'] || :test
      @account     = ENV['GESTPAY_ACCOUNT']
      @currency    = 'EUR'
      @language    = 'ITA'
    end

    def currency_code
      CURRENCY_MAPPING[@currency]
    end

    def language_code
      LANGUAGE_MAPPING[@language]
    end

  end
end

