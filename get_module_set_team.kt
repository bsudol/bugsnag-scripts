// Check top line of stackframe method to see which module error originated from
// Set metadata to flag responsible team based on module, for easier module based searching and alerting in dashboard
// Can be modified for any and all error classes

config.addOnError(OnErrorCallback { event ->

    var method = event.errors[0].stacktrace[0].method
    if ("com.example.foo.module" in method!!) {
        event.addMetadata("team", "name", "foo_team")
    }
    else if ("com.example.bar.module" in method!!) {
        event.addMetadata("team", "name", "bar_team")
    }

    // Return `false` if you'd like to stop this error being reported
    true
})