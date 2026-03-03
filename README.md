# 🔍 ReconOps — Bug Bounty Recon-Only Framework

<div align="center">

![ReconOps Banner](https://img.shields.io/badge/ReconOps-Bug%20Bounty%20Framework-red?style=for-the-badge&logo=target)
![License](https://img.shields.io/badge/License-MIT-blue?style=for-the-badge)
![Status](https://img.shields.io/badge/Status-Active-brightgreen?style=for-the-badge)
![PRs Welcome](https://img.shields.io/badge/PRs-Welcome-orange?style=for-the-badge)

**A structured, recon-only bug bounty framework for beginners and intermediate hunters.**
*Understand the surface before you attack it.*

[📖 Framework Overview](#-framework-overview) •
[🛠️ Tools Index](#️-tools-index) •
[🗺️ Methodology](#️-recon-methodology-map) •
[📂 Docs](#-documentation) •
[🤝 Contributing](#-contributing)

</div>

---

## ⚠️ Disclaimer

> This framework is intended **strictly for authorized bug bounty programs and ethical security research**. Never perform reconnaissance on systems you do not have explicit written permission to test. Always operate within the defined scope of a bug bounty program. The authors assume no liability for misuse.

---

## 🧠 Philosophy

> **"You can't attack what you haven't mapped."**

Most beginners jump straight to exploitation without understanding what they're looking at. ReconOps fixes that. This is a **recon-only framework** — it does not cover exploitation. It covers everything *before* exploitation: mapping the attack surface, understanding infrastructure, finding forgotten assets, and building intelligence that makes the real work count.

Recon is 80% of the job. This framework treats it that way.

---

## 📦 Framework Overview

```
ReconOps/
├── README.md                  ← You are here
├── FRAMEWORK.md               ← Full tier breakdown with tools
├── TOOLS.md                   ← Tools index & install guide
├── CHECKLIST.md               ← Per-engagement recon checklist
├── docs/
│   ├── passive-recon.md       ← Deep dive: passive techniques
│   ├── active-recon.md        ← Deep dive: active techniques
│   ├── js-analysis.md         ← JavaScript mining guide
│   ├── api-recon.md           ← API surface discovery
│   ├── cloud-recon.md         ← Cloud & bucket enumeration
│   └── automation.md          ← Building your own pipelines
├── scripts/
│   ├── subdomain-enum.sh      ← Automated subdomain pipeline
│   ├── js-harvest.sh          ← JS endpoint harvester
│   ├── alive-check.sh         ← Live asset validation
│   ├── screenshot-all.sh      ← Mass screenshotting
│   └── change-monitor.sh      ← Surface diff monitoring
├── wordlists/
│   └── README.md              ← Recommended wordlist sources
└── templates/
    ├── scope-notes.md         ← Scope tracking template
    └── recon-report.md        ← Recon findings template
```

---

## 🗺️ Recon Methodology Map

```
Target Acquired
      │
      ▼
┌─────────────────────────────────────────────┐
│  TIER 0: Pre-Recon Infrastructure Cognition │  ← Understand HOW the internet works first
└─────────────────────────────────────────────┘
      │
      ▼
┌─────────────────────────────────────────────┐
│  TIER 1: Passive Surface Intelligence       │  ← Look without touching
└─────────────────────────────────────────────┘
      │
      ▼
┌─────────────────────────────────────────────┐
│  TIER 2: Active Surface Expansion           │  ← Probe and enumerate
└─────────────────────────────────────────────┘
      │
      ▼
┌─────────────────────────────────────────────┐
│  TIER 3: Deep Surface Intelligence          │  ← Go deeper on live assets
└─────────────────────────────────────────────┘
      │
      ▼
┌─────────────────────────────────────────────┐
│  TIER 4: Recon Data Engineering             │  ← Automate, deduplicate, monitor
└─────────────────────────────────────────────┘
      │
      ▼
┌─────────────────────────────────────────────┐
│  TIER 5: Strategic Surface Dominance        │  ← Prioritize, correlate, hand off
└─────────────────────────────────────────────┘
      │
      ▼
  [Handoff to Exploitation — NOT covered here]
```

---

## 🔭 Tier 0 — Pre-Recon Infrastructure Cognition

> **Goal:** Understand the internet plumbing before you start. This tier is about knowledge, not tools.

### Why This Tier Exists

Beginners often start firing tools without understanding *what* they're looking at. Tier 0 fixes that. You need to understand DNS, CDNs, ASNs, and HTTP behavior before your tool output means anything.

### 0.1 DNS Fundamentals

| Concept | Why It Matters |
|--------|----------------|
| DNS resolution chain | Understand how `dig` output reflects real routing |
| A / CNAME / MX / TXT / NS records | Each record type leaks different intelligence |
| DNS propagation & TTL | Old records can point to abandoned infrastructure |
| Wildcard DNS behavior | `*.target.com` resolving doesn't mean a subdomain exists |

**Learn with:** `dig`, `nslookup`, `host`

### 0.2 ASN & IP Ownership

| Concept | Why It Matters |
|--------|----------------|
| ASN (Autonomous System Numbers) | Find IP ranges owned by a company — even unlinked ones |
| WHOIS & RDAP | Legal ownership of IPs and domains |
| BGP routing data | Understand which IPs actually reach the target |
| Reverse DNS (PTR records) | Map IPs back to hostnames |

**Tools:** `whois`, [bgp.he.net](https://bgp.he.net), [ipinfo.io](https://ipinfo.io), `asnmap`

### 0.3 CDN & Reverse Proxy Awareness

| Concept | Why It Matters |
|--------|----------------|
| CDN detection (Cloudflare, Akamai, Fastly) | You may not be talking to the real origin server |
| Origin IP leakage | CDN misconfigs can expose the real IP |
| Load balancer behavior | Different backend responses = interesting |
| Reverse proxy headers | `X-Forwarded-For`, `Via`, `CF-RAY` leak infrastructure info |

**Tools:** `curl -I`, [Shodan](https://shodan.io), [Censys](https://censys.io), [SecurityTrails](https://securitytrails.com)

### 0.4 HTTP Behavioral Basics

| Concept | Why It Matters |
|--------|----------------|
| HTTP response headers | Fingerprint stack, WAF, caching layers |
| Status code behavior | 200/301/302/403/404/429 each tell a different story |
| CORS headers | Trust boundaries visible in `Access-Control-Allow-Origin` |
| Cache headers | `X-Cache`, `Age`, `Cache-Control` reveal caching topology |

---

## 🕵️ Tier 1 — Passive Surface Intelligence

> **Goal:** Collect maximum information without sending a single packet to the target.

### 1.1 Organizational Footprint Mapping

Find everything the organization owns — not just the obvious domains.

| Task | Recommended Tools |
|------|------------------|
| Find parent company / subsidiaries | [Crunchbase](https://crunchbase.com), [LinkedIn](https://linkedin.com), manual OSINT |
| Historical M&A research | [Wikipedia](https://en.wikipedia.org), news archives, SEC filings |
| Brand & trademark asset discovery | [USPTO TESS](https://tess.uspto.gov), Google dorks |
| Find all registered domains | [WhoisXMLAPI](https://whoisxmlapi.com), `amass intel`, [Shodan](https://shodan.io) |

**Pro Tip:** Companies that acquired startups often inherit old, forgotten infrastructure. That's scope gold.

### 1.2 Subdomain Discovery (Passive)

| Task | Recommended Tools |
|------|------------------|
| Certificate Transparency logs | [crt.sh](https://crt.sh), `certspotter`, `tlsx` |
| Passive DNS databases | [SecurityTrails](https://securitytrails.com), [VirusTotal](https://virustotal.com), [Robtex](https://robtex.com) |
| Historical DNS records | [SecurityTrails](https://securitytrails.com), [DNSHistory](https://dnshistory.org) |
| Subdomain enumeration (passive) | `subfinder`, `amass passive`, `assetfinder` |
| OSINT aggregation | `theHarvester`, `chaos` (ProjectDiscovery) |

```bash
# Example passive subdomain pipeline
subfinder -d target.com -silent | \
  anew subdomains.txt

amass enum -passive -d target.com | \
  anew subdomains.txt

cat subdomains.txt | sort -u > subdomains-final.txt
```

### 1.3 Public Code & Secret Exposure

| Task | Recommended Tools |
|------|------------------|
| GitHub/GitLab code search | [GitHub Search](https://github.com/search), `gitrob`, `trufflehog` |
| Exposed credentials & API keys | `trufflehog`, `gitleaks`, `gitdorker` |
| Google dorks for target | `dork-cli`, manual Google operators |
| Pastebin & paste sites | [psbdmp.ws](https://psbdmp.ws), Dehashed |
| Document metadata leaks | `exiftool`, `FOCA` |

**Essential Google Dorks:**
```
site:target.com ext:env OR ext:yml OR ext:config
site:github.com "target.com" password OR secret OR token
site:target.com inurl:api OR inurl:admin OR inurl:login
"@target.com" filetype:pdf
site:target.com -www
```

### 1.4 Cloud Storage Exposure

| Task | Recommended Tools |
|------|------------------|
| S3 bucket discovery | `s3scanner`, `cloud_enum`, `bucket_finder` |
| Azure Blob / GCP Storage | `cloud_enum`, `GCPBucketBrute` |
| Public bucket content analysis | `s3scanner`, AWS CLI (anonymous) |
| Firebase database exposure | Manual, `firebase-database-dump` |

```bash
# Cloud asset enumeration
cloud_enum -k target -k targetcompany -k target-corp
```

### 1.5 Web Archive & Historical Surface Recovery

| Task | Recommended Tools |
|------|------------------|
| Wayback Machine URL mining | `waybackurls`, `gau` (GetAllURLs) |
| Historical endpoint discovery | `gau`, `waymore` |
| Deprecated API resurfacing | `waybackurls`, manual analysis |
| Old JS file recovery | Wayback CDX API, `waymore` |

```bash
# Historical URL collection
echo "target.com" | gau --threads 5 | tee urls-historical.txt
waybackurls target.com | tee -a urls-historical.txt
cat urls-historical.txt | sort -u | grep -E "\.(js|json|php|asp|aspx|txt|env|yml|config)$"
```

---

## 🔬 Tier 2 — Active Surface Expansion

> **Goal:** Probe live infrastructure to map the real attack surface. You are now sending traffic.

> ⚠️ **Only perform active recon on targets within the defined bug bounty scope.**

### 2.1 Live Asset Validation

| Task | Recommended Tools |
|------|------------------|
| Check which subdomains resolve | `massdns`, `dnsx` |
| Check which hosts are live (HTTP/S) | `httpx`, `httprobe` |
| Port scanning | `nmap`, `masscan`, `naabu` |
| Service identification | `nmap -sV`, `naabu` + `httpx` |
| Mass screenshotting | `gowitness`, `aquatone`, `eyewitness` |

```bash
# Full live asset validation pipeline
cat subdomains-final.txt | dnsx -silent | tee resolved.txt
cat resolved.txt | httpx -silent -status-code -title -tech-detect | tee live-hosts.txt
cat resolved.txt | naabu -silent -top-ports 1000 | tee open-ports.txt
cat live-hosts.txt | awk '{print $1}' | gowitness file -f - -P screenshots/
```

### 2.2 Subdomain Enumeration (Active/Brute)

| Task | Recommended Tools |
|------|------------------|
| DNS brute force | `puredns`, `shuffledns` |
| Permutation & alteration | `altdns`, `gotator`, `dnsgen` |
| Virtual host discovery | `ffuf -H "Host: FUZZ.target.com"`, `gobuster vhost` |
| Subdomain takeover detection | `nuclei -t takeovers/`, `subzy`, `subjack` |

```bash
# Active subdomain brute force
puredns bruteforce wordlists/subdomains-top.txt target.com -r resolvers.txt | \
  anew subdomains-active.txt

# Permutation-based discovery
cat subdomains-final.txt | gotator -sub wordlists/permutations.txt -depth 1 | \
  puredns resolve -r resolvers.txt | anew subdomains-active.txt
```

### 2.3 Web Content Discovery

| Task | Recommended Tools |
|------|------------------|
| Directory & file brute force | `ffuf`, `feroxbuster`, `gobuster` |
| Parameter discovery | `arjun`, `x8`, `paramspider` |
| Backup file hunting | `ffuf` with backup wordlists |
| API endpoint brute force | `ffuf`, custom API wordlists |

```bash
# Directory discovery
ffuf -u https://target.com/FUZZ \
  -w wordlists/SecLists/Discovery/Web-Content/raft-medium-directories.txt \
  -ac -mc 200,201,301,302,401,403 \
  -o ffuf-results.json -of json

# Parameter discovery
arjun -u https://target.com/api/endpoint --stable
```

### 2.4 Technology & Stack Fingerprinting

| Task | Recommended Tools |
|------|------------------|
| Tech stack detection | `whatweb`, `wappalyzer`, `httpx -tech-detect` |
| WAF detection | `wafw00f`, `nmap --script http-waf-detect` |
| CMS fingerprinting | `wpscan` (WordPress), `droopescan`, `cmseek` |
| Framework version detection | Manual header analysis, `nuclei` tech templates |
| SSL/TLS analysis | `testssl.sh`, `sslyze`, `sslscan` |

### 2.5 Subdomain Takeover Detection

| Task | Recommended Tools |
|------|------------------|
| Dangling CNAME detection | `subjack`, `subzy`, `nuclei -t takeovers/` |
| Service fingerprint for takeovers | Manual + `nuclei` |
| Cloud resource takeover signals | `cloudbrute`, manual |

```bash
# Takeover scanning
cat subdomains-final.txt | subzy run --targets /dev/stdin
nuclei -l subdomains-final.txt -t nuclei-templates/takeovers/ -silent
```

---

## 🔎 Tier 3 — Deep Surface Intelligence

> **Goal:** Go deep on live assets — extract maximum intelligence from JavaScript, APIs, and cloud infrastructure.

### 3.1 JavaScript Intelligence Mining

JavaScript files are arguably the most information-dense artifact in modern web recon.

| Task | Recommended Tools |
|------|------------------|
| Collect all JS URLs | `gau`, `waybackurls`, `katana` |
| Download & analyze JS files | `getJS`, manual `curl` |
| Extract endpoints from JS | `LinkFinder`, `JSluice`, `xnLinkFinder` |
| Find hardcoded secrets in JS | `trufflehog`, `jsluice`, `secretfinder` |
| Detect hidden parameters | `JSluice`, manual regex analysis |
| Identify internal references | `LinkFinder`, manual analysis |

```bash
# JS mining pipeline
katana -u https://target.com -jc -silent | grep "\.js$" | \
  sort -u | tee js-urls.txt

# Download and extract endpoints
cat js-urls.txt | while read url; do
  curl -sk "$url" | python3 linkfinder.py -i /dev/stdin -o cli
done | sort -u | tee js-endpoints.txt

# Secret scanning
cat js-urls.txt | while read url; do
  curl -sk "$url" > /tmp/jsfile.js
  trufflehog filesystem /tmp/jsfile.js --no-update 2>/dev/null
done
```

### 3.2 API Surface Discovery

| Task | Recommended Tools |
|------|------------------|
| OpenAPI/Swagger spec hunting | `ffuf` + api-docs wordlist, `katana` |
| GraphQL endpoint detection | `graphw00f`, `clairvoyance`, manual |
| GraphQL introspection | `graphql-path-enum`, `InQL` (Burp), manual |
| REST API versioning | Manual analysis, `ffuf` |
| Shadow/undocumented API detection | JS analysis, `arjun`, `kiterunner` |
| API route brute force | `kiterunner`, `ffuf` + API wordlists |

```bash
# API discovery
kr scan https://target.com -w routes-large.kite --output-file api-routes.txt

# GraphQL detection
graphw00f -t https://target.com

# Swagger hunting
ffuf -u https://target.com/FUZZ \
  -w wordlists/api-docs.txt \
  -mc 200 -ac
```

**Common API Doc Paths to Check:**
```
/api/docs
/api/swagger
/swagger.json
/openapi.json
/v1/docs
/v2/api-docs
/graphql
/graphiql
/api/graphql
```

### 3.3 Cloud Surface Intelligence

| Task | Recommended Tools |
|------|------------------|
| S3/GCS/Azure bucket enumeration | `cloud_enum`, `s3scanner`, `GCPBucketBrute` |
| AWS IP range mapping | [ip-ranges.amazonaws.com](https://ip-ranges.amazonaws.com/ip-ranges.json) |
| Cloud metadata endpoint testing | Manual (`169.254.169.254`) |
| Serverless endpoint discovery | JS analysis, `gau`, manual |
| Misconfigured cloud service detection | `nuclei -t cloud/`, Shodan queries |

```bash
# Cloud storage enum
cloud_enum -k "targetcompany" -k "target-corp" -k "targetapp" \
  --disable-azure  # remove flags as needed

# S3 bucket scanner
s3scanner scan --buckets-file company-buckets.txt
```

### 3.4 Trust Boundary Mapping

| Task | Recommended Tools |
|------|------------------|
| OAuth endpoint discovery | Manual, JS analysis |
| SSO flow identification | Manual, `ffuf`, header analysis |
| CORS misconfiguration detection | `corsy`, `nuclei -t cors/`, manual |
| Third-party integrations | JS analysis, `katana`, manual |
| Internal vs external API separation | Manual header/response analysis |

```bash
# CORS testing
python3 corsy.py -i live-hosts.txt -t 10 --headers "Origin: https://evil.com"

# CORS nuclei templates
nuclei -l live-hosts.txt -t nuclei-templates/vulnerabilities/generic/cors-*.yaml
```

---

## ⚙️ Tier 4 — Recon Data Engineering & Automation

> **Goal:** Build pipelines that work while you sleep. Automate the boring parts, monitor for changes.

### 4.1 Pipeline Architecture

Structure your recon as modular, composable pipelines:

```bash
# Example modular pipeline approach
TARGET="target.com"

# Stage 1: Passive subdomain collection
passive_subs() {
  subfinder -d "$1" -silent
  amass enum -passive -d "$1"
  curl -s "https://crt.sh/?q=%25.$1&output=json" | \
    jq -r '.[].name_value' | sed 's/\*\.//g'
}

# Stage 2: DNS resolution
resolve_subs() {
  puredns resolve /dev/stdin \
    -r resolvers.txt \
    --write-massdns massdns-output.txt
}

# Stage 3: HTTP probing
probe_http() {
  httpx -silent -status-code -title -tech-detect \
    -json -o httpx-output.jsonl
}

# Run the full pipeline
passive_subs "$TARGET" | sort -u | resolve_subs | probe_http
```

### 4.2 Essential Pipeline Tools

| Tool | Purpose |
|------|---------|
| `anew` | Append new unique lines only (perfect for diff monitoring) |
| `unfurl` | Parse & extract URL components |
| `qsreplace` | Replace query string values for testing |
| `gf` (Tomnomnom) | Pattern-based grep with pre-built bug patterns |
| `jq` | JSON processing in pipelines |
| `httpx` | Multi-purpose HTTP probing |
| `nuclei` | Template-based automated scanning |
| `notify` | Send pipeline alerts to Slack/Discord/Telegram |

### 4.3 GF Patterns for Recon Output Triage

```bash
# Install gf patterns
git clone https://github.com/1ndianl33t/Gf-Patterns ~/.gf

# Use patterns to triage collected URLs
cat urls-historical.txt | gf xss | tee potential-xss.txt
cat urls-historical.txt | gf sqli | tee potential-sqli.txt
cat urls-historical.txt | gf ssrf | tee potential-ssrf.txt
cat urls-historical.txt | gf redirect | tee potential-redirects.txt
cat urls-historical.txt | gf idor | tee potential-idors.txt
```

### 4.4 Surface Change Monitoring

```bash
# Monitor for new subdomains (run via cron)
#!/bin/bash
TARGET="target.com"
DATE=$(date +%Y%m%d)

subfinder -d "$TARGET" -silent | sort -u > /tmp/subs-today.txt
diff /data/subs-previous.txt /tmp/subs-today.txt | grep "^>" | \
  cut -c3- | notify -bulk -provider telegram

cp /tmp/subs-today.txt /data/subs-previous.txt
```

### 4.5 Wordlist Engineering

Don't just use default wordlists. Build target-specific ones.

| Wordlist Source | Use Case |
|----------------|---------|
| [SecLists](https://github.com/danielmiessler/SecLists) | Foundation for everything |
| [Assetnote Wordlists](https://wordlists.assetnote.io) | API paths, cloud assets, tech-specific |
| [CommonSpeak2](https://github.com/assetnote/commonspeak2) | Generated from real web data |
| `cewl` | Generate custom wordlist from target website |
| Manual target keywords | Extract terms from JS, about page, docs |

```bash
# Build target-specific wordlist
cewl https://target.com -d 3 -m 5 | sort -u > target-wordlist.txt
```

---

## 🧭 Tier 5 — Strategic Surface Dominance

> **Goal:** Make your recon data actionable. Know where to spend your time.

### 5.1 High-Value Asset Prioritization

Not all attack surface is equal. Prioritize:

| Signal | Why It's High Value |
|--------|---------------------|
| Old subdomains / legacy endpoints | Less maintained = more bugs |
| Admin panels & internal tools | Elevated privilege = bigger impact |
| API endpoints without versioning | Likely undocumented, less tested |
| Third-party integrations | OAuth flows, webhook endpoints |
| Mobile API backends | Often different security posture |
| Recently acquired domains | New code, old infrastructure |
| Custom 404/403 pages | Can indicate backend framework |
| Subdomains with open ports (non-80/443) | Attack surface often ignored |

### 5.2 Pattern Recognition in Recon Data

```bash
# Find interesting patterns in collected URLs
cat urls-historical.txt | unfurl paths | sort | uniq -c | sort -rn | head -50

# Find unique parameter names
cat urls-historical.txt | unfurl keys | sort -u | tee params.txt

# Find endpoints with multiple parameters (more attack surface)
cat urls-historical.txt | grep -E "(\?|&).+=.+&.+=.+" | sort -u

# Find admin/internal paths
cat urls-historical.txt | grep -Ei "(admin|internal|manage|staff|panel|dashboard|portal|backstage)"
```

### 5.3 Recon Data Correlation

| Cross-reference | Insight |
|----------------|---------|
| ASN IP ranges ↔ open ports | Unlinked assets in scope |
| JS endpoints ↔ active brute force results | Confirm discovered routes |
| Historical URLs ↔ live endpoints | Resurface deprecated endpoints |
| Cloud storage names ↔ subdomains | Naming pattern = more buckets |
| GitHub secrets ↔ discovered APIs | Validate leaked credentials |

### 5.4 Exploitation Handoff Packaging

When you're done with recon, organize findings for exploitation:

```
targets/target.com/
├── recon-summary.md          ← High-level findings overview
├── subdomains-live.txt       ← Verified live subdomains
├── interesting-urls.txt      ← URLs worth manual testing
├── js-endpoints.txt          ← Extracted JS endpoints
├── api-routes.txt            ← Discovered API routes
├── open-ports.txt            ← Non-standard open ports
├── tech-stack.md             ← Technology fingerprinting notes
├── secrets-found.txt         ← Any exposed secrets (handle carefully)
├── screenshots/              ← Gowitness screenshots
└── notes.md                  ← Manual observations
```

---

## 🛠️ Tools Index

### Installation Quick Reference

```bash
# Go tools (install all at once)
go install github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest
go install github.com/projectdiscovery/httpx/cmd/httpx@latest
go install github.com/projectdiscovery/nuclei/v2/cmd/nuclei@latest
go install github.com/projectdiscovery/naabu/v2/cmd/naabu@latest
go install github.com/projectdiscovery/dnsx/cmd/dnsx@latest
go install github.com/projectdiscovery/katana/cmd/katana@latest
go install github.com/projectdiscovery/notify/cmd/notify@latest
go install github.com/tomnomnom/assetfinder@latest
go install github.com/tomnomnom/waybackurls@latest
go install github.com/tomnomnom/anew@latest
go install github.com/tomnomnom/unfurl@latest
go install github.com/tomnomnom/qsreplace@latest
go install github.com/tomnomnom/gf@latest
go install github.com/lc/gau/v2/cmd/gau@latest
go install github.com/dwisiswant0/gowitness@latest
go install github.com/s0md3v/Smap/cmd/smap@latest
go install github.com/pry0cc/axiom/cmd/axiom@latest
go install github.com/haccer/subjack@latest
go install github.com/PentestPad/subzy@latest
```

### Full Tools Reference Table

| Tool | Category | Purpose | Link |
|------|----------|---------|------|
| `subfinder` | Passive Subdomain | Passive subdomain enumeration | [ProjectDiscovery](https://github.com/projectdiscovery/subfinder) |
| `amass` | Subdomain | Active + passive subdomain enum | [OWASP](https://github.com/OWASP/Amass) |
| `assetfinder` | Passive Subdomain | Fast subdomain discovery | [tomnomnom](https://github.com/tomnomnom/assetfinder) |
| `puredns` | DNS | Reliable DNS brute force + resolution | [d3mondev](https://github.com/d3mondev/puredns) |
| `shuffledns` | DNS | Subdomain brute force with massdns | [ProjectDiscovery](https://github.com/projectdiscovery/shuffledns) |
| `dnsx` | DNS | Multi-purpose DNS toolkit | [ProjectDiscovery](https://github.com/projectdiscovery/dnsx) |
| `massdns` | DNS | High-performance DNS stub resolver | [blechschmidt](https://github.com/blechschmidt/massdns) |
| `altdns` | DNS Permutation | Subdomain permutation generator | [infosec-au](https://github.com/infosec-au/altdns) |
| `gotator` | DNS Permutation | Subdomain permutation engine | [Josue87](https://github.com/Josue87/gotator) |
| `httpx` | HTTP Probing | Multi-purpose HTTP toolkit | [ProjectDiscovery](https://github.com/projectdiscovery/httpx) |
| `naabu` | Port Scanning | Fast port scanner | [ProjectDiscovery](https://github.com/projectdiscovery/naabu) |
| `nmap` | Port Scanning | Classic port + service scanner | [nmap.org](https://nmap.org) |
| `ffuf` | Fuzzing | Fast web fuzzer | [ffuf](https://github.com/ffuf/ffuf) |
| `feroxbuster` | Content Discovery | Recursive content discovery | [epi052](https://github.com/epi052/feroxbuster) |
| `gobuster` | Content Discovery | Directory/vhost/DNS brute force | [OJ](https://github.com/OJ/gobuster) |
| `katana` | Crawling | Next-gen web crawler | [ProjectDiscovery](https://github.com/projectdiscovery/katana) |
| `gau` | URL Collection | Get all URLs from archives | [lc](https://github.com/lc/gau) |
| `waybackurls` | URL Collection | Wayback Machine URL fetcher | [tomnomnom](https://github.com/tomnomnom/waybackurls) |
| `waymore` | URL Collection | Extended URL collection tool | [xnl-h4ck3r](https://github.com/xnl-h4ck3r/waymore) |
| `nuclei` | Scanning | Template-based vulnerability scanner | [ProjectDiscovery](https://github.com/projectdiscovery/nuclei) |
| `gowitness` | Screenshots | Web screenshot utility | [sensepost](https://github.com/sensepost/gowitness) |
| `aquatone` | Screenshots | Visual recon tool | [michenriksen](https://github.com/michenriksen/aquatone) |
| `LinkFinder` | JS Analysis | Find endpoints in JS files | [GerbenJavado](https://github.com/GerbenJavado/LinkFinder) |
| `JSluice` | JS Analysis | JS secrets + endpoint extractor | [BishopFox](https://github.com/BishopFox/jsluice) |
| `xnLinkFinder` | JS Analysis | Advanced link finder | [xnl-h4ck3r](https://github.com/xnl-h4ck3r/xnLinkFinder) |
| `secretfinder` | Secret Detection | Find secrets in JS | [m4ll0k](https://github.com/m4ll0k/SecretFinder) |
| `trufflehog` | Secret Detection | Git + file secret scanner | [trufflesecurity](https://github.com/trufflesecurity/trufflehog) |
| `gitleaks` | Secret Detection | Git history secret scanner | [gitleaks](https://github.com/gitleaks/gitleaks) |
| `arjun` | Parameter Discovery | HTTP parameter discovery | [s0md3v](https://github.com/s0md3v/Arjun) |
| `x8` | Parameter Discovery | Hidden parameter discovery | [sh1yo](https://github.com/sh1yo/x8) |
| `paramspider` | Parameter Discovery | Parameter mining from Wayback | [devanshbatham](https://github.com/devanshbatham/paramspider) |
| `kiterunner` | API Discovery | API route brute force | [assetnote](https://github.com/assetnote/kiterunner) |
| `graphw00f` | GraphQL | GraphQL engine fingerprinting | [nicowillis](https://github.com/nicowillis/graphw00f) |
| `cloud_enum` | Cloud | Multi-cloud asset enumeration | [initstring](https://github.com/initstring/cloud_enum) |
| `s3scanner` | Cloud | S3 bucket scanner | [sa7mon](https://github.com/sa7mon/S3Scanner) |
| `subzy` | Takeover | Subdomain takeover detection | [PentestPad](https://github.com/PentestPad/subzy) |
| `subjack` | Takeover | Subdomain takeover checker | [haccer](https://github.com/haccer/subjack) |
| `corsy` | CORS | CORS misconfiguration scanner | [s0md3v](https://github.com/s0md3v/Corsy) |
| `wafw00f` | WAF | WAF detection | [EnableSecurity](https://github.com/EnableSecurity/wafw00f) |
| `testssl.sh` | TLS | SSL/TLS configuration testing | [testssl.sh](https://github.com/drwetter/testssl.sh) |
| `whatweb` | Fingerprinting | Web technology fingerprinter | [urbanadventurer](https://github.com/urbanadventurer/WhatWeb) |
| `gf` | Triage | Pattern-based URL triage | [tomnomnom](https://github.com/tomnomnom/gf) |
| `anew` | Pipeline | Append new unique lines | [tomnomnom](https://github.com/tomnomnom/anew) |
| `unfurl` | Pipeline | URL component parser | [tomnomnom](https://github.com/tomnomnom/unfurl) |
| `qsreplace` | Pipeline | Query string replacement | [tomnomnom](https://github.com/tomnomnom/qsreplace) |
| `notify` | Alerting | Pipeline notification sender | [ProjectDiscovery](https://github.com/projectdiscovery/notify) |
| `cewl` | Wordlist | Custom wordlist generator | [digininja](https://github.com/digininja/CeWL) |
| `theHarvester` | OSINT | Email, domain, IP OSINT | [laramies](https://github.com/laramies/theHarvester) |
| `asnmap` | ASN | ASN to IP range mapper | [ProjectDiscovery](https://github.com/projectdiscovery/asnmap) |

---

## 📋 Recon Checklist (Quick Reference)

```
PRE-RECON
  [ ] Understand scope (in-scope domains, IPs, exclusions)
  [ ] Set up organized folder structure
  [ ] Configure resolvers.txt with valid DNS resolvers

TIER 1 — PASSIVE
  [ ] Passive subdomain enum (subfinder, amass, assetfinder)
  [ ] Certificate transparency (crt.sh, certspotter)
  [ ] ASN & IP range discovery
  [ ] Google dorking
  [ ] GitHub/GitLab secret hunting
  [ ] Historical URL collection (gau, waybackurls)
  [ ] Cloud storage enumeration
  [ ] Document metadata (if applicable)

TIER 2 — ACTIVE
  [ ] DNS resolution of all collected subdomains
  [ ] HTTP probing (httpx)
  [ ] Port scanning (naabu / nmap)
  [ ] Screenshots (gowitness)
  [ ] Directory/file brute force on interesting targets
  [ ] Virtual host brute force
  [ ] Technology fingerprinting
  [ ] Subdomain takeover scanning

TIER 3 — DEEP
  [ ] Collect all JavaScript URLs
  [ ] Extract endpoints from JS
  [ ] Hunt for secrets in JS
  [ ] API documentation hunting
  [ ] GraphQL detection + introspection
  [ ] Cloud bucket deep dive
  [ ] CORS testing
  [ ] Parameter discovery on key endpoints

TIER 4 — AUTOMATION
  [ ] Set up change monitoring (new subdomains, new endpoints)
  [ ] Triage URLs with gf patterns
  [ ] Deduplicate and organize all findings
  [ ] Build target-specific wordlist

TIER 5 — STRATEGY
  [ ] Prioritize high-value assets
  [ ] Cross-reference findings
  [ ] Create handoff package
  [ ] Document anomalies and interesting observations
```

---

## 📖 Documentation

| Document | Description |
|----------|-------------|
| [FRAMEWORK.md](./FRAMEWORK.md) | Complete framework structure at a glance |
| [TOOLS.md](./TOOLS.md) | Detailed tool installation & usage |
| [CHECKLIST.md](./CHECKLIST.md) | Printable per-engagement checklist |
| [docs/passive-recon.md](./docs/passive-recon.md) | Passive recon deep dive |
| [docs/active-recon.md](./docs/active-recon.md) | Active recon deep dive |
| [docs/js-analysis.md](./docs/js-analysis.md) | JavaScript mining guide |
| [docs/api-recon.md](./docs/api-recon.md) | API surface discovery |
| [docs/cloud-recon.md](./docs/cloud-recon.md) | Cloud & bucket enumeration |
| [docs/automation.md](./docs/automation.md) | Pipeline automation guide |

---

## 🤝 Contributing

Contributions are welcome! If you know a better tool, a missing technique, or a cleaner approach:

1. Fork the repo
2. Create a branch (`git checkout -b feature/add-cloud-recon-tip`)
3. Make your changes
4. Submit a Pull Request

Please follow the existing formatting and keep the focus on **recon only**.

---

## 📚 Recommended Learning Resources

| Resource | Type |
|----------|------|
| [Bug Bounty Bootcamp (book)](https://nostarch.com/bug-bounty-bootcamp) | Book |
| [HackerOne Hacker101](https://www.hacker101.com) | Free course |
| [TryHackMe — Web Fundamentals](https://tryhackme.com) | Labs |
| [Nahamsec's Live Recons (YouTube)](https://www.youtube.com/@NahamSec) | Video |
| [STÖK's videos (YouTube)](https://www.youtube.com/@STOKfredrik) | Video |
| [ProjectDiscovery Blog](https://blog.projectdiscovery.io) | Blog |
| [intigriti Blog](https://blog.intigriti.com) | Blog |
| [pentester.land writeups](https://pentester.land/list-of-bug-bounty-writeups.html) | Writeups |

---

## 🪪 License

MIT License — see [LICENSE](./LICENSE) for details.

---

<div align="center">

**If this framework helped you, give it a ⭐ — it helps others find it.**

Made for the community. Use it ethically.

</div>
