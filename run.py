import os
#os.system("iverilog -o d.out tb_adder.v jiajianchengchudff.v system_adder.v && vvp d.out")

#os.system("iverilog -o d.out jiajianchengchudff.v tb_subtractor.v system_subtractor.v && vvp d.out")

#os.system("iverilog -o d.out tb_multiplier.v jiajianchengchudff.v system_multiplier.v && vvp d.out")

#os.system("iverilog -o d.out tb_divider.v jiajianchengchudff.v system_divider.v && vvp d.out")

os.system("iverilog -o d.out test_unified_system.v jiajianchengchudff.v unified_computing_system.v && vvp d.out")

