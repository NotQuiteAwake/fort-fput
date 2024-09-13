# Example of simulation

This is an example of a rendered simulation, with some sensible physical values.
The simulation starts with the first harmonic of the system, and tracks its
evolution until the normalised "amplitude" (from an eigenvalue decomposition) of
the first harmonic is again $\ge 0.9995$. Simulation then continues until the
string evolves "out of" the first harmonic (amplitude $\le 0.9995$) a second
time.

To recreate the output, build the Meson target, make sure you have `ffmpeg`
installed, then run the following:

```{.bash}
../../build/fput < fput.in > fput.out
python ../../pysrc/simulate.py < fput.out
```

The video is rendered with code at commit `54af052`. Subsequent changes can
alter the result slightly but it should largely stay the same.
