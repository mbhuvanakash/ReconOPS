# Scope Notes — [Target Name]

**Program:** [HackerOne / Bugcrowd / Intigriti / private]
**Program URL:** 
**Started:**
**Last Updated:**

---

## In Scope

```
# Domains
*.target.com
api.target.com

# IP Ranges
x.x.x.x/24

# Mobile Apps
com.target.android
com.target.ios
```

## Out of Scope

```
# Explicitly excluded
cdn.target.com
status.target.com
blog.target.com   # WordPress, not custom code

# Excluded issue types
- DoS / DDoS
- Social engineering
- Physical attacks
- Self-XSS

# Excluded behaviors
- Rate limiting without security impact
- Missing security headers (without demonstrated impact)
- CSRF on logout
```

---

## 🔍 Assets Discovered (Beyond Listed Scope)

Track assets you found that weren't explicitly listed. You may need to confirm if they're in scope.

| Asset | Type | Discovered Via | Scope Confirmed? |
|-------|------|---------------|-----------------|
| mail.target.com | subdomain | subfinder | ask |
| target-staging.com | domain | GitHub | ask |

---

## Program Notes

- Max severity: Critical
- Needs PoC: Yes
- Response time: ~3 business days
- Preferred report format: [notes here]
- Special instructions: [notes here]

---

## Recon Observations

- Main tech stack: [e.g., Node.js, React, AWS]
- CDN: [Cloudflare / Akamai / none]
- WAF: [Cloudflare / ModSecurity / none detected]
- Interesting assets: [notes]
- Potential entry points: [notes]
