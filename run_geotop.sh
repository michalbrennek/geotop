#!/bin/bash

GEOTOP_BIN="$(dirname "$0")/builddir/geotop"
TOTAL_CORES=$(nproc)

echo "Detected $TOTAL_CORES CPU cores"
echo ""
echo "Select number of threads to use:"
echo "  1) All cores ($TOTAL_CORES)"
echo "  2) All but one ($((TOTAL_CORES - 1)))"
echo "  3) Half ($((TOTAL_CORES / 2)))"
echo ""
read -p "Choice [1-3]: " choice

case $choice in
    1)
        OMP_NUM_THREADS=$TOTAL_CORES
        ;;
    2)
        OMP_NUM_THREADS=$((TOTAL_CORES - 1))
        ;;
    3)
        OMP_NUM_THREADS=$((TOTAL_CORES / 2))
        ;;
    *)
        echo "Invalid choice, using all cores"
        OMP_NUM_THREADS=$TOTAL_CORES
        ;;
esac

export OMP_NUM_THREADS
echo ""
echo "Running GEOtop with $OMP_NUM_THREADS threads..."
echo ""

exec "$GEOTOP_BIN" "$@"
