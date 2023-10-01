# acbr_ffi - Brazilian NF-e library

Need `ACBrLib`!!

ACBrLib is a set of shared libraries that makes it possible to use ACBr Project components in any programming language.

### Reference

* `ACBrlib`: https://www.projetoacbr.com.br/forum/topic/53508-lan%C3%A7amento-da-acbrlib/
* mirror: https://github.com/frones/ACBr
* ACBr Doc: https://acbr.sourceforge.io/ACBrLib/POS_Inicializar.html


## Samples

* **C** - [demo.c](demo.c)
* **Zig** - [demo.zig](demo.zig)

### Build

```bash
# C
(gcc/clang/zig cc) -Ofast demo.c -o demo
# Zig
zig build-exe -O ReleaseSafe demo.zig -lc
```

#### Output

```bash
LD_LIBRARY_PATH=$PWD ./demo

info(ACBr): Initialize ACBrLib!!
info(ACBr): Nome: ACBrLibNFE Demo
info(ACBr): Versao: 0.4.6.23
```