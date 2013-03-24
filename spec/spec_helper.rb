require "methadone"
require "nombus"
require "dnsruby"
require "public_suffix"
require "yaml"
require "pry"
require "pry-debugger"

config_file = 'nombus.rc.yml'
# Find full path above spec directory, concat it with filename for path to file
CONFIG_PATH = File.join( File.expand_path('..', File.dirname(__FILE__)), config_file )