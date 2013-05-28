module Gestpay
  module Result
    class Encrypt < Gestpay::Result::Base
      def encrypted_string
        crypt_decrypt_string
      end
    end
  end
end
