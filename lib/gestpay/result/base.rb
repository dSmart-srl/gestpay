module Gestpay
  module Result
    class Base

      attr_reader :data

      def initialize(data)
        @data = data
      end

      def success?
        data[:transaction_result] == 'OK'
      end

      def error
        "Error #{data[:error_code]}: #{data[:error_description]}"
      end

      def method_missing(method_name, *args)
        data.has_key?(method_name) ? data[method_name] : super
      end

    end
  end
end
