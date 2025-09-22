# DomainSRV - DNS SRV Record Enumerator

![DomainSRV Banner](<img width="837" height="739" alt="Screenshot 2025-09-22 224258" src="https://github.com/user-attachments/assets/982f45e9-6485-44b3-9dbe-954a1b58a31b" />
) <!-- Replace with the actual uploaded banner image URL -->

**DomainSRV** is a fast, parallelized Bash tool designed for enumerating DNS SRV (Service) records from a Domain Controller or DNS server. Tailored for security researchers, penetration testers, and network administrators, it offers a robust, tunable solution to discover and analyze SRV records in Active Directory (AD) environments or other DNS setups.

## Features
- **Parallel Processing**: Executes concurrent SRV queries with configurable worker threads for efficiency.
- **Enumeration Modes**:
  - Common AD SRV records (e.g., `_ldap._tcp`, `_kerberos._tcp`).
  - Bruteforce common service prefixes (e.g., `http`, `sip`, `smtp`) for both TCP and UDP.
  - Comprehensive IANA SRV list enumeration.
  - Custom SRV label queries for targeted scans.
  - DNS zone transfer (AXFR) support.
- **Target Resolution**: Resolves discovered SRV targets to IP addresses and infers /24 subnets.
- **Logging & Reporting**: Saves results to organized files and supports detailed report exports.
- **User Interface**: Features a colorized, hacker-style interface with a custom ASCII banner.
- **Robust Design**: Includes strict error handling and runtime dependency checks.

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

Input the target DNS server, domain (FQDN), and number of workers when prompted.
Select from the interactive menu:

1 AXFR (zone transfer)
2 Enumerate common AD SRVs
3 Bruteforce common prefixes
4 Enumerate all IANA SRVs
5 Custom SRV labels
6 Resolve discovered targets
7 Show summary
8 Export report to file
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
Permissions: Network access to the DNS server; optional root privileges for certain setups.

Notes

Use responsibly and only on authorized systems.
Full IANA enumeration (option 4) may generate significant network traffic.
AXFR (option 1) is often restricted by DNS servers and may be noisy.

Contributing
Contributions are welcome! Please submit issues or pull requests for bug fixes, enhancements, or new features.
License
This project is licensed under the MIT License. See LICENSE for details.
Acknowledgments

Inspired by the need for efficient SRV record enumeration in penetration testing.
ASCII banner designed with a classic hacker aesthetic.


Developed with ❤️ by [JY00X3]
text### Notes for Implementation
1. **Banner Image**:
   - Replace the placeholder URL (`<img width="837" height="739" alt="Screenshot 2025-09-22 224258" src="https://github.com/user-attachments/assets/4ccebe61-3665-4c69-9fb4-b4b68f3527d6" />
`) with the actual URL of the uploaded banner image. Upload the image to your GitHub repository (e.g., in a `docs/` folder) and reference it like `![DomainSRV Banner](docs/banner.png)`. Ensure the dimensions (e.g., 800x400) match the aspect ratio of your provided banner.

2. **Customization**:
   - Replace `<your-username>` with your GitHub username.
   - Update `[Your Name]` with your actual name or preferred handle.

3. **Additional Files**:
   - Add a `LICENSE` file to the repository (e.g., copy a MIT License template).
   - Consider including a `CHANGELOG.md` for version history.
   - Add a `.gitignore` file to exclude temporary files (e.g., `/tmp/domainsrv_*`).

4. **Testing**:
   - Verify the README content aligns with the script's functionality.
   - Test the rendered README on GitHub to ensure proper formatting.

This `README.md` provides a professional and complete overview of **DomainSRV**, ready to be pas
