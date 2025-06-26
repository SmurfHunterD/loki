package main 

import "src/npc"
import "src/test"
import "src/run"
import "src/cli"

main :: proc() {

    //********Call Test*********
    //test.loki(100)   
    
    //*******Run Program********
    //run.loki_json(10)
    //run.loki_cbor(10)

    //********CLI Build*********
    cli.loki()
}
