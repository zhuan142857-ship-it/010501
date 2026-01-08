import os
os.system("iverilog -o d.out tb.v adder_16bits.v system.v dff_16bit.v && vvp d.out")