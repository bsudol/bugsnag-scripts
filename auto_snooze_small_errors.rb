# Example of snoozing all errors with fewer than x events
# Required: the auth token must be associated with an Organization Administrator on the account

require 'httparty'
require 'json'

@auth_token = "YOUR_API_KEY"
@minimum_events = 8 #Snooze all errors with event count less than this number
@project_id = '61fa9fef78e179000f56854c'

# @get_organizations_url= "https://api.bugsnag.com/user/organizations?admin=&per_page=10"

# org_response = HTTParty.get(@get_organizations_url,
# :headers => { 'Authorization' => "token #{@auth_token}",'Content-Type' => 'application/json',  }
# )

# organization_id = org_response[0]['id']

# @get_projs_url = "https://api.bugsnag.com/organizations/#{organization_id}/projects?sort=created_at&direction=desc&per_page=30"
# projects_response = HTTParty.get(@get_projs_url,
# :headers => { 'Authorization' => "token #{@auth_token}",'Content-Type' => 'application/json',  }
# )
# puts projects_response


#TODO: Define a timestamp for x days ago (frequency of script running)
@get_errors_url = "https://api.bugsnag.com/projects/#{@project_id}/errors?sort=last_seen&direction=desc&per_page=50&filters[error.status][][type]=eq&filters[error.status][][value]=open&filters[event.since][][type]=eq&filters[event.since][][value]=2022-05-20T00:00:00Z"

errors_response = HTTParty.get(@get_errors_url,
:headers => { 'Authorization' => "token #{@auth_token}",'Content-Type' => 'application/json' }
)

errors_to_update = Array.new

errors_response.each do |error|
	if error['events'] <= @minimum_events
		errors_to_update << error['id']
	end	
end

@update_errors_url = "https://api.bugsnag.com/projects/#{@project_id}/errors"

bulk_snooze_response = HTTParty.patch(@update_errors_url,
:headers => { 'Authorization' => "token #{@auth_token}",'Content-Type' => 'application/json' },
:query => {'error_ids' => errors_to_update},
:body => { :operation => "snooze",
		   :reopen_rules => {
		   		reopen_if: "n_additional_occurrences",
		   		additional_occurrences: @minimum_events
		   	}
		  }.to_json )

puts bulk_snooze_response