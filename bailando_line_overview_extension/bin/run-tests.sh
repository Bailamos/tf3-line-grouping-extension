#!/usr/bin/env bash
set -uo pipefail

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
cd -- "$script_dir/../.." || exit 1

mapfile -d '' -t files < <(find . -type f -name '*.test.tl' -print0)
failed=0

for test_file in "${files[@]}"; do
    printf 'Running: %s\n' "$test_file"

    if ! tl run "$test_file"; then
        failed=1
    fi
done

exit "$failed"
