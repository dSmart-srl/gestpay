module Gestpay
  class Gateway

    def config
      Gestpay.config
    end

    attr_accessor :client
    def initialize
      url = case Gestpay.config.environment
      when :test
        'https://testecomm.sella.it/gestpay/gestpayws/WSs2s.asmx?WSDL'
      when :production
        'https://ecomms2s.sella.it/gestpay/gestpayws/WSs2s.asmx?WSDL'
      end

      # SOAP Client operations:
      # => [:call_refund_s2_s, :call_read_trx_s2_s, :call_pagam_s2_s, :call_delete_s2_s, :call_settle_s2_s, :call_verifycard_s2_s, :call_check_carta_s2_s, :call_renounce, :call_request_token_s2_s, :call_delete_token_s2_s]
      @client = Savon.client(:wsdl => url)
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
      data[:custom_info] = data[:custom_info].to_query.gsub('&', '*P1*') if data[:custom_info]
      response = @client.call(:call_pagam_s2_s, soap_options(data))
      response_hash = response.body[:call_pagam_s2_s_response][:call_pagam_s2_s_result][:gest_pay_s2_s]
      if response_hash[:transaction_result] != 'OK'
        case response_hash[:error_code]
        when '8006'
          raise Gestpay::Error::VerifyVisa.new(response_hash)
        else
          raise Gestpay::Error::FailedDigest.new(response_hash[:error_code], response_hash[:error_description])
        end
      end
      result = {
        :amount => BigDecimal(response_hash.delete(:amount)),
        :info   => response_hash
      }
    end

    def request_token(data, verify=true)
      opts = {
        request_token: 'MASKEDPAN',
        with_auth: verify ? 'Y' : 'N'
      }
      response = @client.call(:call_request_token_s2_s, soap_options(data.merge(opts)))
      result = {}
      response_hash = response.body[:call_request_token_s2_s_response][:call_request_token_s2_s_result][:gest_pay_s2_s]
      raise Gestpay::Error::FailedDigest.new(response_hash[:transaction_error_code], response_hash[:transaction_error_description]) unless response_hash[:transaction_result] == 'OK'
      result[:token] = response_hash.delete(:token)
      result[:info] = response_hash
      result
    end

  end
end
