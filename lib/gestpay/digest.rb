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
      data[:custom_info] = data[:custom_info].collect{|k,v| "#{k}=#{v.unpack('H*')[0]}"}.join('*P1*') if data[:custom_info]

      response = @client.call(:encrypt, soap_options(data))
      response_content = response.body[:encrypt_response][:encrypt_result][:gest_pay_crypt_decrypt]
      Result::Encrypt.new(response_content)
    end

    def decrypt(string)
      response = @client.call(:decrypt, soap_options({'CryptedString' => string}))
      response_content = response.body[:decrypt_response][:decrypt_result][:gest_pay_crypt_decrypt]
      response_content[:custom_info] = response_content[:custom_info].split('*P1*').inject({}) { |mem, var| k,v=var.split('='); mem[k]=[v].pack('H*') ; mem } if response_content[:custom_info]
      Result::Decrypt.new(response_content)
    end

  end
end
