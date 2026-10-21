#!/usr/bin/env bash
# =============================================================================
# Runner script for SMEFTdipole model generation
# Each target runs in its own clean MathKernel session to avoid caching issues.
# =============================================================================

set -e

# Auto-detect Mathematica kernel
if [ -x "/Applications/Mathematica.app/Contents/MacOS/MathKernel" ]; then
    MATH="/Applications/Mathematica.app/Contents/MacOS/MathKernel"
elif [ -x "/Applications/Mathematica.app/Contents/MacOS/WolframKernel" ]; then
    MATH="/Applications/Mathematica.app/Contents/MacOS/WolframKernel"
elif command -v math >/dev/null 2>&1; then
    MATH="math"
else
    echo "[ERROR] MathKernel not found. Please ensure Mathematica is installed."
    exit 1
fi

ARG="${1:-all}"

case "$ARG" in
    all)
        TARGETS=("FA_Unitary" "FA_Feynman" "UFO_Unitary" "UFO_Feynman")
        ;;
    UFO)
        TARGETS=("UFO_Unitary" "UFO_Feynman")
        ;;
    FA)
        TARGETS=("FA_Unitary" "FA_Feynman")
        ;;
    FA_Unitary|FA_Feynman|UFO_Unitary|UFO_Feynman)
        TARGETS=("$ARG")
        ;;
    *)
        echo "[ERROR] Unknown option: $ARG"
        echo "Usage: ./run.sh [all | UFO | FA | FA_Unitary | FA_Feynman | UFO_Unitary | UFO_Feynman]"
        exit 1
        ;;
esac

echo "=========================================================="
echo "SMEFTdipole Model Generation"
echo "Kernel:  $MATH"
echo "Targets: ${TARGETS[*]}"
echo "=========================================================="

for T in "${TARGETS[@]}"; do
    echo ""
    echo ">>> Starting target: $T in a clean kernel ..."
    echo ""
    "$MATH" -noprompt -run "target=\"$T\"; << SMEFTdipole.m; Quit[];"
    echo ""
    echo ">>> Completed target: $T"
done

echo ""
echo "=========================================================="
echo "All requested targets completed successfully!"
echo "=========================================================="
