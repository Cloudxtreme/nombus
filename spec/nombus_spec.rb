require 'dnsruby'
require 'spec_helper'

describe Nombus do
  
  describe ".GetRecords" do
    
    before do
      @dns = Dnsruby::DNS.new :nameserver => Nombus::DefaultNameservers.split
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
  
end
