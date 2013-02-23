#!/usr/bin/env ruby

require 'dnsruby'
include Dnsruby
require 'logger'

log = Logger.new('log.txt')
log.level = Logger::DEBUG

our_servers = %w( nsmaster.windermere.com ns1.windermere.com ns2.windermere.com ns3.windermere.com )
our_ips = %w( 50.18.188.104 184.72.38.12 )

dns = DNS.new
file = File.new("test_domains.txt", "r")
output = File.open('not_managed.txt', 'w')

while (line = file.gets)
	domain = line.split("\t").first
	log.info 'Checking domain: ' + domain
	begin
		r_records = dns.getresources(domain, Types.ANY)
		a_records = nil
		ns_records = Array.new		
		r_records.each do |rr|
			if rr.is_a? Dnsruby::RR::IN::A
				a_records.push rr.address.to_s
			elsif rr.is_a? Dnsruby::RR::IN::NS
				ns_records.push rr.nsdname.to_s
			end
		end
	# See if we were able to get the records we need to check the domain.
	if ns_records.length == 0
		# It seems to help sometimes to try checking only
		# the nameservers if nothing came about the 1st time.
		n = dns.getresources(domain, Types.NS)
		if n.length > 0
			ns_records = n.map{|r| r.nsdname.to_s}
		else
			log.warn 'No nameservers found for ' + domain
			next
		end 
	elsif a_records == nil
		# Trying again here seems to always be futile.
		log.warn 'No A record found for ' + domain
		next
	else
		# if it doesn't have our namservers but does have one of our
		# ip addresses then we found one that we want to record.
		log.debug domain + ', our servers? ' + (not (our_servers & ns_records).any?)
		log.debug domain + ', our ips? ' + ( (our_ips & a_records).any? )
		if not (our_servers & ns_records).any? and (our_ips & a_records).any?
			log.info domain + ' not managed by us.'
			output.write(line)
		end
	end
	rescue Dnsruby::NXDomain
		log.warn 'No records for ' + domain
		next		
	rescue => error
		log.error domain + ', Rescued error class: ' + error.class.name + ', error message: ' + error.message
		next
	end
end

