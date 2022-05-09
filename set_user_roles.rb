# Example of setting user roles for groups of users
# Based on: https://bugsnagapiv2.docs.apiary.io/#reference/organizations/collaborators/update-a-collaborator's-permissions
# Required: the auth token must be associated with an Organization Administrator on the account
# Only applicable to Enterprise Accounts with project member role: https://docs.bugsnag.com/product/roles-and-permissions/#collaborator-roles

require 'httparty'
require 'json'

@auth_token = "" 

@get_organizations_url= "https://api.bugsnag.com/user/organizations?admin=&per_page=10"

org_response = HTTParty.get(@get_organizations_url,
:headers => { 'Authorization' => "token #{@auth_token}",'Content-Type' => 'application/json',  }
)

organization_id = org_response[0]['id']

@list_users_url = "https://api.bugsnag.com/organizations/#{organization_id}/collaborators?per_page=10"

collabs_request = HTTParty.get(@list_users_url,
    :headers => { 'Authorization' => "token #{@auth_token}",'Content-Type' => 'application/json',  }
)

collabs_request.each do |user|
    if !user['is_admin']
        user['project_ids'].each do |proj|
            user['project_roles'][proj] = 'project_member'
        end

        user_id = user['id']
        change_user_role_url = "https://api.bugsnag.com/organizations/#{organization_id}/collaborators/#{user_id}"

        response = HTTParty.patch(change_user_role_url,
            :body => { :project_roles => user['project_roles'],
                       :admin => false
                     }.to_json,
            :headers => { 'Authorization' => "token #{@auth_token}",'Content-Type' => 'application/json' } )
        puts response['name'], response['project_roles']
    end

    puts 'sleeping'
    sleep(1)
end