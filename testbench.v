#!/usr/bin/env bash
# Simulate/synthesize the systolic array Verilog design.
# Requires: iverilog (Icarus Verilog) for simulation.
#           yosys (optional) for open-source synthesis.
set -e

cd "$(dirname "$0")/verilog"

echo "============================================================"
echo "Step 1: Compiling Verilog sources with Icarus Verilog"
echo "============================================================"
iverilog -g2012 -o sim.out pe.v systolic_array.v testbench.v

echo ""
echo "============================================================"
echo "Step 2: Running simulation"
echo "============================================================"
vvp sim.out

mkdir -p ../results

if command -v yosys >/dev/null 2>&1; then
    echo ""
    echo "============================================================"
    echo "Step 3: Synthesizing with Yosys (generic synthesis stats)"
    echo "============================================================"
    if yosys -p "read_verilog -sv pe.v systolic_array.v; synth; stat" \
        2>&1 | tee ../results/synthesis_stats.txt | grep -q "ERROR"; then
        cat <<'EOF' >> ../results/synthesis_stats.txt

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
EOF
        echo "Yosys could not parse the unpacked-array ports (see results/synthesis_stats.txt for details)."
    else
        echo "Synthesis stats saved to results/synthesis_stats.txt"
    fi
else
    echo ""
    echo "(Yosys not found - install with: sudo apt install yosys)"
    echo "Synthesis stats skipped. Simulation only." > ../results/synthesis_stats.txt
fi

echo ""
echo "Done. Waveform written to verilog/systolic_array.vcd (view with GTKWave)."
