
# DomainSRV

**DomainSRV** is a professional, lab-focused SRV record enumeration toolkit for Active Directory and network reconnaissance.  
It performs fast, parallel SRV lookups (tunable concurrency), supports AXFR attempts, common AD/service-focused scans, brute-prefix probing, custom queries, and a full IANA-backed SRV enumeration mode (lab-only). Results are resolved, grouped, logged and exportable for post-processing and reporting.

> ⚠️ **For authorized use only.** DomainSRV includes noisy actions (AXFR, large-scale IANA scans). Use exclusively in labs or environments where you have explicit permission.

---

## Key features

- Parallel SRV enumeration using configurable worker/concurrency settings.
- Multiple operation modes:
  - AXFR (zone transfer, explicit confirmation)
  - Common AD SRV queries (LDAP, Kerberos, GC, etc.)
  - Brute-prefix SRV probing (useful to find unexpected services)
  - Custom SRV lists (interactive)
  - Full IANA SRV enumeration (heavy; lab-only)
- Automatic resolution of discovered targets and /24 subnet inference.
- Timestamped session directories: `found.txt`, `notfound.txt`, `resolved.csv`, `session.log`.
- Exportable human-readable reports.
- Safe-by-default settings (short DNS timeouts, confirmations for noisy actions).
- Fallbacks: prefers `dnspython` when available, otherwise falls back to `dig` for compatibility.
- Useful for CRTP practice labs, AD recon, red-team reconnaissance (authorized), and teaching.

---

## Screenshots / Example output (terminal)



[FOUND] _ldap._tcp.example.local -> 0 100 389 dc01.example.local.
[NOTFOUND] _mssql._tcp.example.local
[FOUND] _http._tcp.web.example.local -> 0 5 80 web01.example.local.
Resolved: web01.example.local -> 192.168.100.10 (subnet: 192.168.100.0/24)
Session saved: /tmp/domainsrv_example.local_20250922-143512/


---

## Requirements

- Python 3.8+ (for the Python edition) *or* Bash + `dig` (for the shell edition)
- Recommended (Python): `dnspython` (`pip install dnspython`) — the script will use `dig` if dnspython is not present.
- Utilities (if using the shell flavor): `dig`, `curl`, `xargs`, `awk`, `sed`, `nmap` (optional)
- Designed for Linux-based environments (Kali, Ubuntu, etc.)

---

## Installation

**Quick (Python script):**

```bash
# place DomainSRV.py in your PATH or a repo folder and make executable:
chmod +x DomainSRV.py
./DomainSRV.py


Install dnspython (recommended):

python3 -m pip install --user dnspython


Shell script version:

Save DomainSRV.sh, make executable and run:

chmod +x DomainSRV.sh
./DomainSRV.sh

Usage examples
Interactive (recommended)

Run the script and follow prompts:

./DomainSRV.py
# Enter DNS server, domain, choose concurrency, then select actions from menu

Non-interactive (headless/use-case)

(If you add a headless mode) call with flags:

python3 DomainSRV.py --server 192.168.100.83 --domain example.local --mode common --workers 30 --export ./report.txt

Typical workflow

Start DomainSRV and set workers (e.g., 10–50 depending on lab capacity).

Run Enumerate common AD SRVs to quickly find LDAP/Kerberos/GC endpoints.

Use Resolve discovered targets to get IPs and infer subnets.

Optionally run Brute-prefix or Custom queries to expand coverage.

Save/export the session report for documentation.

Output & session folders

By default DomainSRV stores session artifacts in a timestamped directory under /tmp, for example:

/tmp/domainsrv_example.local_20250922-143512/
  ├─ found.txt         # one-line per found SRV record
  ├─ notfound.txt      # probed but not found
  ├─ resolved.csv      # host,ip pairs for resolved targets
  └─ session.log       # timestamped log of actions and results


export_report() will combine these into a single human-readable file.

Safety, ethics & best practices

Only run DomainSRV where you are authorized. Attempting AXFR or mass enumeration against external/production DNS servers may be considered hostile activity.

Use conservative worker counts on shared networks (start at 5–10). Increase only in isolated lab networks.

DomainSRV shortens DNS timeouts to speed up failed lookups; if you run against slow DNS servers, increase timeouts to avoid false negatives.

Keep full IANA enumeration limited to controlled lab environments.

Contributing

Contributions welcome. Some ideas for improvements:

Add a formal headless CLI (--server, --domain, --mode, --workers, --export).

Add CSV/JSON outputs and a Markdown/HTML report export.

BloodHound integration or SPN extraction for Kerberos workflow.

Add adaptive throttling/backoff to avoid DNS overload.

To contribute:

Fork the repo

Create a feature branch feature/your-feature

Submit PR with tests and README updates

License

Suggested: MIT License (permissive and commonly used for tooling).

MIT License
Copyright (c) YEAR YOURNAME
Permission is hereby granted...


(Replace with your chosen license and include LICENSE file.)

Acknowledgements & Credits

Inspired by common AD recon workflows and pentesting labs (CRTP practice).

Banner art and UX inspired by classic pentest tools and terminal aesthetics.

Uses dnspython when available; otherwise falls back to dig.

If you want, I can:

produce a ready-to-add LICENSE file (MIT or Apache 2.0),

generate a minimal setup.py / installer, or

create the --headless CLI and sample CI workflow for the repo.

