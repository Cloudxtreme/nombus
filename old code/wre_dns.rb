
module WreDns 
  # Classes & constants specific to Windermere's DNS
  
  class NameServer
      Master = 'nsmaster.windermere.com'
      Slave1 = 'ns1.windermere.com'
      Slave2 = 'ns2.windermere.com'
      Slave3 = 'ns3.windermere.com'
  end
  
  class AgentWebsites
    Acom_ip = '205.234.73.173'
    Old_acom_ips = ['50.18.188.104', '184.72.38.12']
    Paws_ip = '205.234.73.177'
    All_acom_ips = Old_acom_ips << Acom_ip << Paws_ip
  end

end