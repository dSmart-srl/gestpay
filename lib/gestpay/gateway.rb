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
      savon_options = {:wsdl => URL[Gestpay.config.environment]}
      if Gestpay.config.proxy
        savon_options.merge!({ :proxy=> URI.parse(Gestpay.config.proxy)})
      end
      @client = Savon.client(savon_options)
    end

    def soap_options(data)
      {
        :message => {
          :shop_login  => config.account,
          :uic_code    => config.currency_code,
          :language_id => config.language_code
        }.merge(data)
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

  end
end
