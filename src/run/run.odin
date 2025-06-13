package run 

import "core:os"
import "core:time"
import "core:fmt"
import "../npc"


loki :: proc(count: int) {
    // Generate and marshal NPCs to JSON
    start := time.now()
    if json_data, err := npc.marshal_npcs(count); err == nil {
        defer delete(json_data)
        
        // fmt.println(string(json_data))
        
        filename := "npcs.json"
        if os.write_entire_file(filename, json_data) {
            fmt.printf("Successfully saved NPCs to '%s'\n", filename)
        } else {
            fmt.eprintf("Failed to write to file '%s'\n", filename)
        }
    } else {
        fmt.eprintln("Failed to marshal NPCs:", err)
    }
    elapsed := time.since(start)
    fmt.printf("Finished in %v\n", elapsed)
}
