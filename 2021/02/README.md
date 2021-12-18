# Bash

Today I am using [Bash](https://www.gnu.org/software/bash/). You can run the script as follows:

```bash
./main.sh input.txt
```


I first tried using [Brainfuck](https://esolangs.org/wiki/Brainfuck) to solve today's problem, but unfortunately I was met by a harsh limitation of Brainfuck: Brainfuck only supports 8-bit numbers, i.e. numbers up to `255` which did not suffice for today's problem. Of course it would be possible to simulate larger numbers using multiple smaller numbers, but given that this is an esoteric language I was not really in the mood for implementing such a cursed workaround, so I just switched to Bash.
Nevertheless, I still uploaded the almost complete Brainfuck program as `main.bf`, which you can execute as follows (though it should be said that the code is not 100% finished).

Download a [brainfuck compiler](https://github.com/benjamin-james/brainfuck) and compile the program:

```bash
bfc main.bf
# Since brainfuck can't read files itself, we have to pass the file via stdin
./a.out < input.txt
```
