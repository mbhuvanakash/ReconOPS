# ReconOps Engagement Checklist

> Copy this file for each new engagement. Check off as you go.

---

## Target Info

```
Program:        ___________________________
Platform:       ___________________________  (HackerOne / Bugcrowd / Intigriti / etc.)
Date Started:   ___________________________
Primary Domain: ___________________________
Scope Notes:    ___________________________
Out of Scope:   ___________________________
```

---

## ✅ TIER 0 — Infrastructure Cognition

> Complete once per new target type. Skip if already familiar.

- [ ] Reviewed DNS record types relevant to target
- [ ] Understood CDN/proxy setup (Cloudflare? Akamai? Direct?)
- [ ] Identified if target uses load balancing or reverse proxies
- [ ] Reviewed HTTP headers on main domain with `curl -I`
- [ ] Checked CORS headers on main domain

---

## ✅ TIER 1 — Passive Recon

### Organizational Footprint
- [ ] Identified parent company and subsidiaries
- [ ] Searched for M&A history
- [ ] Listed all known domains owned by the organization
- [ ] Checked for trademark/brand assets (USPTO, etc.)

### Subdomain Discovery (Passive)
- [ ] `subfinder -d target.com`
- [ ] `amass enum -passive -d target.com`
- [ ] `assetfinder --subs-only target.com`
- [ ] Certificate transparency: `crt.sh`
- [ ] `theHarvester -d target.com -b all`
- [ ] ProjectDiscovery Chaos (if available)
- [ ] SecurityTrails manual lookup
- [ ] VirusTotal subdomain lookup
- [ ] Combined and deduplicated all results → `subdomains-passive.txt`

### Code & Secret Hunting
- [ ] GitHub search: `"target.com"` + `"target"` org
- [ ] `trufflehog github --org=targetorg`
- [ ] `gitleaks` on any found repos
- [ ] Google dork: `site:github.com "target.com" password OR secret OR key`
- [ ] Google dork: `site:target.com ext:env OR ext:yml OR ext:config`
- [ ] Checked Pastebin / psbdmp

### Cloud Storage
- [ ] `cloud_enum -k target -k targetcompany`
- [ ] `s3scanner` with generated bucket name list
- [ ] Checked for Firebase exposure

### Historical URLs
- [ ] `gau target.com` → `urls-gau.txt`
- [ ] `waybackurls target.com` → `urls-wayback.txt`
- [ ] `waymore -i target.com` → `urls-waymore.txt`
- [ ] Combined → `urls-historical.txt`
- [ ] Filtered for interesting extensions: `.js .json .env .yml .config .php .asp .aspx`

---

## ✅ TIER 2 — Active Recon

> ⚠️ Confirm scope before running any active tools.

### Live Asset Validation
- [ ] `dnsx` to resolve all passive subdomains → `subdomains-resolved.txt`
- [ ] `httpx` to probe live HTTP/S hosts → `hosts-live.txt`
- [ ] `naabu` port scan on resolved hosts → `open-ports.txt`
- [ ] `gowitness` screenshots on all live hosts → `screenshots/`
- [ ] Reviewed screenshots for interesting targets

### Active Subdomain Enumeration
- [ ] `puredns bruteforce` with SecLists subdomain wordlist
- [ ] `gotator` permutation generation + `puredns resolve`
- [ ] Virtual host brute force on interesting IPs
- [ ] Combined all → `subdomains-all.txt`

### Web Content Discovery (on interesting targets)
- [ ] `ffuf` directory brute force (raft-medium-directories)
- [ ] `ffuf` file brute force (raft-medium-files)
- [ ] Backup file wordlist (`backup`, `.bak`, `.old`, `~`)
- [ ] `arjun` parameter discovery on interesting endpoints

### Fingerprinting
- [ ] `whatweb` on all live hosts
- [ ] `wafw00f` on in-scope domains
- [ ] Checked SSL/TLS with `testssl.sh` or `sslscan` on interesting targets
- [ ] `nuclei -t technologies/` on live hosts

### Subdomain Takeover
- [ ] `subzy run --targets subdomains-all.txt`
- [ ] `nuclei -l subdomains-all.txt -t nuclei-templates/takeovers/`
- [ ] Manually reviewed dangling CNAMEs

---

## ✅ TIER 3 — Deep Intelligence

### JavaScript Mining
- [ ] `katana -u https://target.com -jc` to collect JS URLs
- [ ] Combined with JS from `gau` + `waybackurls`
- [ ] Deduplicated JS URLs → `js-files.txt`
- [ ] `LinkFinder` or `JSluice` on all JS files
- [ ] `secretfinder` / `trufflehog` on all JS files
- [ ] Reviewed output for hardcoded secrets
- [ ] Reviewed output for internal endpoints → `js-endpoints.txt`

### API Discovery
- [ ] Checked common API doc paths manually
- [ ] `kiterunner` API route brute force
- [ ] `ffuf` with API wordlists on API subdomains
- [ ] `graphw00f` on all targets for GraphQL detection
- [ ] If GraphQL found: introspection query
- [ ] Checked for versioned API endpoints (`/v1`, `/v2`, `/api/v3`)

### Cloud Deep Dive
- [ ] Deeper bucket enumeration with target naming patterns
- [ ] `nuclei -t cloud/` on live hosts
- [ ] Checked Shodan for target ASN
- [ ] Reviewed Censys for target certificate data

### Trust Boundaries
- [ ] `corsy` CORS scan on all live hosts
- [ ] Reviewed OAuth flows present in JS
- [ ] Identified SSO endpoints
- [ ] Mapped third-party integrations

---

## ✅ TIER 4 — Data Organization

- [ ] All subdomains deduplicated and organized
- [ ] All URLs deduplicated and organized
- [ ] `gf xss` → `potential-xss.txt`
- [ ] `gf sqli` → `potential-sqli.txt`
- [ ] `gf ssrf` → `potential-ssrf.txt`
- [ ] `gf redirect` → `potential-redirects.txt`
- [ ] `gf idor` → `potential-idors.txt`
- [ ] `unfurl` analysis on URL parameters
- [ ] Set up change monitoring (if ongoing engagement)

---

## ✅ TIER 5 — Strategic Review

- [ ] Reviewed all screenshots for high-value targets
- [ ] Identified admin/internal panels
- [ ] Prioritized targets by likely impact
- [ ] Correlated findings across sources
- [ ] Noted anomalies and unusual observations
- [ ] Created handoff notes

---

## 📁 Output File Reference

```
engagement-target.com/
├── subdomains-passive.txt          ← Passive subdomain results
├── subdomains-resolved.txt         ← DNS-resolved subdomains
├── subdomains-all.txt              ← All subdomains combined
├── hosts-live.txt                  ← Verified live HTTP hosts
├── open-ports.txt                  ← Port scan results
├── urls-historical.txt             ← Historical URL collection
├── js-files.txt                    ← JS file URLs
├── js-endpoints.txt                ← Extracted JS endpoints
├── api-routes.txt                  ← API routes found
├── potential-xss.txt               ← GF pattern: XSS candidates
├── potential-sqli.txt              ← GF pattern: SQLi candidates
├── potential-ssrf.txt              ← GF pattern: SSRF candidates
├── potential-redirects.txt         ← GF pattern: Open redirect candidates
├── potential-idors.txt             ← GF pattern: IDOR candidates
├── screenshots/                    ← Gowitness screenshots
└── notes.md                        ← Manual observations & priority targets
```
