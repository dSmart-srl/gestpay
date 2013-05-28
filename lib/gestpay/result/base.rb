module Gestpay
  module Result
    class Base

      attr_reader :data

      def initialize(data)
        @data = data
      end

      def success?
        transaction_result == 'OK'
      end

      def error
        "Error #{ error_code }: #{ error_description }" if error_code
      end

      def method_missing(method_name, *args)
        data.has_key?(method_name) ? data[method_name] : super
      end

    end
  end
end
