// Add metadata to device tab flagging which internal tier the device is
// Based on maintaining an internal mapping of device model to low/medium/high (can be modified to track any characteristics that would best be contained in a mapping)
// Implementation may vary based on app architecture and how mapping is stored.
// See mapping.json file and DeviceTier class for more information on how this is accessed in this callback.

config.addOnError(OnErrorCallback { event ->
    event.addMetadata("device", "tier", DeviceTier.get_tier(android.os.Build.MODEL))

    // Return `false` if you'd like to stop this error being reported
    true
})

Bugsnag.start(this, config)