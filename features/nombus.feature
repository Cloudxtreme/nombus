Feature: Check if domain names are managed by Windermere DNS servers
	In order to identify which agent websites have vanity domains not managed by Windermere's nameservers
 	I want to do a dns lookup on each custom domain
 	So I can let the agents know if the IP address for a.com changes

	Scenario: User Interface
		When I get help for "nombus"
		Then the exit status should be 0
		And the banner should be present
		And there should be a one line summary of what the app does
		And the banner should include the version
		And the banner should document that this app takes options
		And the following options should be documented:
			|--version|
			|-n|
			|--nameservers|
			|-s|
			|--separator|
			|-c|
			|--column|
			|--no-headers|
		And the banner should document that this app's arguments are:
			|csv_file|which is required|
			|output_file|which is optional|

	Scenario: Default Execution
		Given a csv file containing domain names at "test/test_domains-short.csv"
		When I successfully run `bundle exec nombus test/test_domains-short.csv`
		Then the output should contain "Checking domain"
		And it should create a new csv file in the current working directory called "nombus_domains.csv"
		And "nombus_domains.csv" should have headers on the first row
		And "nombus_domains.csv" should have one record in addition to the header row
