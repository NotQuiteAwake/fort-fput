# FPUT problem

This Fortran code explores the [Fermi–Pasta–Ulam–Tsingou(FPUT)
problem](https://en.wikipedia.org/wiki/Fermi-Pasta-Ulam-Tsingou_problem) in
chaos theory by simulating a 1D chain with non-linear dynamics with [symplectic
integrators](https://en.wikipedia.org/wiki/Symplectic_integrator).

To build the Fortran code, run:

```{.bash}
meson setup build
ninja -C build/
```

and the binary will reside at `build/fput`. Python code in `pysrc` is mainly for
plotting, and its main function resides in `plot.py`. The programs all read and
write to stdin/stdout; Make use of pipes in shell to redirect to and from files.

License: MIT.
