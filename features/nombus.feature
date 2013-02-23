Feature: Check if domain names are managed by Windermere DNS servers
  In order to identify which agent websites have vanity domains not managed by Windermere's nameservers
  I want to do a dns lookup on each custom domain
  So I can let the agents know if the IP address for a.com changes

  Scenario: Basic UI
    When I get help for "nombus"
    Then the exit status should be 0
    And the banner should be present
    And there should be a one line summary of what the app does
    And the banner should include the version
    And the banner should document that this app takes options
    And the following options should be documented:
      |--version|
    And the banner should document that this app's arguments are:
	      |csv_file|which is required|
	      |output_file|which is optional|
