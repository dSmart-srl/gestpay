require (File.expand_path('./../../spec_helper', __FILE__))
# For Ruby > 1.9.3, use this instead of require
# require_relative '../../spec_helper'

describe Gestpay::Digest do

  let(:digest) { Gestpay::Digest.new }

  after do
    VCR.eject_cassette
  end

  describe '#encrypt' do
    context "with an ok data hash" do
      before { VCR.insert_cassette 'encrypt_ok', :record => :new_episodes }
      it "should return an encrypted string" do
        hash = {
          :uic_code => '242',
          :amount => '0.01',
          :shop_transaction_id => '123',
          :language_id => '1',
          :buyer_name => "Test Customer",
          :buyer_email => "test@example.com"
        }
        result = digest.encrypt(hash)
        result.should == 'i3eUhxjb5HNxldtVSXb4qxaYva_uWKNn6BSQgRXkBUWKjoQvU6IbNgocbJYSr2LZ3FdnsvnpXH8KQ1*lizVn5LmWYMmN7JA0wMpuURkqftlBYPdjzXMmOomRrUenCF1JzE0j1ugNdSIbY7rrrUVxYAtjdvkKmyKrtLOiDuTohJsWaWGuIH4y_KUUa5cWcY3Oqz8eSjVfiWr8RUeAYCVmeA'
      end
    end

    context "with a wrong data hash" do
      before { VCR.insert_cassette 'encrypt_ko', :record => :new_episodes }
      it "should raise an error" do
        hash = {}
        expect {
          digest.encrypt(hash)
        }.to raise_error(
          Gestpay::Error::FailedDigest,
          'Error 1008'
        )
      end
    end
  end

  describe '#decrypt' do
    context "with an ok transaction" do
      before { VCR.insert_cassette 'decrypt_ok', :record => :new_episodes }
      it "should return an ok envelope" do
        result = digest.decrypt('rxd4jKk3CN8PbPX7gHh9u60ocD8_R85bI0NR_C*SOk1r1y2P8E9fDBgXKmmMnyyhyosyF8X6rvyTs_GCulPAy8TZKJc99tSb57cAWuo36MZ9_OWp2pwgKYLx7jS9XaLBgAqBufiFIoPq*Pwj5SdHY06vUf3ebnKryDvRnC0oldLw1YxpkIxlebYd7YxvNfSGLfSvce2NN8wWcwPfdR2jPKb*_oJpCEVZNO5TVMaH6h1UONEksNLIuDeZPqWfrHRcgbi0MLuoifb7ZBGrTw7HlEqfF6ojKt2oihKtNdn3Y3W5MkBHCsBrWq63TLYlDU8PRaV20jAdqQIJBHopVyumMGtyLoHlMFaH*nXUvgzwmYnTtwQZ*Q1nGCP0cl4YilBcivSTJCOkcrRwUhqYOl*4F1kmT15Nkp_sBB4oJRODYs8')
        result[:transaction_result].should == 'OK'
        result[:shop_transaction_id].should == '123'
        result[:buyer].should == {:buyer_name=>"Test Customer", :buyer_email=>"test@example.com"}
      end
    end

    context "with a failed transaction" do
      before { VCR.insert_cassette 'decrypt_ko', :record => :new_episodes }
      it "should return a ko envelope" do
        string = 'KFzOej9MGr*lXEe*LOB2wzLmHja3ghKAo3iMpR1pG35moFdejWKzAj1Zd*R_e0x8qyOSTQmZVGRXEzJMVzd9xRXS*7tkbQLPOuBZ7qAtoFsX2Fxks5HxY*3YsUeiOInUXNF7*ih1bzkwmYGchDqYnEi31rN8ZYwLHnjwMIEmWJNn7oJHE6RpfUHG*7qohDxZRto*VVTPFdM93CwECq7SdYLebAQ_9EefdcE90QCRcFdGxZp_yAr_t*YRgLcZ5B5j843krtjCvf_m8nS99CroJQ768XsvlXy29McM2G*369mTufGyGMRab5PIvJlpSd3ds6mGi1IoMJAyXVkCu_ygRDDXN5Fk4Hz58LrDIci4ZszyVRcqy56SeYV7eG*kG8LZV40WV2ey8Qeh8XDUZnCV3A'
        expect {
          digest.decrypt(string)
        }.to raise_error(
          Gestpay::Error::FailedDigest,
          'Error 74: Autorizzazione negata'
        )
      end
    end
  end

end
