GitHub README
Below is a suggested README for your GitHub repository to present DomainSRV professionally.
markdown# DomainSRV - DNS SRV Record Enumerator

![DomainSRV Banner](<img width="837" height="738" alt="image" src="https://github.com/user-attachments/assets/6d10d2d6-0647-4812-a549-0f9589ea0f10" />
) <!-- Replace with actual banner image if available -->

**DomainSRV** is a fast, parallelized Bash tool for enumerating DNS SRV (Service) records from a Domain Controller or DNS server. Designed for security researchers, penetration testers, and network administrators, it provides a flexible and robust way to discover and analyze SRV records in Active Directory environments or other DNS setups.

## Features
- **Parallel Queries**: Concurrent SRV enumeration with configurable worker threads.
- **Enumeration Modes**:
  - Common Active Directory SRVs (e.g., `_ldap._tcp`, `_kerberos._tcp`).
  - Bruteforce common service prefixes (e.g., `http`, `sip`, `smtp`).
  - Full IANA SRV list enumeration for exhaustive discovery.
  - Custom SRV label queries for targeted scans.
  - DNS zone transfer (AXFR) support.
- **Target Resolution**: Resolves SRV targets to IPs and infers /24 subnets.
- **Logging & Reporting**: Saves results to organized files and supports report exports.
- **Hacker-Style Interface**: Colorized output with a "hooded hacker" ASCII banner.
- **Robust Design**: Strict error handling and dependency checks for reliability.

## Installation
1. Clone the repository:
   ```bash
   git clone https://github.com/<your-username>/domainsrv.git
   cd domainsrv

Ensure dependencies are installed:

dig, xargs, awk, sed, curl
On Debian/Ubuntu: sudo apt-get install dnsutils coreutils curl


Make the script executable:
bashchmod +x domainsrv.sh


Usage
bash./domainsrv.sh

Enter the target DNS server, domain (FQDN), and number of workers.
Select from the interactive menu:

1 Attempt AXFR (zone transfer)
2 Enumerate common AD SRVs
3 Bruteforce common prefixes
4 Enumerate all IANA SRVs
5 Custom SRV queries
6 Resolve discovered targets
7 Show session summary
8 Export report
9 Change server/domain/workers
0 Exit



Example
bash$ ./domainsrv.sh
Enter DNS server IP/hostname: 192.168.1.10
Enter DNS domain (FQDN): example.com
Workers (concurrency) [default 20]: 20

Select option 2 to enumerate AD SRVs.
Results are saved to /tmp/domainsrv_example.com_<timestamp>/.

Output

Session Directory: /tmp/domainsrv_<domain>_<timestamp>/

found.txt: Discovered SRV records.
notfound.txt: SRV queries with no results.
session.log: Detailed query logs.
resolved.csv: Resolved IPs (if resolved).
<domain>-axfr.txt: Zone transfer results (if applicable).



Requirements

Tools: dig, xargs, awk, sed, curl
OS: Linux/Unix with Bash
Permissions: Network access to the DNS server; optional root for some setups.

Notes

Use responsibly and only on systems you are authorized to test.
Full IANA enumeration (option 4) can generate significant network traffic.
AXFR (option 1) may be noisy and is often restricted by DNS servers.

Contributing
Contributions are welcome! Please submit issues or pull requests for bug fixes, features, or improvements.
License
This project is licensed under the MIT License. See LICENSE for details.
Acknowledgments

Inspired by the need for efficient SRV record enumeration in penetration testing.
ASCII art designed in the classic "drew-style" for a hacker aesthetic.


Built with ❤️ by [JY00X3]
text### Notes for GitHub
1. **Repository Setup**:
   - Create a GitHub repository named `domainsrv`.
   - Add the script as `domainsrv.sh`.
   - Include a `LICENSE` file (e.g., MIT License).
   - Optionally, add a banner image to enhance the README.

2. **Customization**:
   - Replace `<your-username>` with your GitHub username.
   - Update the placeholder banner image URL with a custom image if desired.
   - Add your name or handle in the "Built by" section.

3. **Additional Files**:
   - Consider adding a `CHANGELOG.md` for version tracking.
   - Include a `.gitignore` to exclude temporary files (e.g., `/tmp/domainsrv_*`).

4. **Testing**:
   - Test the script in a safe environment (e.g., a lab) before deployment.
   - Ensure the README instructions are clear and accurate.

This description and README should effectively showcase **DomainSRV** as a professional and pow
