require "nombus/version"
require "dnsruby"
require "whois"
require "wre_dns"

module Nombus
  
  class Configurator
    
    DefaultSeparator = ','
    # Using Google's public namerservers by default for DNS lookups.
    # There are several domains that were configured on nsmaster
    # that actually are not pointing at our nameserver anymore.
    # Using the defaults was masking this problem when running
    # the script on our network.
    DefaultNameservers = '8.8.8.8 8.8.4.4'
    Column = '1'
    FailHeaders = ["Domain", "Error"]
    SuccessColor = :green
    DebugColor = :magenta
    WarnColor = :yellow
    ErrorColor = :red
    
    def check_column(column)
      case column
      when /\D/
        "Error: #{column} is not a valid number"
      when '0'
        "Error: column number must be greater than 0"
      end
    end
    
    def get_column(column)
      # Internally csv starts at 0, but command option starts at 1, & is string
      column.to_i - 1
    end
    
    def check_separator(separator)
      case separator
      when /\s/
        "Error: Separator can't be a literal whitspace character. Use 'tab' for tabs"
      end
    end
    
    def get_separator(separator)
      case separator
      when 'tab' # Can't use literal tab on command line
        return "\t"
      else
        separator
      end
    end
    
  end
  
  class LookerUpper < Dnsruby::DNS
    include Dnsruby
    include WreDns

    def get_records(rr)
      nameserver = rr.find {|r| r.type == 'SOA'}.mname
      a_record = rr.find {|r| r.type == 'A'}.address
      return nameserver, a_record
    end

    def not_managed_by_us?(ns, ip)
      # Return true if it's not our nameserver,
      # but does use one of the old a.com IPs.
    	(NameServer::Master != ns) && (AgentWebsites::Old_acom_ips.include? ip)
    end

    def not_pointed_at_us?(their_ip)
      not AgentWebsites::All_acom_ips.include? their_ip
    end

    def lookup_error_message(domain, error)
      # See if domain is even registered 1st
      if Whois.whois(domain.to_s).available?
        return "#{domain}: Not a registered domain name"
      end
      # Try to explain other errors as best as possible
      case error
      when NXDomain
        return "No records found for #{domain}"
      when ServFail
        return "Lookup failed for #{domain}"
      when ResolvError
        return "DNS result has no information for #{domain}"
      end
    end

  end

end
