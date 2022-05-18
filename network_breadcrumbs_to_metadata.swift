// Loop through breadcrumbs & use information to update network request related metadata
// If most recent network breadcrumb is within the amount of seconds defined in network_threshold_seconds from the error, the details will be logged as metadata
// This allows you to create bookmarks tracking specific exceptions that have a recent network request with a specific status, or to a specific URL.
// Can be modified for any and all error classes

config.addOnSendError { (event) -> Bool in

    let network_threshold_seconds = 5.0
    
    if (event.errors[0].errorClass == "Out Of Memory" || event.errors[0].errorClass == "App Hang") {
            for breadcrumb in event.breadcrumbs.reversed() {
                if (breadcrumb.type == .request && breadcrumb.metadata["url"] as! String != "http://notify.bugsnag.com" && breadcrumb.metadata["url"] as! String != "http://sessions.bugsnag.com") {

                    let time_diff = (event.device.time?.timeIntervalSince((breadcrumb.timestamp ?? event.device.time)!) ?? 10) as Double               
                    if(time_diff <= network_threshold_seconds){                        
                        event.addMetadata(breadcrumb.metadata["status"], key:"last_status", section:"request")                   
                        event.addMetadata(breadcrumb.metadata["url"] as? String, key:"last_url", section:"request")
                        event.addMetadata(breadcrumb.metadata["duration"], key:"last_request_duration", section:"request")

                        break
                    }
                }
            }
        }
    
    return true
}

Bugsnag.start(with: config)