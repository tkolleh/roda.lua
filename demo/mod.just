[doc("Run the demo script to showcase Roda features")]
run:
    lx lua -- demo/demo.lua

[doc("Record the demo and generate a GIF using VHS")]
record:
    cd demo && vhs demo.tape

