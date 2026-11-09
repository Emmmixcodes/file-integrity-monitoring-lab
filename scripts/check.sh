#!/bin/bash
# File Integrity Monitor: compares files in data/ against baseline.sha256
cd "$(dirname "$0")/.." || exit 1

echo "=== Integrity check: $(date) ==="

echo "--- Modified or missing files ---"
sha256sum -c baseline.sha256 2>&1 | grep -v ": OK"

echo "--- New or removed files ---"
diff <(awk '{print $2}' baseline.sha256 | sort) <(find data -type f | sort)
