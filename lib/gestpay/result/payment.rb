module Gestpay
  module Result
    class Payment < Gestpay::Result::Base
      def amount
        BigDecimal(data[:amount])
      end

      def verify_by_visa?
        data[:error_code] == '8006'
      end
    end
  end
end
