
 /----------------------------------------------------------------------------\
 |                                                                            |
 |  yosys -- Yosys Open SYnthesis Suite                                       |
 |                                                                            |
 |  Copyright (C) 2012 - 2020  Claire Xenia Wolf <claire@yosyshq.com>         |
 |                                                                            |
 |  Permission to use, copy, modify, and/or distribute this software for any  |
 |  purpose with or without fee is hereby granted, provided that the above    |
 |  copyright notice and this permission notice appear in all copies.         |
 |                                                                            |
 |  THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES  |
 |  WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF          |
 |  MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR   |
 |  ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES    |
 |  WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN     |
 |  ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF   |
 |  OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.            |
 |                                                                            |
 \----------------------------------------------------------------------------/

 Yosys 0.33 (git sha1 2584903a060)


-- Running command `read_verilog -sv pe.v systolic_array.v; synth; stat' --

1. Executing Verilog-2005 frontend: pe.v
Parsing SystemVerilog input from `pe.v' to AST representation.
Generating RTLIL representation for module `\pe'.
Successfully finished Verilog frontend.

2. Executing Verilog-2005 frontend: systolic_array.v
systolic_array.v:4: ERROR: syntax error, unexpected '[', expecting ',' or '=' or ')'

NOTE: Yosys's Verilog/SystemVerilog frontend does not support unpacked-array
module ports (e.g. "input wire [15:0] a_in [15:0]"), even with -sv. This is a
known limitation of the open-source frontend (Icarus Verilog's -g2012 mode
handles it fine for simulation, which is why testbench.v runs correctly).

To get real synthesis stats out of Yosys/OpenROAD-style flows, flatten the
array ports to single packed vectors, e.g.:
    input  wire signed [255:0] a_in_flat,   // 16 x 16-bit lanes packed
    input  wire signed [255:0] b_in_flat,
and slice/index into them inside the module instead of using a port that is
itself an array. That's a real RTL change (not just a flag), so it hasn't
been made automatically here.
