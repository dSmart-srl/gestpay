module Gestpay
  class Digest

    def config
      Gestpay.config
    end

    attr_accessor :client
    def initialize
      url = case Gestpay.config.environment
      when :test
        'https://testecomm.sella.it/gestpay/gestpayws/WSCryptDecrypt.asmx?WSDL'
      when :production
        'https://ecomms2s.sella.it/gestpay/gestpayws/WSCryptDecrypt.asmx?WSDL'
      end

      # SOAP Client operations:
      # => [:encrypt, :decrypt]
      @client = Savon.client(:wsdl => url)
    end

    def soap_options(data)
      {
        :message => {
          :shop_login => config.account
        }.merge(data)
      }
    end

    def encrypt(data)
      response = @client.call(:encrypt, soap_options(data))
      result = response.body[:encrypt_response][:encrypt_result][:gest_pay_crypt_decrypt]
      raise Gestpay::Error::FailedDigest.new(result[:error_code], result[:error_description]) unless result[:transaction_result] == 'OK'
      result[:crypt_decrypt_string]
    end

    def decrypt(string)
      response = @client.call(:decrypt, soap_options({'CryptedString' => string}))
      result = response.body[:decrypt_response][:decrypt_result][:gest_pay_crypt_decrypt]
      raise Gestpay::Error::FailedDigest.new(result[:error_code], result[:error_description]) unless result[:transaction_result] == 'OK'
      result
    end

  end
end
