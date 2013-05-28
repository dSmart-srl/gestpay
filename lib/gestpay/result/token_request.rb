module Gestpay
  module Result
    class TokenRequest < Gestpay::Result::Base
      def error
        "Error #{ transaction_error_code }: #{ transaction_error_description }" if transaction_error_code
      end
    end
  end
end
