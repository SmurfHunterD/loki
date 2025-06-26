package cli

import "core:os"
import "core:fmt"
import "core:strconv"
import "../run"
import "../test"

show_help :: proc() {
    fmt.println("Loki is an NPC generator that marshals a list of generated npcs to a cbor")
    fmt.println("Loki CLI - Usage:")
    fmt.println("  ./loki [flags]")
    fmt.println()
    fmt.println("Flags:")
    fmt.println("  --help or -h          Show help menu")
    fmt.println("  --run or -r           Run mode (default)")
    fmt.println("  --test or -t          Test mode")
    fmt.println("  --count <n> or -c <n> Set iteration count (default: 100)")
    fmt.println()
    fmt.println("Examples:")
    fmt.println("  loki                  # Run with default count (100)")
    fmt.println("  loki --test           # Run tests with count=100")
    fmt.println("  loki --count 500      # Run with count=500")
    fmt.println("  loki --test --count 200 # Run tests with count=200")
    fmt.println("  loki -t           # Run tests with count=100")
    fmt.println("  loki -c 500      # Run with count=500")
    fmt.println("  loki -t -c 200 # Run tests with count=200")
}

loki :: proc() {
    args := os.args[1:] // skip program name

    count: int = 100
    mode := "run"

    i := 0
    for i < len(args) {
        if args[i] == "--help" || args[i] == "-h" {
            show_help()
            return
        } else if (args[i] == "--count" || args[i] == "-c") && i+1 < len(args) {
            val, ok := strconv.parse_int(args[i+1])
            if ok {
                count = val
                i += 2
                continue
            } else {
                fmt.eprintln("Invalid number for --count")
                return
            }
        } else if (args[i] == "--test" || args[i] == "-t") {
            mode = "test"
            i += 1
        } else if (args[i] == "--run" || args[i] == "-r") {
            mode = "run"
            i += 1
        } else {
            fmt.eprintf("Unknown option: %s\n", args[i])
            fmt.eprintln("Use --help for usage information")
            return
        }
    }

    switch mode {
    case "test":
        test.loki(count)
    case "run":
        //run.loki_json(count)
        run.loki_cbor(count)
    }
}
