module Gestpay
  class Iframe

    FALLBACK_URL = {
      :test       => 'https://testecomm.sella.it/pagam/pagam.aspx',
      :production => 'https://ecomm.sella.it/pagam/pagam.aspx'      
    }

    def config
      Gestpay.config
    end

    def fallback_url
      FALLBACK_URL[config.environment]
    end

  end
end

