#!/bin/bash
# ReconOps — Subdomain Enumeration Pipeline
# Usage: ./subdomain-enum.sh target.com
# =========================================

TARGET="$1"

if [ -z "$TARGET" ]; then
  echo "[!] Usage: $0 <target.com>"
  exit 1
fi

OUTDIR="./output/$TARGET"
mkdir -p "$OUTDIR"

echo "[*] Starting passive subdomain enumeration for: $TARGET"
echo "[*] Output directory: $OUTDIR"

# ── Stage 1: Passive Collection ──────────────────────────────────────────────

echo ""
echo "[+] Stage 1: Passive subdomain collection..."

# subfinder
if command -v subfinder &>/dev/null; then
  echo "  [~] Running subfinder..."
  subfinder -d "$TARGET" -silent 2>/dev/null | anew "$OUTDIR/subs-passive.txt"
else
  echo "  [!] subfinder not found, skipping"
fi

# assetfinder
if command -v assetfinder &>/dev/null; then
  echo "  [~] Running assetfinder..."
  assetfinder --subs-only "$TARGET" 2>/dev/null | anew "$OUTDIR/subs-passive.txt"
else
  echo "  [!] assetfinder not found, skipping"
fi

# amass (passive only)
if command -v amass &>/dev/null; then
  echo "  [~] Running amass (passive)..."
  amass enum -passive -d "$TARGET" -silent 2>/dev/null | anew "$OUTDIR/subs-passive.txt"
else
  echo "  [!] amass not found, skipping"
fi

# crt.sh certificate transparency
echo "  [~] Fetching from crt.sh..."
curl -s "https://crt.sh/?q=%25.$TARGET&output=json" 2>/dev/null | \
  jq -r '.[].name_value' 2>/dev/null | \
  sed 's/\*\.//g' | \
  grep -E "^[a-zA-Z0-9._-]+\.$TARGET$" | \
  anew "$OUTDIR/subs-passive.txt"

PASSIVE_COUNT=$(wc -l < "$OUTDIR/subs-passive.txt")
echo "  [✓] Passive collection complete: $PASSIVE_COUNT unique subdomains"

# ── Stage 2: DNS Resolution ──────────────────────────────────────────────────

echo ""
echo "[+] Stage 2: DNS resolution..."

if command -v puredns &>/dev/null && [ -f "./resolvers.txt" ]; then
  echo "  [~] Resolving with puredns..."
  puredns resolve "$OUTDIR/subs-passive.txt" \
    -r ./resolvers.txt \
    --write "$OUTDIR/subs-resolved.txt" \
    --quiet 2>/dev/null
elif command -v dnsx &>/dev/null; then
  echo "  [~] Resolving with dnsx..."
  cat "$OUTDIR/subs-passive.txt" | \
    dnsx -silent 2>/dev/null > "$OUTDIR/subs-resolved.txt"
else
  echo "  [!] No DNS resolver (puredns/dnsx) found — copying passive results"
  cp "$OUTDIR/subs-passive.txt" "$OUTDIR/subs-resolved.txt"
fi

RESOLVED_COUNT=$(wc -l < "$OUTDIR/subs-resolved.txt")
echo "  [✓] DNS resolution complete: $RESOLVED_COUNT resolved subdomains"

# ── Stage 3: HTTP Probing ────────────────────────────────────────────────────

echo ""
echo "[+] Stage 3: HTTP probing..."

if command -v httpx &>/dev/null; then
  echo "  [~] Running httpx..."
  cat "$OUTDIR/subs-resolved.txt" | \
    httpx -silent -status-code -title -tech-detect \
      -json -o "$OUTDIR/httpx-output.jsonl" 2>/dev/null

  # Extract live URLs for easy reference
  cat "$OUTDIR/httpx-output.jsonl" | \
    jq -r '.url' 2>/dev/null > "$OUTDIR/hosts-live.txt"

  LIVE_COUNT=$(wc -l < "$OUTDIR/hosts-live.txt")
  echo "  [✓] HTTP probing complete: $LIVE_COUNT live hosts"
else
  echo "  [!] httpx not found, skipping HTTP probing"
fi

# ── Stage 4: Screenshots ─────────────────────────────────────────────────────

echo ""
echo "[+] Stage 4: Screenshots..."

if command -v gowitness &>/dev/null && [ -f "$OUTDIR/hosts-live.txt" ]; then
  echo "  [~] Taking screenshots with gowitness..."
  mkdir -p "$OUTDIR/screenshots"
  gowitness file -f "$OUTDIR/hosts-live.txt" \
    -P "$OUTDIR/screenshots/" \
    --delay 1 \
    --timeout 10 \
    --disable-logging 2>/dev/null
  echo "  [✓] Screenshots saved to $OUTDIR/screenshots/"
else
  echo "  [!] gowitness not found or no live hosts, skipping screenshots"
fi

# ── Summary ──────────────────────────────────────────────────────────────────

echo ""
echo "=============================="
echo "  ReconOps Subdomain Summary"
echo "=============================="
echo "  Target:          $TARGET"
echo "  Passive subs:    $(wc -l < "$OUTDIR/subs-passive.txt" 2>/dev/null || echo 0)"
echo "  Resolved subs:   $(wc -l < "$OUTDIR/subs-resolved.txt" 2>/dev/null || echo 0)"
echo "  Live HTTP hosts: $(wc -l < "$OUTDIR/hosts-live.txt" 2>/dev/null || echo 0)"
echo "  Output dir:      $OUTDIR"
echo "=============================="
echo ""
echo "[✓] Done. Review $OUTDIR/httpx-output.jsonl for full host details."
echo "[>] Next: Run js-harvest.sh on live hosts for JS endpoint mining."
