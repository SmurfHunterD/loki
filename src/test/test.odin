package test

import "../npc"
import "core:fmt"
import "core:time"

loki :: proc(count: int) {
    start := time.now()
    for i in 0..<count {
        instance := npc.generate_npc()
        npc.print_npc(instance)
    }
    elapsed := time.since(start)
    fmt.printf("Finished in %v\n", elapsed)
}
