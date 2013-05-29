module Gestpay
  module Result
    class Decrypt < Gestpay::Result::Base
      def buyer_name
        buyer[:buyer_name]
      end
      def buyer_email
        buyer[:buyer_email]
      end
    end
  end
end
