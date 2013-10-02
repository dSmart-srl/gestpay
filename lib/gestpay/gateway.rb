module Gestpay
  class Gateway

    include Gestpay::CustomInfo

    URL = {
      :test       => 'https://testecomm.sella.it/gestpay/gestpayws/WSs2s.asmx?WSDL',
      :production => 'https://ecomms2s.sella.it/gestpay/gestpayws/WSs2s.asmx?WSDL'
    }

    def config
      Gestpay.config
    end

    attr_accessor :client
    def initialize
      # SOAP Client operations:
      # => [:call_refund_s2_s, :call_read_trx_s2_s, :call_pagam_s2_s, :call_delete_s2_s, :call_settle_s2_s, :call_verifycard_s2_s, :call_check_carta_s2_s, :call_renounce, :call_request_token_s2_s, :call_delete_token_s2_s]
      @client = Savon.client(:wsdl => URL[Gestpay.config.environment])
    end

    def soap_options(data, options = [:shop_login, :uic_code, :language_id])
      configuration_options = {
        :shop_login  => config.account,
        :uic_code    => config.currency_code,
        :language_id => config.language_code
      }

      {
        :message => configuration_options.slice(*options).merge(data)
      }
    end

    def payment(data)
      # Custom info must be enabled on Gestpay backoffice interface, by adding new parameters
      data[:custom_info] = gestpay_encode(data[:custom_info]) if data[:custom_info]
      response = @client.call(:call_pagam_s2_s, soap_options(data))
      response_content = response.body[:call_pagam_s2_s_response][:call_pagam_s2_s_result][:gest_pay_s2_s]
      Result::Payment.new(response_content)
    end

    def request_token(data, verify=true)
      opts = {
        :request_token => 'MASKEDPAN',
        :with_auth => verify ? 'Y' : 'N'
      }
      response = @client.call(:call_request_token_s2_s, soap_options(data.merge(opts)))
      response_content = response.body[:call_request_token_s2_s_response][:call_request_token_s2_s_result][:gest_pay_s2_s]
      Result::TokenRequest.new(response_content)
    end

    def settle(data)
      data[:bank_trans_ID] ||= data.delete(:bank_trans_id)
      data[:shop_trans_ID] ||= data.delete(:shop_trans_id)

      data = Hash[data.select { |k, v| v.present? }]

      response = @client.call(:call_settle_s2_s, soap_options(data, [:shop_login, :uic_code]))
      response_content = response.body[:call_settle_s2_s_response][:call_settle_s2_s_result][:gest_pay_s2_s]
      Result::Settle.new(response_content)
    end

  end
end

