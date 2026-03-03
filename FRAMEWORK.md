# ReconOps Framework — Full Structure

> Quick reference for the complete framework. See README.md for full detail.

```
ReconOps Bug Bounty Recon Framework
│
├── TIER 0: Pre-Recon Infrastructure Cognition
│   │   [Learn this. Don't skip it. Everything else depends on it.]
│   │
│   ├── DNS Fundamentals
│   │   ├── Record types: A, CNAME, MX, TXT, NS, PTR
│   │   ├── DNS resolution chain & TTL behavior
│   │   ├── Wildcard DNS detection
│   │   └── Tools: dig, nslookup, host, dnsx
│   │
│   ├── ASN & IP Ownership Mapping
│   │   ├── ASN lookups → discover IP ranges owned by target
│   │   ├── WHOIS / RDAP for domain + IP ownership
│   │   ├── Reverse DNS (PTR) record mapping
│   │   └── Tools: asnmap, whois, bgp.he.net, ipinfo.io
│   │
│   ├── CDN & Reverse Proxy Awareness
│   │   ├── CDN detection (Cloudflare, Akamai, Fastly, Cloudfront)
│   │   ├── Origin IP leakage identification
│   │   ├── Load balancer behavioral analysis
│   │   └── Tools: curl -I, Shodan, Censys, SecurityTrails
│   │
│   └── HTTP Behavioral Basics
│       ├── Response header fingerprinting
│       ├── Status code analysis (200/301/302/403/404/429)
│       ├── CORS header analysis
│       └── Cache layer identification (X-Cache, Age, Via)
│
├── TIER 1: Passive Surface Intelligence
│   │   [Collect maximum data without touching the target]
│   │
│   ├── Organizational Footprint Mapping
│   │   ├── Parent company / subsidiary graph building
│   │   ├── M&A historical footprint discovery
│   │   ├── Brand & trademark asset clustering
│   │   └── Tools: Crunchbase, LinkedIn, amass intel, WhoisXMLAPI
│   │
│   ├── Subdomain Discovery (Passive)
│   │   ├── Certificate Transparency log mining (crt.sh)
│   │   ├── Passive DNS correlation
│   │   ├── Historical DNS diffing
│   │   └── Tools: subfinder, amass, assetfinder, theHarvester, chaos
│   │
│   ├── Public Code & Secret Exposure
│   │   ├── GitHub / GitLab intelligence mining
│   │   ├── Exposed credentials & API key detection
│   │   ├── Google dorking
│   │   └── Tools: trufflehog, gitleaks, gitdorker, gitrob
│   │
│   ├── Cloud Storage Exposure
│   │   ├── S3 bucket enumeration & access testing
│   │   ├── Azure Blob / GCP Storage discovery
│   │   ├── Firebase exposure detection
│   │   └── Tools: cloud_enum, s3scanner, GCPBucketBrute
│   │
│   └── Historical Surface Recovery
│       ├── Wayback Machine URL mining
│       ├── Deprecated & legacy endpoint resurfacing
│       ├── Old JS file recovery
│       └── Tools: gau, waybackurls, waymore
│
├── TIER 2: Active Surface Expansion
│   │   [Probe live infrastructure — only on authorized targets]
│   │
│   ├── Live Asset Validation
│   │   ├── DNS resolution of collected subdomains
│   │   ├── HTTP/S probing & status codes
│   │   ├── Port scanning & service identification
│   │   └── Tools: dnsx, httpx, naabu, nmap, gowitness
│   │
│   ├── Subdomain Enumeration (Active/Brute)
│   │   ├── DNS brute force
│   │   ├── Permutation & alteration-based discovery
│   │   ├── Virtual host enumeration
│   │   └── Tools: puredns, shuffledns, altdns, gotator, ffuf
│   │
│   ├── Web Content Discovery
│   │   ├── Directory & file brute force
│   │   ├── Parameter space discovery
│   │   ├── Backup file detection
│   │   └── Tools: ffuf, feroxbuster, gobuster, arjun, x8
│   │
│   ├── Technology & Stack Fingerprinting
│   │   ├── Framework & CMS detection
│   │   ├── WAF identification
│   │   ├── SSL/TLS configuration analysis
│   │   └── Tools: whatweb, wafw00f, wpscan, testssl.sh, nuclei
│   │
│   └── Subdomain Takeover Detection
│       ├── Dangling CNAME identification
│       ├── Vulnerable service fingerprinting
│       └── Tools: subzy, subjack, nuclei -t takeovers/
│
├── TIER 3: Deep Surface Intelligence
│   │   [Go deep on live assets]
│   │
│   ├── JavaScript Intelligence Mining
│   │   ├── Collect all JS file URLs
│   │   ├── Endpoint extraction from JS
│   │   ├── Hardcoded secret detection
│   │   ├── Hidden parameter identification
│   │   └── Tools: katana, LinkFinder, JSluice, xnLinkFinder, secretfinder
│   │
│   ├── API Surface Discovery
│   │   ├── OpenAPI/Swagger spec hunting
│   │   ├── GraphQL detection & introspection
│   │   ├── REST API version discovery
│   │   ├── Shadow/undocumented API detection
│   │   └── Tools: kiterunner, graphw00f, ffuf, InQL, arjun
│   │
│   ├── Cloud Surface Intelligence
│   │   ├── Deep bucket enumeration
│   │   ├── AWS/GCP/Azure IP range mapping
│   │   ├── Misconfigured cloud service detection
│   │   ├── Serverless endpoint discovery
│   │   └── Tools: cloud_enum, s3scanner, nuclei -t cloud/, Shodan
│   │
│   └── Trust Boundary Mapping
│       ├── OAuth flow identification
│       ├── SSO trust domain discovery
│       ├── CORS misconfiguration detection
│       ├── Third-party integration mapping
│       └── Tools: corsy, nuclei -t cors/, manual analysis
│
├── TIER 4: Recon Data Engineering & Automation
│   │   [Make your recon work while you sleep]
│   │
│   ├── Modular Pipeline Architecture
│   │   └── Chain: passive → resolve → probe → screenshot → deep-dive
│   │
│   ├── Signal-to-Noise Reduction
│   │   └── Tools: anew, gf patterns, httpx filters, nuclei severity filters
│   │
│   ├── URL Triage with GF Patterns
│   │   └── Patterns: xss, sqli, ssrf, redirect, idor, lfi, rce
│   │
│   ├── Wordlist Engineering
│   │   └── Sources: SecLists, Assetnote, CommonSpeak2, cewl (target-specific)
│   │
│   ├── Continuous Monitoring
│   │   └── Tools: anew + cron + notify (Slack/Discord/Telegram)
│   │
│   └── Data Processing
│       └── Tools: jq, unfurl, qsreplace, sort, uniq, grep, awk
│
└── TIER 5: Strategic Surface Dominance
    │   [Turn data into decisions]
    │
    ├── High-Value Asset Prioritization
    │   └── Focus: legacy assets, admin panels, APIs, third-party integrations
    │
    ├── Cross-Source Data Correlation
    │   └── Link: ASN data ↔ open ports ↔ JS endpoints ↔ secrets
    │
    ├── Pattern Recognition in Large Datasets
    │   └── Tools: unfurl, sort | uniq -c, manual analysis
    │
    ├── Attack Surface Gap Identification
    │   └── Find what automated tools missed
    │
    └── Exploitation Handoff Packaging
        └── Organized, annotated, prioritized findings package
```

---

## Tier-by-Tier Summary

| Tier | Name | Sends Traffic? | Primary Output |
|------|------|---------------|----------------|
| 0 | Infrastructure Cognition | No | Knowledge foundation |
| 1 | Passive Intelligence | No | Subdomains, secrets, URLs |
| 2 | Active Expansion | Yes (light) | Live hosts, ports, content |
| 3 | Deep Intelligence | Yes | JS endpoints, APIs, cloud assets |
| 4 | Data Engineering | Depends | Automated pipelines, monitoring |
| 5 | Strategic Dominance | No | Prioritized, actionable intelligence |
