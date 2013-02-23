#!/usr/bin/env ruby

require 'dnsruby'
include Dnsruby
require 'logger'

log = Logger.new('log.txt')
log.level = Logger::DEBUG

our_server = Name.create('nsmaster.windermere.com.')
our_old_ips = [ IPv4.create('50.18.188.104'), IPv4.create('184.72.38.12') ]
our_new_ip = IPv4.create('205.234.73.173')

def not_managed_by_us?(our_ns, their_ns, our_ips, their_ip)
	not our_ns.eql? their_ns and our_ips.include? their_ip
end

# Using Google's public namerservers for DNS lookups.
# There are several domains that were configured on nsmaster
# that actually are not pointing at our nameserver anymore.
# Using the defaults was masking this problem when running
# the script on our network.
dns = DNS.new( {:nameserver=>["8.8.8.8", "8.8.4.4"]} )

file = File.new('test_domains-long.txt', "r")
output = File.open('not_managed.txt', 'w')

while (line = file.gets)
	domain = Name.create( line.split("\t").first )
	log.info 'Checking domain: ' + domain.to_s
	begin
		name_server = dns.getresource(domain, Types.SOA).mname
		a_record = dns.getresource(domain, Types.A).address		
		# if it doesn't have our namserver but does have one of our
		# old ip addresses then we found one that we want to record.
		log.debug domain.to_s + ', using our server? ' + (our_server.eql? name_server).to_s
		log.debug domain.to_s + ', using one of our old ips? ' + (our_old_ips.include? a_record).to_s
		log.debug domain.to_s + ', not managed by us? ' + (not_managed_by_us?(our_server, name_server, our_old_ips, a_record)).to_s
		if not_managed_by_us?(our_server, name_server, our_old_ips, a_record)
			# Ignore if I've already set them up with the new IP.
			unless a_record.eql? our_new_ip
				log.info domain.to_s + ': not managed by us.'
				output.write(line)
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
