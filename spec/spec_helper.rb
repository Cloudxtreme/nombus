require "methadone"
require "nombus"
require "dnsruby"
require "yaml"
require "pry"
require "pry-debugger"

config_file = 'nombus.rc.yaml'
# Find full path above spec directory, concat it with filename for path to file
CONFIG_PATH = File.join( File.expand_path('..', File.dirname(__FILE__)), 'config', config_file )
VALID_DOMAIN = /^[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,6}(:[0-9]{1,5})?(\/.*)?$/ix