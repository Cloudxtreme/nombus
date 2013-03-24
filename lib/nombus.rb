require "nombus/version"
require "dnsruby"
require "whois"
require "wre_dns"
require "pry"
require "pry-debugger"


module Nombus
  ConfigFile = 'nombus.rc.yml'
  
  class Configurator 
    def initialize(config)
      @fail_headers = ["domain", "error"]
      @separator = config['separator']
      @lookup_servers = config['lookup_servers'].split
      @column = config['column'].to_s # column needs to be a string for setter to work right
      @success_color = config['success_color'].to_sym
      @debug_color = config['debug_color'].to_sym
      @warn_color = config['warn_color'].to_sym
      @error_color = config['error_color'].to_sym
      @our_nameserver = config['our_nameserver']
      @old_acom_ips = config['old_ips'].split
      @acom_ip = config['current_ip']
      @paws_ip = config['paws_ip']
      @all_acom_ips = [*@old_acom_ips, @acom_ip, @paws_ip]
    end
    
    attr_accessor :fail_headers, :lookup_servers,
    :success_color, :debug_color, :warn_color, :error_color
    
    attr_reader :column, :separator,
    :our_nameserver, :old_acom_ips, :acom_ip, :paws_ip, :all_acom_ips
    
    def column=(col)
      case col
      when /\D/
        raise "Error: #{col} is not a valid number"
      when '0'
        raise "Error: column number must be greater than 0"
      else
        @column = col
      end
    end
    
    def column_index
      # Internally csv starts at 0, but command option starts at 1, & is string
      @column.to_i - 1
    end
    
    def separator=(sep)
      case sep
      when /\s/
        raise "Error: Separator can't be a literal whitspace character. Use 'tab' for tabs"
      when 'tab' # Can't use literal tab on command line
        @separator = "\t"
      else
        @separator = sep
      end
    end
  end
  
  class LookerUpper < Dnsruby::DNS
    include Dnsruby
    
    def initialize(our_server, old_acom_ips, all_acom_ips, lookup_servers)
      @our_server = our_server
      @old_acom_ips = old_acom_ips
      @all_acom_ips = all_acom_ips
      super(:nameserver => lookup_servers)
    end
    
    def get_records(rr)
      ns = rr.find {|r| r.type == 'SOA'}.mname.to_s
      a = rr.find {|r| r.type == 'A'}.address.to_s
      return ns, a
    end

    def not_managed_by_us?(ns, ip)
      # Return true if it's not our nameserver,
      # but does use one of the old a.com IPs.
    	(@our_server != ns) && (@old_acom_ips.include? ip)
    end

    def not_pointed_at_us?(ip)
      not @all_acom_ips.include? ip
    end

    def lookup_error_message(domain, error)
      # See if domain is even registered 1st
      if Whois.whois(domain.to_s).available?
        return "#{domain}: Not a registered domain name"
      # Try to explain other errors as best as possible
      elsif error == NXDomain
        return "No records found for #{domain}"
      elsif error == ServFail
        return "Lookup failed for #{domain}"
      elsif error == ResolvError
        return "DNS result has no information for #{domain}"
      end
    end
  end
end
