module Gestpay
  class Iframe

    FALLBACK_URL = {
      :test       => 'https://testecomm.sella.it/pagam/pagam.aspx',
      :production => 'https://ecomm.sella.it/pagam/pagam.aspx'
    }

    PAYMENT_3D_URL = {
      :test       => 'https://testecomm.sella.it/pagam/pagam3d.aspx',
      :production => 'https://ecomm.sella.it/pagam/pagam3d.aspx'
    }

    def self.fallback_url
      FALLBACK_URL[Gestpay.config.environment]
    end

    def self.payment_3d_url
      PAYMENT_3D_URL[Gestpay.config.environment]
    end

  end
end

