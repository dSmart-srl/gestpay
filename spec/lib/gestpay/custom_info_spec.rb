require (File.expand_path('../../../spec_helper', __FILE__))
# For Ruby > 1.9.3, use this instead of require
# require_relative '../../spec_helper'

describe Gestpay::CustomInfo do
  
  before do 
    @object = Object.new
    @object.extend Gestpay::CustomInfo
  end  

  describe "#gestpay_encode" do 
    custom_hash= {'par1'=>'http://path.to/stuff', 'par2'=> 123}
    encoded_string= "par1=687474703a2f2f706174682e746f2f7374756666*P1*par2=313233"
    it "encodes custom info values in base(16) notation" do 
      @object.gestpay_encode(custom_hash).should eq encoded_string
    end
  end

  describe "#gestpay_decode" do 
    custom_hash= {'par1'=>'http://path.to/stuff', 'par2'=> 123.to_s} #numbers will be returned as strings anyway
    encoded_string= "par1=687474703a2f2f706174682e746f2f7374756666*P1*par2=313233"
    it "decodes custom info values in base(16) notation" do 
      @object.gestpay_decode(encoded_string).should eq custom_hash
    end
  end

end