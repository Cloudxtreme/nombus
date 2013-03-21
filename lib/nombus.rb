require "nombus/version"
require "dnsruby"
require "whois"
require "wre_dns"
require "pry"
require "pry-debugger"
require "yaml"

CONFIG = YAML::load(File.open('../nombus.rc.yml'))

module Nombus
  class Configurator
    
    def initialize(config)
      @fail_headers = ["domain", "error"]
      @separator = config['separator']
      @nameservers = config['nameservers']
      @column = config['column']
      @success_color = config['success_color'].to_sym
      @debug_color = config['debug_color'].to_sym
      @warn_color = config['warn_color'].to_sym
      @error_color = config['error_color'].to_sym
    end
    
    attr_accessor :fail_headers, :separator, :success_color, :debug_color, :warn_color, :error_color
    attr_writer :column
    
    def check_column(column)
      case column
      when /\D/
        "Error: #{column} is not a valid number"
      when '0'
        "Error: column number must be greater than 0"
      end
    end
    
    def column
      # Internally csv starts at 0, but command option starts at 1, & is string
      @column.to_i - 1
    end
    
    def check_separator(separator)
      if separator =~ /\s/
        "Error: Separator can't be a literal whitspace character. Use 'tab' for tabs"
      end
    end
    
    def get_separator(separator)
      # Can't use literal tab on command line
      separator == 'tab' ? "\t" : separator
    end
  end
  
  class LookerUpper < Dnsruby::DNS
    include Dnsruby
    include WreDns

    def get_records(rr)
      ns = rr.find {|r| r.type == 'SOA'}.mname.to_s
      a = rr.find {|r| r.type == 'A'}.address.to_s
      return ns, a
    end

    def not_managed_by_us?(ns, ip)
      # Return true if it's not our nameserver,
      # but does use one of the old a.com IPs.
    	(NameServer::Master != ns) && (AgentWebsites::Old_acom_ips.include? ip)
    end

    def not_pointed_at_us?(ip)
      not AgentWebsites::All_acom_ips.include? ip
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
