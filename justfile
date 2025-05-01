CC := "riscv64-unknown-linux-gnu-gcc"
SYSROOT := "/home/eason/.riscv-toolchain/riscv-gnu-toolchain/sysroot/"
CFLAGS := "-static -march=rv64gcv -g -DFORCE_RISCV -DARR_SIZE=16 -lm"
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
    ./script/build-casm.sh
    @echo "Compiling {{task}}.c for RISC-V..."
    {{CC}} --sysroot={{SYSROOT}} -I$(pwd)/include -I$(pwd)/build/casm -o {{BUILD_DIR}}/artifacts/{{task}} exercise/{{task}}.c {{CFLAGS}}

run task:
    @echo "Running {{task}} on Spike..."
    cd testcase && {{SPIKE}} {{SPIKE_FLAG}} {{PK}} ../{{BUILD_DIR}}/artifacts/{{task}}

# Generating .clangd file
clangd-config:
    @echo "Generating .clangd file..."
    @printf "CompileFlags:\\n" > .clangd
    @printf "  Add:\\n" >> .clangd
    @printf "    - \"-I$(pwd)/include\"\\n" >> .clangd
    @printf "    - \"-I$(pwd)/build/casm\"\\n" >> .clangd
    @printf "    - \"-target\"\\n" >> .clangd
    @printf "    - \"riscv64\"\\n" >> .clangd
    @printf "    - \"-march=rv64gcv\"\\n" >> .clangd
    @printf "    - \"--sysroot={{SYSROOT}}\"\\n" >> .clangd
    @printf "    - \"-DFORCE_RISCV\"\\n" >> .clangd
    @printf "    - \"-I{{SYSROOT}}usr/include\"\\n" >> .clangd

# Watch assembly changes and build casm on fly
watch-casm:
    @echo "Watching for changes..."
    ./script/watch-casm.sh

# Watch file changes and build and run task on fly
watch-task task:
    @echo "Watching for changes..."
    ./script/watch-task.sh {{task}}
