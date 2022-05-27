// Check top line of stackframe to ensure it represents where error occured, and not where error was sent
// Can be modified for any and all error classes

config.addOnSendError { (event) -> Bool in
    
    //Check for specific error type if necessary, otherwise remove this statement to check all errors
    if (event.errors[0].errorClass == "NSError") {
        
        //Check top line of stackframe for any mention of your global error handler class/ function
        if("\(event.errors[0].stacktrace[0])".range(of: "manual_error_reporter") != nil){
            //Pop off top line if related to error handler
            event.errors[0].stacktrace.remove(at: 0)
        }
    }
    return true
}
Bugsnag.start(with: config)