# Assembly

Today I am using **Assembly** (RISC-V ISA).

To assemble, use:

```bash
riscv64-elf-gcc -c main.S -o main.o
riscv64-elf-gcc main.o -o main
```

You can then either run the ELF binary directly on RISC-V hardware or cheat like me and run it in a RISC-V simulator.
I personally use [spike](https://github.com/riscv-software-src/riscv-isa-sim), but you can also use [tinyemu](https://bellard.org/tinyemu/) alternatively.

```bash
spike /usr/riscv64-linux-gnu/bin/pk main
```

# Resources

Here are some resources to help understand RISC-V Assembly.

- [RISC-V ISA spec](https://github.com/riscv/riscv-isa-manual/releases/download/Ratified-IMAFDQC/riscv-spec-20191213.pdf) - The complete ISA spec
- [RISC-V Assembly for beginners](https://medium.com/swlh/risc-v-assembly-for-beginners-387c6cd02c49) - A helpful blogpost
- [Ripes](https://github.com/mortbopet/Ripes) - A neat graphical RISC-V simulator
