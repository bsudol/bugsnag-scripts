package com.example.foo;
import java.io.File;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;
import com.fasterxml.jackson.databind.ObjectMapper;


public class DeviceTier<path> {

    // Access mapping stored in json file. Adjust path_to_mapping accordingly.
    public static Map<String, Object> get_mapping() {
        File file = new File("path_to_mapping.json");
        try {
            return (new ObjectMapper().readValue(file, HashMap.class));
        } catch (IOException e) {
            e.printStackTrace();
            return(null);
        }
    }

    // Called in the callback function, this checks your mapping to see what tier the device is.
    public static String get_tier(String model) {
        Map<String, Object> current_device_mapping = get_mapping();

        if (current_device_mapping != null){
            return (String.valueOf(current_device_mapping.get(model)));
        }
        else {
            return ("unknown");
        }
    }
}