#!/usr/bin/env bash
set -euo pipefail

ROOT="${1:-.}"
mapfile -t SWIFT_FILES < <(find "$ROOT" -type f -name '*.swift' | sort)

if [ ${#SWIFT_FILES[@]} -eq 0 ]; then
  echo "No Swift files found under: $ROOT"
  exit 0
fi

echo "Analyzing ${#SWIFT_FILES[@]} Swift files..."

echo
printf '== App Entry Points (@main) ==\n'
MAIN_MATCHES=$(rg -n --no-heading '@main\s*(final\s+)?(class|struct|enum)\s+[A-Za-z_][A-Za-z0-9_]*\s*:\s*App' "${SWIFT_FILES[@]}" || true)
if [ -z "$MAIN_MATCHES" ]; then
  echo "No @main App declarations found."
else
  echo "$MAIN_MATCHES"
  MAIN_COUNT=$(printf '%s\n' "$MAIN_MATCHES" | sed '/^$/d' | wc -l | tr -d ' ')
  if [ "$MAIN_COUNT" -gt 1 ]; then
    echo "⚠️  Multiple @main App entry points detected ($MAIN_COUNT)."
  fi
fi

echo
printf '== Duplicate Type Declarations ==\n'
TYPE_LINES=$(rg -n --no-heading '^[[:space:]]*(final\s+)?(class|struct|enum|actor|protocol)\s+[A-Za-z_][A-Za-z0-9_]*' "${SWIFT_FILES[@]}" || true)
if [ -z "$TYPE_LINES" ]; then
  echo "No top-level type declarations matched."
else
  printf '%s\n' "$TYPE_LINES" | \
  sed -E 's#^([^:]+):([0-9]+):[[:space:]]*(final[[:space:]]+)?(class|struct|enum|actor|protocol)[[:space:]]+([A-Za-z_][A-Za-z0-9_]*).*#\5\t\1:\2#' | \
  awk -F '\t' '
    {name=$1; loc=$2; count[name]++; locs[name]=(locs[name]?locs[name]", ":"") loc}
    END {
      dup=0
      for (n in count) {
        if (count[n] > 1) {
          dup=1
          printf "⚠️  %s declared %d times at %s\n", n, count[n], locs[n]
        }
      }
      if (!dup) print "No duplicate type names found."
    }
  '
fi

echo
printf '== ImmersiveSpaceModel references ==\n'
IMM_REFS=$(rg -n --no-heading '\bImmersiveSpaceModel\b|init\s*\(\s*name\s*:' "${SWIFT_FILES[@]}" || true)
if [ -z "$IMM_REFS" ]; then
  echo "No ImmersiveSpaceModel or init(name:) references found."
else
  echo "$IMM_REFS"
fi

echo
printf '== @StateObject initialization patterns ==\n'
STATE_OBJS=$(rg -n --no-heading '@StateObject\s+(private\s+)?var\s+[A-Za-z_][A-Za-z0-9_]*\s*=\s*' "${SWIFT_FILES[@]}" || true)
if [ -z "$STATE_OBJS" ]; then
  echo "No inline @StateObject initializations found."
else
  echo "$STATE_OBJS"
fi

echo
printf '== Potential dependency wiring in App init ==\n'
INIT_REFS=$(rg -n --no-heading 'init\s*\(\)\s*\{|InteractionCoordinator\s*\(' "${SWIFT_FILES[@]}" || true)
if [ -z "$INIT_REFS" ]; then
  echo "No app-init dependency wiring patterns found."
else
  echo "$INIT_REFS"
fi

echo "Done."
