require 'dnsruby'

module WreDns
  # Constants specific to Windermere's DNS
  NameServer = Dnsruby::Name.create('nsmaster.windermere.com.')
  Slave1 = Dnsruby::Name.create('ns1.windermere.com.')
  Slave2 = Dnsruby::Name.create('ns2.windermere.com.')
  Slave3 = Dnsruby::Name.create('ns3.windermere.com.')
  OldAcomIps = [ Dnsruby::IPv4.create('50.18.188.104'), Dnsruby::IPv4.create('184.72.38.12') ]
  AcomIp = Dnsruby::IPv4.create('205.234.73.173')
end