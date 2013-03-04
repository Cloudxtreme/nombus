require "nombus/version"
require 'whois'

module Nombus
  include Methadone::CLILogging
  include Methadone::ExitNow
  
  DefaultSeparator = ','
  # Using Google's public namerservers by default for DNS lookups.
  # There are several domains that were configured on nsmaster
  # that actually are not pointing at our nameserver anymore.
  # Using the defaults was masking this problem when running
  # the script on our network.
  DefaultNameservers = '8.8.8.8 8.8.4.4'
  Column = '1'
  FailHeaders = ["Domain", "Error", "Error Class"]
  DebugColor = :magenta
  WarnColor = :yellow
  ErrorColor = :red
  def Nombus.NotManagedByUs?(our_ns, their_ns, our_ips, their_ip)
    # Return true if it's not our nameserver,
    # but does use one of the old a.com IPs.
  	(our_ns != their_ns) and (our_ips.include? their_ip)
  end
  def Nombus.LookupErrorMessage(domain, error)
    # Lookup with whois first to see if domain is even registered
    record = Whois.whois(domain.to_s)
    if record.available?
      return "The #{domain} is not a registered domain name"
    end
    # Try to explain other errors as best as possible
    case error
    when Dnsruby::NXDomain
      return "No records found for #{domain}"
    when Dnsruby::ServFail
      return "Lookup failed for #{domain}"
    when Dnsruby::ResolvError
      return "DNS result has no information for #{domain}"
    end
  end
  def Nombus.GetColumnIndex(column)
    # Handles error checking of column number passed on comamnd line
    # Returns index as proper type and value for indexing csv array
    if column =~ /[0-9]/
      index = column.to_i
    else
      exit_now! "Error: #{column} is not a number"
    end
    if index < 1
      exit_now! "Error: column number must be greater than 0"
    end
    # Internally csv starts at 0, but want command option to start at 1, so convert it
    index - 1
  end
  def Nombus.GetSeparator(separator)
    case separator
    when /[\s\t\r\n\f]/
      exit_now! "Error: Separator can't be a whitspace character. Use 'tab' for tabs"
    # Can't use \t on command line
    when 'tab'
      return "\t"
    else
      return separator
    end
  end
end
