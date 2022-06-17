# Busgnag Scripts
Various scripts to interact with Bugsnag API and Callback functions
Serving as an example for several implentation/configuration/workflow options

Requirements: Bugsnag SDK installed and configured with API key to active account; API key associated with an Organization Administrator on the account

## Frameworks:
- Ruby
- iOS (Swift)
- Android (Java, Kotlin)

## Table of Contents:
1. Scripts to interact with Data Access API: https://bugsnagapiv2.docs.apiary.io/#
* _auto_snooze_small_errors:_ Snooze all errors with fewer than x events via API - for larger organizations looking to remove high volumes of small errors
* _set_user_roles:_ Set all non-admin collaborators to the project_member role - for organizations transitioning to Enterprise looking to use new role
* _sync_assignments_with_JIRA:_ For an issue linked to a JIRA ticket - set asignee of JIRA ticket to match asignee of Bugsnag issue.

2. Callback functions to implement in iOS and/or Android Apps:
* _network_breadcrumbs_to_metadata:_ Set last request information such as response status, duration and service as metadata so it can be searched on in dashboard.
* _oom_update_context_via_breadcrumbs:_ For OOM exceptions, leverage information collected during runtime to add and track what view the OOM occurred in.
* _pop_top_stack:_ Remove top line of stackframe before sending exception to Bugsnag, such that any error handler or other irrelevant classes are removed.
* _add_device_tier_metadata_via_mapping:_ Add metadata flagging device tier, based on an internal. maintained mapping of device model to low/medium/high classification. Includes a sample mapping and sample class that reads the mapping in and passes the appropriate tier to the callback function.
* _get_module_set_team:_ Checks top stack method to pull module that error occurred in, then implements some logic to add metadata with responsible team name for each module, so that searching/filtering based on team name is easier in dashboard.
* _parse_request_params_metadata:_ Separate out request params metadata (hash) collected by default in Rails projects into individual key value pairs in metadata strucutre so that each individual param (e.g. uuid, action, etc) can be individually indexed and searched on in the dashboard.
* _redux_state_as_metadata:_ Adds redux state information to a new tab of metadata in an on error callback function for JS projects
