require 'dnsruby'
require 'spec_helper'

describe Nombus do
  
  before do
    @dns = Dnsruby::DNS.new :nameserver => ["8.8.8.8", "8.8.4.4"]
  end
  
  describe ".GetRecords" do
    before do
      @records = @dns.getresources('adamwgriffin.com', Dnsruby::Types.ANY)
      @nameserver, @a_record = Nombus.GetRecords(@records)
    end
    
    it "should return an A record" do
      @a_record.should be_an_instance_of Dnsruby::IPv4
    end
    
    it "should return a nameserver" do
      @nameserver.should be_an_instance_of Dnsruby::Name
    end
    
    context "looking up adamwgriffin.com" do
      
      it "has an A record with the IP address 184.72.38.12" do
        @a_record.to_s.should eql "184.72.38.12"
      end
      
      it "has the nameserver ns1dhl.name.com" do
        @nameserver.to_s.should eql "ns1dhl.name.com"
      end
      
    end
    
  end
  
  describe ".NotPointedAtUs?" do
    
    before do
      @pointed_a = Dnsruby::IPv4.create('184.72.38.12')
      @not_pointed_a = Dnsruby::IPv4.create('208.91.197.27')
      @pointed_result = Nombus.NotPointedAtUs?(WreDns::AllAcomIps, @pointed_a)
      @not_pointed_result = Nombus.NotPointedAtUs?(WreDns::AllAcomIps, @not_pointed_a)
    end
    
    it "should return true if the domain is not pointed at us" do
      @not_pointed_result.should eql true
    end
    
    it "should return false if the domain is pointed at us" do
      @pointed_result.should eql false
    end
  
  end
  
end
