require 'csv'

Given /^a csv file containing domain names at "(.*?)"$/ do |file|
  File.exists?(file).should be_true
end

Then /^it should create a new csv file in the current working directory called "(.*?)"$/ do |file|
  File.exists?(file).should be_true
end

Then /^"(.*?)" should have headers on the first row$/ do |file|
  CSV.open(file).readline.should == ["Domain", "Username", "Full Name", "Email"]
end

Then /^"(.*?)" should have one record in addition to the header row$/ do |file|
  # Header row + 1 record = 2 records in array
  CSV.readlines(file).length.should == 2
end

