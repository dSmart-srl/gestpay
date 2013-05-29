module Gestpay
  module Result
    class Payment < Gestpay::Result::Base
      def amount
        BigDecimal(data[:amount])
      end

      def verify_by_visa?
        error_code == '8006'
      end

      def visa_encrypted_string
        verify_by_visa_data = data[:vb_v]
        verify_by_visa_data[:vb_v_risp] if verify_by_visa? && verify_by_visa_data[:vb_v_buyer] == 'OK'
      end
    end
  end
end
