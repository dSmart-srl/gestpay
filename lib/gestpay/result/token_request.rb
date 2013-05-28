module Gestpay
  module Result
    class TokenRequest < Gestpay::Result::Base
      def error
        "Error #{data[:transaction_error_code]}: #{data[:transaction_error_description]}"
      end
    end
  end
end
