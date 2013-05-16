# require (File.expand_path('./../../spec_helper', __FILE__))
# For Ruby > 1.9.3, use this instead of require
require_relative '../../spec_helper'

describe Dhl::Digest do

  let(:digest) { Gestpay::Digest.new }

  # after do
  #   VCR.eject_cassette
  # end

  describe '#encrypt' do
    # before do
    #   VCR.insert_cassette 'shipment', record: :new_episodes
    # end

    it "should return an encrypted string" do

    end
  end

  describe '#decrypt' do

    # before { VCR.insert_cassette 'tracking/5223281416', record: :new_episodes}

    it 'should return a decrypted status string' do
      response.shipment_info.should_not be_nil
    end
  end

end
