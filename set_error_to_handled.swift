// Modify all Errors of type x (adjust below as needed) to Handled flag
// Errors with event.unhandled = false do not contribute to the application's stability score.

let config = BugsnagConfiguration.loadConfig()

// Toggle Error of type x to handled
config.addOnSendError { (event) -> Bool in

    if (event.errors[0].errorClass == "x") {
        event.unhandled = false;
    }

    // Return `false` if you'd like to stop this error being reported
    return true
}

Bugsnag.start(with: config)