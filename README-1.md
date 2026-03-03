# Wordlists for ReconOps

This directory is intentionally empty. Wordlists are not distributed with this repository due to size.

## Recommended Sources

### 🏆 Essential: SecLists
The go-to wordlist collection for web security.
```bash
git clone https://github.com/danielmiessler/SecLists.git
```

**Key files from SecLists:**
| File | Use Case |
|------|---------|
| `Discovery/DNS/subdomains-top1million-5000.txt` | Subdomain brute force (fast) |
| `Discovery/DNS/subdomains-top1million-110000.txt` | Subdomain brute force (thorough) |
| `Discovery/Web-Content/raft-medium-directories.txt` | Directory discovery |
| `Discovery/Web-Content/raft-medium-files.txt` | File discovery |
| `Discovery/Web-Content/api/api-endpoints.txt` | API endpoint discovery |
| `Discovery/Web-Content/common.txt` | Quick content discovery |
| `Passwords/Common-Credentials/10-million-password-list-top-100000.txt` | Credential testing |

### 🎯 Assetnote Wordlists (Tech-Specific)
Best wordlists for API paths, cloud assets, and framework-specific paths.
- Download: https://wordlists.assetnote.io/
- Especially useful: `httparchive_apiroutes_*.txt`

### 📊 CommonSpeak2
Generated from real web crawl data — more relevant than random words.
- https://github.com/assetnote/commonspeak2-wordlists

### 🔧 Build Your Own
```bash
# Extract words from target website
cewl https://target.com -d 3 -m 5 -w target-custom.txt

# Extract parameters from historical URLs
cat ../output/target.com/urls-historical.txt | \
  unfurl keys | sort | uniq -c | sort -rn | \
  awk '{print $2}' > target-params.txt

# Build subdomain permutations from known subdomains
cat known-subs.txt | sed "s/\.target\.com//" > subnames.txt
# Then use gotator or altdns with these names
```

### ✅ Resolver Lists
For `puredns` and `shuffledns` you need a valid resolver list:
```bash
# Download reliable public DNS resolvers
curl -s https://raw.githubusercontent.com/trickest/resolvers/main/resolvers.txt \
  -o resolvers.txt

# Or from proabiral's list
curl -s https://raw.githubusercontent.com/proabiral/Fresh-Resolvers/master/resolvers.txt \
  -o resolvers.txt
```

## Directory Structure (after setup)

```
wordlists/
├── README.md                    ← This file
├── resolvers.txt                ← DNS resolvers for puredns/shuffledns
├── SecLists/                    ← git clone from above
├── assetnote/                   ← Downloaded from wordlists.assetnote.io
└── custom/
    ├── target-keywords.txt      ← Per-target custom words
    └── target-params.txt        ← Parameters extracted from URLs
```
