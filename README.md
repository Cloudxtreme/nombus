# Nombus

Nombus is a command line tool wrtieen in Ruby, using the Methadone framework. I wrote some test cases for it in Rspec. The primary goal of nombus was to identify custom domain names for our Agent Website product that were not managed on our DNS servers, and isolate those that were using an old IP address that we wanted to turn down. It was also useful for cleaning up domain names that were entered in our database but were no longer pointed at a valid agent website.

## Installation

You can try the tool without installing it on your path with bundler:
		$ cd nombus/
    $ bundle install
		$ bundle exec nombus test_domans.csv

You can install it on your path as a gem using:

    $ gem install nombus

## Usage

Usage: nombus [options] csv_file

Options:
    -h, --help                       Show command line help
    -v, --version                    Print the version number & quit
    -s, --separator CHARACTER        Column separator for CSV file. Use '\t' for tabs & single-quotes to escape special characters
                                     (default: ,)
    -c, --column NUMBER              The column where the domain name is stored in the csv file, starting at 1
                                     (default: 1)
    -n, --nameservers 'SRVR1 SRVR2'  A quoted list of nameservers to use for lookup queries
                                     (default: 8.8.8.8 8.8.4.4)
        --no-headers                 Specify that the CSV file has no headers, default assumes headers exist
    -o, --output PATH/FILE.CSV       Specify path for CSV where records for domains that are not managed by us will be stored
    -f, --fail PATH/FILE.CSV         Specify path for CSV where records for domains that failed dns lookup will be stored
        --log-level LEVEL            Set the logging level
                                     (debug|info|warn|error|fatal)
                                     (Default: info)

