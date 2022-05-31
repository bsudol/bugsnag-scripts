# Very basic illustration of how to assign a JIRA ticket based on corresponding issue assignment in Bugsnag
# Required: the auth token must be associated with an Organization Administrator on the account

require 'httparty'
require 'json'
require 'date'

@auth_token = "" #Your API Token here
@organization_id = "" #Set to organization ID ("GET https://api.bugsnag.com/user/organizations?admin=&per_page=10")
@project_id = "" #Set to project ID (https://bugsnagapiv2.docs.apiary.io/#reference/projects/projects/list-an-organization's-projects)
@error_id = "" #Error we are looking to sync asignee with JIRA

#######################
#Get error's linked JIRA ticket(s)
get_error_url = "https://api.bugsnag.com/projects/#{@project_id}/errors/#{@error_id}"

error_response = HTTParty.get(get_error_url,
:headers => { 'Authorization' => "token #{@auth_token}",'Content-Type' => 'application/json' }
)

if error_response["linked_issues"][0]

	#Get asignee in Bugsnag, poll Bugsnag API to get collaborator's email
	bugsnag_collaborator = error_response["assigned_collaborator_id"]
	get_collaborator_url = "https://api.bugsnag.com/organizations/#{@organization_id}/collaborators/#{bugsnag_collaborator}"

	collaborator_response = HTTParty.get(get_collaborator_url,
	:headers => { 'Authorization' => "token #{@auth_token}",'Content-Type' => 'application/json',  }
	)

	collaborator_email = collaborator_response["email"]


	#Get corresponding JIRA account ID (implement function to search via email)
	account_id = get_jira_user(collaborator_email)

	#Assemble JIRA API URL for project/issue
	jira_assign_url = error_response["linked_issues"][0]["url"] + "/assignee"
	jira_assign_url["browse"] = "rest/api/3/issue"

	#Assign accordingly in JIRA
	#Note: auth must be set by user with appropriate JIRA information (user email + auth token), see:
	#https://developer.atlassian.com/cloud/jira/platform/rest/v3/api-group-issues/#api-rest-api-3-issue-issueidorkey-assignee-put
	collaborator_response = HTTParty.put(jira_assign_url,
		:headers => { 'Accept' => 'application/json','Content-Type' => 'application/json',  },
		:data => { 'accountId' => account_id,  }
		:auth => auth
	)

end