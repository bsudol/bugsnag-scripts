# Busgnag Scripts
Various scripts to interact with Bugsnag API and Callback functions
Serving as an example for several implentation/configuration/workflow options

Requirements: Bugsnag SDK installed and configured with API key to active account; API key associated with an Organization Administrator on the account

## Languages:
- Ruby
- Swift

## Table of Contents:
1. Scripts to interact with Data Access API: https://bugsnagapiv2.docs.apiary.io/#
* auto_snooze_small_errors: Snooze all errors with fewer than x events via API - for larger organizations looking to remove high volumes of small errors
* set_user_roles: Set all non-admin collaborators to the project_member role - for organizations transitioning to Enterprise looking to use new role
* sync_assignments_with_JIRA: For an issue linked to a JIRA ticket - set asignee of JIRA ticket to match asignee of Bugsnag issue.

2. Callback functions to implement in iOS and/or Android Apps:
* network_breadcrumbs_to_metadata: Set last request information such as response status, duration and service as metadata so it can be searched on in dashboard.
* oom_update_context_via_breadcrumbs: For OOM exceptions, leverage information collected during runtime to add and track what view the OOM occurred in.
* pop_top_stack: Remove top line of stackframe before sending exception to Bugsnag, such that any error handler or other irrelevant classes are removed.
