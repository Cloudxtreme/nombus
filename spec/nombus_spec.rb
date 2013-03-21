require 'spec_helper'

module Nombus
  describe LookerUpper do
      let(:dns) { LookerUpper.new :nameserver => ["8.8.8.8", "8.8.4.4"] }
      let(:regstered_domain) {'dokken.com'}
      let(:our_nameserver) {'nsmaster.windermere.com'}
      let(:not_our_nameserver) {'ns1dhl.name.com'}
      let(:not_our_ip) {'208.91.197.27'}
      let(:our_old_ip) {'184.72.38.12'}
      let(:our_new_ip) {'205.234.73.173'}
  
    describe "#get_records" do
      before do
        @records = dns.getresources('adamwgriffin.com', 'any')
        @nameserver, @a_record = dns.get_records(@records)
      end
    
      it "returns an A record" do
        @a_record.should =~ Dnsruby::IPv4::Regex
      end
    
      it "returns a nameserver" do
        PublicSuffix.valid?(@nameserver).should be_true
      end
    end

    describe "#not_managed_by_us?" do
      it "returns true if the domain is not managed by us, but points at our cuurent IP" do
        dns.not_managed_by_us?(not_our_nameserver, our_old_ip).should be_true
      end
      
      it "returns false if the domain does use our nameserver or doesn't use one of our old IPs" do
         dns.not_managed_by_us?(our_nameserver, our_new_ip).should be_false
      end
    end

    describe "#not_pointed_at_us?" do  
      it "returns true if the domain is not pointed at us" do
        dns.not_pointed_at_us?(not_our_ip).should be_true
      end
    
      it "returns false if the domain is pointed at us" do
        dns.not_pointed_at_us?(our_old_ip).should be_false
      end
    end
    
    describe "#lookup_error_message" do
      it "returns an error if domain isn't registered" do
        dns.lookup_error_message('abedftc.com', nil).should include('Not a registered domain name')
      end
      
      context "returns an error message if a lookup error was raised" do
        it "returns an error message when NXDomain is raised" do
         dns.lookup_error_message(regstered_domain, Dnsruby::NXDomain).should include('No records found')
        end
        
        it "returns an error message when ServFail is raised" do
         dns.lookup_error_message(regstered_domain, Dnsruby::ServFail).should include('Lookup failed')
        end
        
        it "returns an error message when ResolvError is raised" do
         dns.lookup_error_message(regstered_domain, Dnsruby::ResolvError).should include('DNS result has no information')
        end
      end
    end
  end
end
