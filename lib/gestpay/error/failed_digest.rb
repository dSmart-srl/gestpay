module Gestpay
  module Error
    class FailedDigest < StandardError

      attr_reader :code, :description

      def initialize(code, description)
        @code, @description = code, description
      end

      def message
        string = "Error #{code}"
        string << ": #{description}" if !description.blank?
        string
      end

    end
  end
end
