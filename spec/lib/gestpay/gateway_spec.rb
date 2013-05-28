require (File.expand_path('../../../spec_helper', __FILE__))
# For Ruby > 1.9.3, use this instead of require
# require_relative '../../spec_helper'

describe Gestpay::Gateway do

  let(:gateway) { Gestpay::Gateway.new }

  after do
    VCR.eject_cassette
  end

  describe '#payment' do
    context "with an ok data hash" do
      before { VCR.insert_cassette 'payment_ok', :record => :new_episodes }
      it "should return stuff" do
        hash = {
          :amount              => '0.02',
          :shop_transaction_id => '12',
          :card_number         => '5364000000000987',
          :expiry_month        => '01',
          :expiry_year         => '20',
          :cvv                 => "753",
          :buyer_name          => "Test Customer",
          :buyer_email         => "test@example.com",
          :custom_info => {
            :user_id    => 12,
            :payment_id => 15
          }
        }
        result = gateway.payment(hash)
        result.should be_success
        result.amount.should == 0.02
      end
    end

    context "with a VISA credit card with Verification" do
      before { VCR.insert_cassette 'payment_visa', :record => :new_episodes }
      it "should raise a VerifyVisa error" do
        hash = {
          :card_number => '4556541926187165'
        }
        result = gateway.payment(hash)
        result.should be_verify_by_visa
      end
    end

    context "with an invalid credit card" do
      before { VCR.insert_cassette 'payment_ko', :record => :new_episodes }
      it "should raise an error" do
        hash = {
          :amount              => '0.02',
          :shop_transaction_id => '12',
          :card_number         => '5432123456789012'
        }
        result = gateway.payment(hash)
        result.should_not be_success
        result.error.should == 'Error 74: Autorizzazione negata'
      end
    end

    context "with a token" do
      before { VCR.insert_cassette 'payment_token', :record => :new_episodes }
      it "should be ok" do
        hash = {
          :amount              => '0.02',
          :shop_transaction_id => '12',
          :token_value         => '53QWERTYU0I90987'
        }
        result = gateway.payment(hash)
        result.should be_success
        result.amount.should == 0.02
      end
    end

  end

  describe '#request_token' do
    context "with an ok data hash" do
      before { VCR.insert_cassette 'request_token_ok', :record => :new_episodes }
      it "should return a payment token" do
        hash = {
          :card_number  => '4556541926187165',
          :expiry_month => '12',
          :expiry_year  => '20',
          :cvv         => "123",
        }
        # This returned ok as we didn't verify the card with the false parameter
        result = gateway.request_token(hash, false)
        result.token.should == "45OGBX64451Y7165"
        # result[:info] also returned
      end
    end

    context "with an invalid credit card" do
      before { VCR.insert_cassette 'request_token_ko', :record => :new_episodes }
      it "should raise an error" do
        hash = {
          :card_number  => '4556541926187165',
          :expiry_month => '12',
          :expiry_year  => '20',
          :cvv         => "123",
        }
        result = gateway.request_token(hash)
        result.error.should == "Error 405: Autorizzazione negata dai circuiti"
      end
    end
  end

end
