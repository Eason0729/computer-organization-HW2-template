CC := "riscv64-unknown-linux-gnu-gcc"
SYSROOT := "/home/eason/.riscv-toolchain/riscv-gnu-toolchain/sysroot/"
CFLAGS := "-static -march=rv64gcv -g -DFORCE_RISCV -lm"
PK := "pk"
SPIKE := "spike"
SPIKE_FLAG := "--isa=RV64GCV"
BUILD_DIR := "build"

default:
    @just --list

clean:
    @echo "Cleaning build directory..."
    rm -rf {{BUILD_DIR}}

build task:
    @mkdir -p {{BUILD_DIR}}/artifacts
    @echo "Building asm..."
    ./build-asm.sh
    @echo "Compiling {{task}}.c for RISC-V..."
    {{CC}} --sysroot={{SYSROOT}} -I$(pwd)/include -I$(pwd)/build/casm -o {{BUILD_DIR}}/artifacts/{{task}} exercise/{{task}}.c {{CFLAGS}}

run task:
    @echo "Running {{task}} on Spike..."
    {{SPIKE}} {{SPIKE_FLAG}} {{PK}} {{BUILD_DIR}}/artifacts/{{task}}

clangd-config:
    @echo "Generating .clangd file..."
    @printf "CompileFlags:\\n" > .clangd
    @printf "  Add:\\n" >> .clangd
    @printf "    - \"-I$(pwd)/include\"\\n" >> .clangd
    @printf "    - \"-I$(pwd)/build/casm\"\\n" >> .clangd
    @printf "    - \"-target\"\\n" >> .clangd
    @printf "    - \"riscv64\"\\n" >> .clangd # clangd typically needs the target specified
    @printf "    - \"-march=rv64gcv\"\\n" >> .clangd
    @printf "    - \"--sysroot={{SYSROOT}}\"\\n" >> .clangd
    @printf "    - \"-DFORCE_RISCV\"\\n" >> .clangd
    @printf "    - \"-I{{SYSROOT}}usr/include\"\\n" >> .clangd
