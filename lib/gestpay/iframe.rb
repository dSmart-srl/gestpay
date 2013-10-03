module Gestpay
  class Iframe

    FALLBACK_URL = {
      :test       => 'https://testecomm.sella.it/pagam/pagam.aspx',
      :production => 'https://ecomm.sella.it/pagam/pagam.aspx'      
    }

    def self.fallback_url
      FALLBACK_URL[Gestpay.config.environment]
    end

  end
end
