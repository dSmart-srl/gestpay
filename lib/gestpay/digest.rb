module Gestpay
  class Digest

    URL = {
      :test       => 'https://testecomm.sella.it/gestpay/gestpayws/WSCryptDecrypt.asmx?WSDL',
      :production => 'https://ecomms2s.sella.it/gestpay/gestpayws/WSCryptDecrypt.asmx?WSDL'
    }

    def config
      Gestpay.config
    end

    attr_accessor :client
    def initialize
      # SOAP Client operations:
      # => [:encrypt, :decrypt]
      @client = Savon.client(:wsdl => URL[Gestpay.config.environment])
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
      response_content = response.body[:encrypt_response][:encrypt_result][:gest_pay_crypt_decrypt]
      Result::Encrypt.new(response_content)
    end

    def decrypt(string)
      response = @client.call(:decrypt, soap_options({'CryptedString' => string}))
      response_content = response.body[:decrypt_response][:decrypt_result][:gest_pay_crypt_decrypt]
      Result::Decrypt.new(response_content)
    end

  end
end
