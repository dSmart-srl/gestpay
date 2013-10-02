require (File.expand_path('../../../spec_helper', __FILE__))
# For Ruby > 1.9.3, use this instead of require
# require_relative '../../spec_helper'

describe Gestpay::Gateway do

  let(:gateway) { Gestpay::Gateway.new }
  subject { result }

  after do
    VCR.eject_cassette
  end

  describe '#payment' do
    let(:result) { gateway.payment(hash) }

    context "with an ok data hash" do
      before { VCR.insert_cassette 'payment_ok', :record => :new_episodes }
      let(:hash) do
        {
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
      end

      it { should be_success }
      its(:amount) { should == 0.02 }
      its(:visa_encrypted_string) { should be_nil}
    end

    context "with a VISA credit card with Verification" do
      before { VCR.insert_cassette 'payment_visa', :record => :new_episodes }
      let(:hash) do
        { :card_number => '4556541926187165' }
      end

      it { should be_verify_by_visa }
      its(:visa_encrypted_string) { should include('mRTLDNghVNbEYcEsmpi5WTNwD5XIrf2NKbO8iVRXYd5we9*K*c8') }
    end

    context "with an invalid credit card" do
      before { VCR.insert_cassette 'payment_ko', :record => :new_episodes }
      let(:hash) do
        {
          :amount              => '0.02',
          :shop_transaction_id => '12',
          :card_number         => '5432123456789012'
        }
      end

      it { should_not be_success }
      its(:error) { should == 'Error 74: Autorizzazione negata' }
    end

    context "with a token" do
      before { VCR.insert_cassette 'payment_token', :record => :new_episodes }
      let(:hash) do
        {
          :amount              => '0.02',
          :shop_transaction_id => '12',
          :token_value         => '53QWERTYU0I90987'
        }
      end
      it { should be_success }
      its(:amount) { should == 0.02 }
    end

  end

  describe '#request_token' do
    let(:hash) do
      {
        :card_number  => '4556541926187165',
        :expiry_month => '12',
        :expiry_year  => '20',
        :cvv         => "123",
      }
    end

    context "with an ok data hash" do
      before { VCR.insert_cassette 'request_token_ok', :record => :new_episodes }
      let(:result) { gateway.request_token(hash, false) }

      its(:token) { should == "45OGBX64451Y7165" }
    end

    context "with an invalid credit card" do
      before { VCR.insert_cassette 'request_token_ko', :record => :new_episodes }
      let(:result) { gateway.request_token(hash) }

      its(:error) { should == "Error 405: Autorizzazione negata dai circuiti" }
    end
  end

  describe '#settle' do
    let(:hash) do
      {
        :bank_trans_id  => '2',
        :amount         => '20.00'
      }
    end

    context "with an ok data hash" do
      before { VCR.insert_cassette 'settle_ok', :record => :new_episodes }
      let(:result) { gateway.settle(hash) }

      it { should be_success }
    end

    context "with an invalid credit card" do
      before { VCR.insert_cassette 'settle_ko', :record => :new_episodes }
      let(:result) { gateway.settle(hash) }

      its(:error) { should == "Error 2016: Campi BANKTRANSACTIONID e SHOPTRANSACTIONID non valorizzati" }
    end
  end
end

