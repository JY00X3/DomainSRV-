DomainSRV - DNS SRV Record Enumerator
<img width="837" height="739" alt="Screenshot 2025-09-22 224258" src="https://github.com/user-attachments/assets/80dd169a-7cee-4010-bc48-24eb9543eabd" />

DomainSRV is a fast, parallelized Bash tool designed for enumerating DNS SRV (Service) records from a Domain Controller or DNS server. Tailored for security researchers, penetration testers, and network administrators, it offers a robust, tunable solution to discover and analyze SRV records in Active Directory (AD) environments or other DNS setups.
Features

Parallel Processing: Executes concurrent SRV queries with configurable worker threads for efficiency.
Enumeration Modes:

Common AD SRV records (e.g., _ldap._tcp, _kerberos._tcp).
Bruteforce common service prefixes (e.g., http, sip, smtp) for both TCP and UDP.
Comprehensive IANA SRV list enumeration.
Custom SRV label queries for targeted scans.
DNS zone transfer (AXFR) support.


Target Resolution: Resolves discovered SRV targets to IP addresses and infers /24 subnets.
Logging & Reporting: Saves results to organized files and supports detailed report exports.
User Interface: Features a colorized, hacker-style interface with a custom ASCII banner.
Robust Design: Includes strict error handling and runtime dependency checks.

Installation

Clone the repository:
bashgit clone https://github.com/<your-username>/domainsrv.git
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

Notes for Implementation

Banner Image:

Replace the placeholder URL (https://via.placeholder.com/800x400.png?text=DomainSRV+Banner) with the actual URL of the uploaded banner image. You can upload the image to your GitHub repository (e.g., in a docs/ folder) and reference it like ![DomainSRV Banner](docs/banner.png).
Ensure the image dimensions (e.g., 800x400) match the aspect ratio of the provided banner for best display.


Customization:

Replace <your-username> with your GitHub username.
Update [Your Name] with your actual name or preferred handle.


Additional Files:

Add a LICENSE file to the repository.
Consider including a CHANGELOG.md for version history.
Add a .gitignore file to exclude temporary files (e.g., /tmp/domainsrv_*).


Testing:

Verify the script works with the banner and menu as shown in the image.
Test on various Linux distributions to ensure compatibility.
