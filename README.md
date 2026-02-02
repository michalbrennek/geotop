# GEOtop with OpenMP Parallelization

GEOtop hydrological model with multi-core support via OpenMP.

Based on [GEOtop 3.0](https://github.com/geotopmodel/geotop).

## Quick Start

```bash
# 1. Clone this repository
git clone https://github.com/michalbrennek/geotop.git
cd geotop

# 2. Install dependencies
./check_dependencies.sh

# 3. Build with OpenMP
meson setup builddir -DWITH_OMP=true
meson compile -C builddir

# 4. Run
./run_geotop.sh <input_directory>
```

## Manual Compilation

```bash
meson setup builddir -DWITH_OMP=true
meson compile -C builddir
```

## Running

Interactive core selection:
```bash
./run_geotop.sh <input_directory>
```

Manual thread control:
```bash
export OMP_NUM_THREADS=8
./builddir/geotop <input_directory>
```

## OpenMP Parallelization

11 parallel regions added to grid-based loops:

| File | Line | Function |
|------|------|----------|
| src/geotop/water.balance.cc | 1583 | find_dfdH_3D() |
| src/geotop/meteodistr.cc | 130 | get_temperature() |
| src/geotop/meteodistr.cc | 190 | get_relative_humidity() |
| src/geotop/meteodistr.cc | 237 | topo_mod_winds() |
| src/geotop/meteodistr.cc | 251 | topo_mod_winds() |
| src/geotop/meteodistr.cc | 280 | topo_mod_winds() |
| src/geotop/meteo.cc | 99 | meteo_distr() |
| src/libraries/geomorphology/geomorphology.cc | 20 | find_slope() |
| src/libraries/geomorphology/geomorphology.cc | 135 | find_max_slope() |
| src/libraries/geomorphology/geomorphology.cc | 168 | find_aspect() |
| src/libraries/geomorphology/geomorphology.cc | 206 | curvature() |

## Requirements

- C++ compiler with OpenMP (GCC, Clang, Intel)
- Meson + Ninja
- Boost libraries

## License

GPL v3 (see LICENSE)
