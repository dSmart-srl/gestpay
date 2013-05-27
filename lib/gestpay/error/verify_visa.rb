module Gestpay
  module Error
    class VerifyVisa < StandardError

      attr_accessor :result, :crypted_response

      def initialize(info)
        @transaction_key = info[:transaction_key]
        @result = info[:vb_v][:vb_v_buyer]
        @crypted_response = info[:vb_v][:vb_v_risp]
      end

    end
  end
end