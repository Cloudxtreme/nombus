#!/usr/bin/env ruby

require_relative '../../database/toorad.rb'
include TooRad

# for testing usernames
names = %w( CHERIENGLISH ALEXMUNOZ JOHNREIS )


file = File.new("tcma_subscribers.csv", "r")
output = File.open('cma_users.csv', 'w')
while (line = file.gets)
	domain = line.split("\t").first



# get an array of usernames, returns relation
b = User.where("username in (?)", names)

a = User.where(:username => username.upcase).first

b = User.where("username = ?)", names)
b = User.where("username = ?", names).to_sql