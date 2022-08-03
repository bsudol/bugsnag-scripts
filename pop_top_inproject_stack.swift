let config = BugsnagConfiguration.loadConfig()
config.addOnSendError { (event) -> Bool in

    let firstError = event.errors.first
    let errorClass = firstError.errorClass
    let errorContext = firstError.context
    
    if (errorClass == "App Hang" && errorContext == "exampleView"){
        var index:Int = 0
        for stack in event.errors[0].stacktrace{
            //Macho file will generally end in /{AppName} if stack is in-project
            if (stack.machoFile?.hasSuffix("/AppName") ?? false){
                event.errors[0].stacktrace.remove(at: index)
                break
            }
            index += 1
        }
    }

    return true
}
Bugsnag.start(with: config)
