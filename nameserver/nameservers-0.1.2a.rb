#!/usr/bin/env ruby

require 'dnsruby'
require 'logger'
require 'csv'
require_relative '../wre_dns'

log = Logger.new('log.txt')
log.level = Logger::DEBUG
# Using Google's public namerservers for DNS lookups.
# There are several domains that were configured on nsmaster
# that actually are not pointing at our nameserver anymore.
# Using the defaults was masking this problem when running
# the script on our network.
dns = Dnsruby::DNS.new( {:nameserver=>["8.8.8.8", "8.8.4.4"]} )
file = CSV.open('test_domains-short.csv')
not_managed = CSV.open('not_managed.csv', "wb")
not_managed << file.readline #get headers from 1st line
file.each do |row|
	domain = Dnsruby::Name.create( row[0] )
	log.info 'Checking domain: ' + domain.to_s
	begin
		name_server = dns.getresource(domain, Dnsruby::Types.SOA).mname
		a_record = dns.getresource(domain, Dnsruby::Types.A).address		
		# if it doesn't have our namserver but does have one of our
		# old ip addresses then we found one that we want to record.
		log.debug domain.to_s + ', using our server? ' + (WreDns::NameServer == name_server).to_s
		log.debug domain.to_s + ', using one of our old ips? ' + (WreDns::OldAcomIps.include? a_record).to_s
		log.debug domain.to_s + ', not managed by us? ' + (WreDns.NotManagedByUs?(name_server, a_record)).to_s
		if WreDns.NotManagedByUs?(name_server, a_record)
			# Ignore if we've already set them up with the current IP.
			unless a_record == WreDns::AcomIp
				log.info domain.to_s + ': not managed by us.'
				not_managed << row
			end
		end
	rescue Dnsruby::NXDomain
		log.warn 'No records for ' + domain.to_s
		next		
	rescue => error
		log.error domain.to_s + ', Rescued error class: ' + error.class.name + ', error message: ' + error.message
		next
	end
end
