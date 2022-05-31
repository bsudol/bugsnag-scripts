# Busgnag Scripts
Various scripts to interact with Bugsnag API and Callback functions
Serving as an example for several implentation/configuration/workflow options

Requirements: Bugsnag SDK installed and configured with API key to active account; API key associated with an Organization Administrator on the account

## Languages:
- Ruby
- Swift

## Table of Contents:
1. Scripts to interact with Data Access API: https://bugsnagapiv2.docs.apiary.io/#
* _auto_snooze_small_errors:_ Snooze all errors with fewer than x events via API - for larger organizations looking to remove high volumes of small errors
* _set_user_roles:_ Set all non-admin collaborators to the project_member role - for organizations transitioning to Enterprise looking to use new role
* _sync_assignments_with_JIRA:_ For an issue linked to a JIRA ticket - set asignee of JIRA ticket to match asignee of Bugsnag issue.

2. Callback functions to implement in iOS and/or Android Apps:
* _network_breadcrumbs_to_metadata:_ Set last request information such as response status, duration and service as metadata so it can be searched on in dashboard.
* _oom_update_context_via_breadcrumbs:_ For OOM exceptions, leverage information collected during runtime to add and track what view the OOM occurred in.
* _pop_top_stack:_ Remove top line of stackframe before sending exception to Bugsnag, such that any error handler or other irrelevant classes are removed.
