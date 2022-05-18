// Loop through breadcrumbs & use information to update Out of Memory error's context
// Can be modified for any error class

config.addOnSendError { (event) -> Bool in
    if (event.errors[0].errorClass == "Out Of Memory") {
            for breadcrumb in event.breadcrumbs.reversed() {
                if (breadcrumb.type == .navigation) {
                    event.context = breadcrumb.message as? String

                    // optional: change default grouping
                    event.groupingHash = event.context;
                    break
                }
            }
        }
    
    return true
}

Bugsnag.start(with: config)