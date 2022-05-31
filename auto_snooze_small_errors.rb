# Example of snoozing all errors with fewer than x events
# Required: the auth token must be associated with an Organization Administrator on the account

require 'httparty'
require 'json'
require 'date'

@auth_token = "" #Your API Token here
@minimum_events = 8 #Snooze all errors with event count less than this number
@number_of_days = 7 #Pull and modify errors occuring in the last [number_of_days] days (coincides with frequency of script)
@project_name = 'example-project' #Set to your project name

#######################
@get_organizations_url= "https://api.bugsnag.com/user/organizations?admin=&per_page=10"

org_response = HTTParty.get(@get_organizations_url,
:headers => { 'Authorization' => "token #{@auth_token}",'Content-Type' => 'application/json',  }
)

organization_id = org_response[0]['id']

@get_projs_url = "https://api.bugsnag.com/organizations/#{organization_id}/projects?sort=created_at&direction=desc&per_page=30"
projects_response = HTTParty.get(@get_projs_url,
:headers => { 'Authorization' => "token #{@auth_token}",'Content-Type' => 'application/json',  }
)

projects_response.each do |project|
	if project['name'] == @project_name
		@project_id = project['id']
		break
	end
end

if @project_id

	earliest_date = (DateTime.now - @number_of_days).strftime('%Y-%m-%dT%H:%M:%SZ')

	@get_errors_url = "https://api.bugsnag.com/projects/#{@project_id}/errors?sort=last_seen&direction=desc&per_page=50&filters[error.status][][type]=eq&filters[error.status][][value]=open&filters[event.since][][type]=eq&filters[event.since][][value]=#{earliest_date}"

	errors_response = HTTParty.get(@get_errors_url,
	:headers => { 'Authorization' => "token #{@auth_token}",'Content-Type' => 'application/json' }
	)

	errors_to_update = Array.new

	errors_response.each do |error|
		if error['events'] <= @minimum_events
			errors_to_update << error['id']
		end	
	end

	if errors_to_update.length() > 0

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
	end

else
	puts "No project found with name #{@project_name}"
end