require "nombus/version"

module Nombus
  DefaultSeparator = ','
  # Using Google's public namerservers by default for DNS lookups.
  # There are several domains that were configured on nsmaster
  # that actually are not pointing at our nameserver anymore.
  # Using the defaults was masking this problem when running
  # the script on our network.
  DefaultNameservers = '8.8.8.8 8.8.4.4'
  OutputFileName = 'nombus_domains.csv'
  Column = '0'
  def Nombus.NotManagedByUs?(our_ns, their_ns, our_ips, their_ip)
    # Return true if it's not our nameserver,
    # but does use one of the old a.com IPs.
  	(our_ns != their_ns) and (our_ips.include? their_ip)
  end
end
