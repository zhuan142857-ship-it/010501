import os
os.system("iverilog -o d.out tb.v m_sixteen_bit_adder.v m_system.v m_dff_16bit.v && vvp d.out")