#!/bin/bash
# ReconOps — Surface Change Monitor
# Usage: ./change-monitor.sh target.com
# Designed to run via cron for continuous monitoring
# =========================================
# Cron example (run every 6 hours):
# 0 */6 * * * /path/to/change-monitor.sh target.com >> /var/log/reconops.log 2>&1

TARGET="$1"

if [ -z "$TARGET" ]; then
  echo "[!] Usage: $0 <target.com>"
  exit 1
fi

DATADIR="./monitor/$TARGET"
mkdir -p "$DATADIR"

TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")
DATE=$(date +%Y%m%d-%H%M)

echo "[$TIMESTAMP] Starting change monitor for: $TARGET"

# ── Subdomain Snapshot ───────────────────────────────────────────────────────

SUBS_TODAY="/tmp/reconops-subs-$DATE.txt"
SUBS_PREV="$DATADIR/subs-latest.txt"
SUBS_NEW="$DATADIR/subs-new-$DATE.txt"

echo "[$TIMESTAMP] Collecting current subdomains..."
{
  subfinder -d "$TARGET" -silent 2>/dev/null
  assetfinder --subs-only "$TARGET" 2>/dev/null
  curl -s "https://crt.sh/?q=%25.$TARGET&output=json" 2>/dev/null | \
    jq -r '.[].name_value' 2>/dev/null | sed 's/\*\.//g'
} | sort -u > "$SUBS_TODAY"

# Compare against previous snapshot
if [ -f "$SUBS_PREV" ]; then
  NEW_SUBS=$(comm -13 "$SUBS_PREV" "$SUBS_TODAY" 2>/dev/null)
  REMOVED_SUBS=$(comm -23 "$SUBS_PREV" "$SUBS_TODAY" 2>/dev/null)

  if [ -n "$NEW_SUBS" ]; then
    echo "[$TIMESTAMP] ⚠️  NEW SUBDOMAINS DETECTED:"
    echo "$NEW_SUBS" | while read sub; do
      echo "  [NEW] $sub"
    done
    echo "$NEW_SUBS" > "$SUBS_NEW"

    # Send notification if notify is available
    if command -v notify &>/dev/null; then
      echo "$NEW_SUBS" | \
        notify -bulk -provider-config ./notify-config.yaml \
        -msg " New subdomains on $TARGET:" 2>/dev/null
    fi
  else
    echo "[$TIMESTAMP] No new subdomains found."
  fi

  if [ -n "$REMOVED_SUBS" ]; then
    echo "[$TIMESTAMP]  Subdomains that disappeared:"
    echo "$REMOVED_SUBS" | while read sub; do
      echo "  [GONE] $sub"
    done
  fi
else
  echo "[$TIMESTAMP] First run — establishing baseline snapshot."
fi

# Update latest snapshot
cp "$SUBS_TODAY" "$SUBS_PREV"
rm -f "$SUBS_TODAY"

# Archive
cp "$SUBS_PREV" "$DATADIR/snapshots/subs-$DATE.txt" 2>/dev/null || {
  mkdir -p "$DATADIR/snapshots"
  cp "$SUBS_PREV" "$DATADIR/snapshots/subs-$DATE.txt"
}

TOTAL=$(wc -l < "$SUBS_PREV")
echo "[$TIMESTAMP] Monitor complete. Total tracked subdomains: $TOTAL"
