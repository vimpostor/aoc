# OCaml

Download OCaml and run as follows:

```bash
ocamlopt main.ml -o main
./main
```

The program runs a recursive Dijkstra and may hit your operating system's stack size limit during the execution of part 2.

You can increase the allowed stack size by running:

```bash
ulimit -s unlimited
```
