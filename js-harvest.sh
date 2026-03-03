#!/bin/bash
# ReconOps — JavaScript Endpoint Harvester
# Usage: ./js-harvest.sh hosts-live.txt [target.com]
# =========================================

INPUT="$1"
TARGET="${2:-output}"
OUTDIR="./output/$TARGET"

if [ -z "$INPUT" ]; then
  echo "[!] Usage: $0 <hosts-live.txt> [target-name]"
  exit 1
fi

mkdir -p "$OUTDIR/js-analysis"

echo "[*] Starting JS harvest from: $INPUT"

# ── Collect JS URLs ──────────────────────────────────────────────────────────

echo ""
echo "[+] Stage 1: Collecting JS file URLs..."

# Katana crawl + JS extraction
if command -v katana &>/dev/null; then
  echo "  [~] Crawling with katana (JS mode)..."
  cat "$INPUT" | katana -jc -silent -nc 2>/dev/null | \
    grep "\.js$" | anew "$OUTDIR/js-analysis/js-urls.txt"
fi

# Get JS from historical sources too
if command -v gau &>/dev/null; then
  echo "  [~] Pulling JS URLs from gau..."
  cat "$INPUT" | sed 's|https\?://||' | gau --threads 5 2>/dev/null | \
    grep "\.js$" | anew "$OUTDIR/js-analysis/js-urls.txt"
fi

if command -v waybackurls &>/dev/null; then
  echo "  [~] Pulling JS URLs from Wayback..."
  cat "$INPUT" | sed 's|https\?://||' | waybackurls 2>/dev/null | \
    grep "\.js$" | anew "$OUTDIR/js-analysis/js-urls.txt"
fi

JS_COUNT=$(wc -l < "$OUTDIR/js-analysis/js-urls.txt" 2>/dev/null || echo 0)
echo "  [✓] Found $JS_COUNT unique JS files"

if [ "$JS_COUNT" -eq 0 ]; then
  echo "  [!] No JS files found. Exiting."
  exit 0
fi

# ── Endpoint Extraction ──────────────────────────────────────────────────────

echo ""
echo "[+] Stage 2: Extracting endpoints from JS files..."

if command -v python3 &>/dev/null && [ -f "$(which linkfinder.py 2>/dev/null)" ]; then
  echo "  [~] Running LinkFinder..."
  cat "$OUTDIR/js-analysis/js-urls.txt" | while read url; do
    curl -sk --max-time 10 "$url" 2>/dev/null | \
      python3 "$(which linkfinder.py)" -i /dev/stdin -o cli 2>/dev/null
  done | sort -u | tee "$OUTDIR/js-analysis/js-endpoints.txt"
else
  echo "  [~] LinkFinder not found, using regex-based extraction..."
  # Basic regex endpoint extraction as fallback
  cat "$OUTDIR/js-analysis/js-urls.txt" | while read url; do
    curl -sk --max-time 10 "$url" 2>/dev/null | \
      grep -oE '("|'"'"')(\/[a-zA-Z0-9_\-\.\/\?=&%#@:]+)("|'"'"')' | \
      tr -d '"'"'" | grep -E "^/" | grep -v "^//"
  done | sort -u | tee "$OUTDIR/js-analysis/js-endpoints.txt"
fi

EP_COUNT=$(wc -l < "$OUTDIR/js-analysis/js-endpoints.txt" 2>/dev/null || echo 0)
echo "  [✓] Extracted $EP_COUNT endpoints from JS"

# ── Secret Scanning ──────────────────────────────────────────────────────────

echo ""
echo "[+] Stage 3: Scanning for secrets in JS files..."

if command -v trufflehog &>/dev/null; then
  echo "  [~] Running trufflehog on JS files..."
  cat "$OUTDIR/js-analysis/js-urls.txt" | while read url; do
    curl -sk --max-time 10 "$url" -o /tmp/reconops-jsfile.js 2>/dev/null
    trufflehog filesystem /tmp/reconops-jsfile.js \
      --no-update --json 2>/dev/null | \
      jq -r '. | "URL: '"'"'$url'"'"'\nSecret: \(.Raw)\nDetector: \(.DetectorName)\n---"' 2>/dev/null
  done | tee "$OUTDIR/js-analysis/js-secrets.txt"
  rm -f /tmp/reconops-jsfile.js
  
  SECRET_COUNT=$(grep -c "URL:" "$OUTDIR/js-analysis/js-secrets.txt" 2>/dev/null || echo 0)
  echo "  [✓] Secret scan complete. Potential secrets: $SECRET_COUNT"
else
  echo "  [!] trufflehog not found, doing basic regex secret scan..."
  cat "$OUTDIR/js-analysis/js-urls.txt" | while read url; do
    curl -sk --max-time 10 "$url" 2>/dev/null | \
      grep -iE "(api_key|apikey|secret|password|token|bearer|private_key|aws_|ghp_|glpat-)" | \
      grep -v "//.*" | head -20
  done | sort -u | tee "$OUTDIR/js-analysis/js-secrets-basic.txt"
fi

# ── Summary ──────────────────────────────────────────────────────────────────

echo ""
echo "=============================="
echo "  ReconOps JS Harvest Summary"
echo "=============================="
echo "  JS files found:   $(wc -l < "$OUTDIR/js-analysis/js-urls.txt" 2>/dev/null || echo 0)"
echo "  Endpoints found:  $(wc -l < "$OUTDIR/js-analysis/js-endpoints.txt" 2>/dev/null || echo 0)"
echo "  Output dir:       $OUTDIR/js-analysis/"
echo "=============================="
echo ""
echo "[✓] Done. Review:"
echo "    - $OUTDIR/js-analysis/js-endpoints.txt (extracted endpoints)"
echo "    - $OUTDIR/js-analysis/js-secrets.txt (potential secrets)"
