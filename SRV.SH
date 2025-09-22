#!/usr/bin/env bash
# =====================================================
#   DomainSRV - DNS SRV Record Enumerator
#   Banner: hooded hacker (kept the drew-style)
#   Parallel queries, safe, fast, and working.
# =====================================================

set -euo pipefail
IFS=$'\n\t'

# ---------------- Colors & tags ----------------
CLR_RESET='\033[0m'
CLR_BOLD='\033[1m'
CLR_RED='\033[1;31m'
CLR_GREEN='\033[1;32m'
CLR_YELLOW='\033[1;33m'
CLR_CYAN='\033[1;36m'
CLR_WHITE='\033[1;37m'
CLR_BLUE='\033[1;34m'
CLR_MAGENTA='\033[1;35m'

TAG_FOUND='[FOUND]'
TAG_NOTFOUND='[NOTFOUND]'
TAG_WARN='[WARN]'
TAG_OK='[OK]'
TAG_INFO='[INFO]'

# ---------------- Hacker-style hooded banner (drew-style) ----------------
print_banner() {
  clear
  printf "%b\n" "${CLR_CYAN}${CLR_BOLD}"
  cat <<'BANNER'
                    .-""""-.
                   / -   -  \
                  |  .-. .- |
                  |  \o| |o (
                  \     ^    \
                   '.  )--'  /
                     '-\__.-'
                .-"""-./  |  \.-"""-.
               /       `--+--'      \
              /  .--.  .--+--.  .--.  \
             /  /    \/  / \  \/    \  \
            /  /  /\    /   \    /\  \  \
           /  /  /  \__/     \__/  \  \  \
          /  /  /                     \  \ \
         /  /  /  DOMAIN SRV ENUMERATOR \  \ \
        /__/__/___________________________\__\_\

             DomainSRV — professional SRV discovery
BANNER
  printf "%b\n" "${CLR_RESET}"
  printf "%b\n" "${CLR_WHITE}Professional · Parallel · Tunable${CLR_RESET}"
  echo
}

# ---------------- Requirements ----------------
require_tools() {
  local miss=0
  for c in dig xargs awk sed curl; do
    if ! command -v "$c" >/dev/null 2>&1; then
      echo -e "${CLR_RED}${TAG_WARN} Missing required tool: $c${CLR_RESET}"
      miss=1
    fi
  done
  if [[ $miss -ne 0 ]]; then
    echo -e "${CLR_RED}${TAG_WARN} Install the missing tools and re-run.${CLR_RESET}"
    exit 1
  fi
}

# ---------------- Globals ----------------
OUTDIR_BASE="/tmp"
DEFAULT_WORKERS=20
DIG_OPTS="+time=1 +tries=1"

SERVER=""
DOMAIN=""
WORKERS="$DEFAULT_WORKERS"

# lists
COMMON_SRV="_ldap._tcp _ldap._tcp.dc._msdcs _kerberos._udp _kerberos._tcp _gc._tcp _kpasswd._tcp _kpasswd._udp _ldap._tcp.pdc._msdcs _ldap._tcp.gc._msdcs _kerberos._tcp.dc._msdcs"
BRUTE_PREFIXES="ldap kerberos HTTP MSSQLSvc http websvr sip smtp pop3 imap RDP"

# ---------------- Session dir & files ----------------
mk_outdir() {
  local ts
  ts="$(date +'%Y%m%d-%H%M%S')"
  OUTDIR="${OUTDIR_BASE}/domainsrv_${DOMAIN}_${ts}"
  mkdir -p "$OUTDIR"
  FOUND_FILE="${OUTDIR}/found.txt"
  NOTFOUND_FILE="${OUTDIR}/notfound.txt"
  LOG_FILE="${OUTDIR}/session.log"
  : > "$FOUND_FILE"
  : > "$NOTFOUND_FILE"
  : > "$LOG_FILE"
  printf "[%s] SESSION START - domain=%s server=%s workers=%s\n" "$(date -u '+%Y-%m-%dT%H:%M:%SZ')" "$DOMAIN" "$SERVER" "$WORKERS" >> "$LOG_FILE"
}

# ---------------- Inline worker command (self-contained) ----------------
# NOTE: xargs will call this snippet with: bash -c "$INLINE" _ label server domain dig_opts found_file notfound_file log_file
INLINE_QUERY='
label="$1"; server="$2"; domain="$3"; dig_opts="$4"; found="$5"; notfound="$6"; logf="$7";
out=$(dig @"$server" $dig_opts SRV "$label.$domain" 2>/dev/null || true);
if [[ -n "$out" ]]; then
  first=$(printf "%s" "$out" | sed -n "1p");
  printf "%s -> %s\n" "$label.$domain" "$first" >> "$found";
  printf "[%s] FOUND: %s -> %s\n" "$(date -u +%Y-%m-%dT%H:%M:%SZ)" "$label.$domain" "$first" >> "$logf";
  printf "%b %b %s -> %s%b\n" "'"$CLR_GREEN"'" "'"$TAG_FOUND"'" "$label.$domain" "$first" "'"$CLR_RESET"'";
else
  printf "%s\n" "$label.$domain" >> "$notfound";
  printf "[%s] NOTFOUND: %s\n" "$(date -u +%Y-%m-%dT%H:%M:%SZ)" "$label.$domain" >> "$logf";
  printf "%b %b %s%b\n" "'"$CLR_RED"'" "'"$TAG_NOTFOUND"'" "$label.$domain" "'"$CLR_RESET"'";
fi
'

# ---------------- Small helpers ----------------
pretty_line() { printf "%b\n" "${CLR_BLUE}------------------------------------------------------------------------${CLR_RESET}"; }

labels_to_file() {
  local list="$1"
  local outfile="$2"
  : > "$outfile"
  for lbl in $list; do
    printf "%s\n" "$lbl" >> "$outfile"
  done
}

# ---------------- Actions (parallel) ----------------
do_common_parallel() {
  echo -e "${CLR_CYAN}${TAG_INFO} Enumerating common AD SRV records with ${WORKERS} workers...${CLR_RESET}"
  labels_to_file "$COMMON_SRV" "${OUTDIR}/labels_common.txt"
  cat "${OUTDIR}/labels_common.txt" | xargs -I{} -P "$WORKERS" bash -c "$INLINE_QUERY" _ {} "$SERVER" "$DOMAIN" "$DIG_OPTS" "$FOUND_FILE" "$NOTFOUND_FILE" "$LOG_FILE"
  echo -e "${CLR_GREEN}${TAG_OK} Common enumeration finished.${CLR_RESET}"
}

do_bruteforce_parallel() {
  echo -e "${CLR_MAGENTA}${TAG_INFO} Bruteforcing common prefixes with ${WORKERS} workers...${CLR_RESET}"
  : > "${OUTDIR}/labels_brute.txt"
  for p in $BRUTE_PREFIXES; do
    printf "%s\n" "_${p}._tcp" >> "${OUTDIR}/labels_brute.txt"
    printf "%s\n" "_${p}._udp" >> "${OUTDIR}/labels_brute.txt"
  done
  cat "${OUTDIR}/labels_brute.txt" | xargs -I{} -P "$WORKERS" bash -c "$INLINE_QUERY" _ {} "$SERVER" "$DOMAIN" "$DIG_OPTS" "$FOUND_FILE" "$NOTFOUND_FILE" "$LOG_FILE"
  echo -e "${CLR_GREEN}${TAG_OK} Bruteforce finished.${CLR_RESET}"
}

do_all_iana_parallel() {
  local wordlist="${OUTDIR}/all-srvs.txt"
  if [[ ! -f "$wordlist" ]]; then
    echo -e "${CLR_YELLOW}${TAG_INFO} Downloading IANA CSV and building SRV list...${CLR_RESET}"
    curl -s -o "${OUTDIR}/iana.csv" "https://www.iana.org/assignments/service-names-port-numbers/service-names-port-numbers.csv"
    awk -F, 'NR>1 {svc=$1; gsub(/\"/,"",svc); if(svc!="") print "_" tolower(svc) "._tcp\n_" tolower(svc) "._udp"}' "${OUTDIR}/iana.csv" | sort -u > "$wordlist"
    echo -e "${CLR_GREEN}${TAG_OK} Wordlist created: ${wordlist} ($(wc -l < "$wordlist") entries)${CLR_RESET}"
  fi
  echo -e "${CLR_RED}${TAG_WARN} This will run many queries (may be tens of thousands).${CLR_RESET}"
  read -rp "Proceed? (y/N): " yn; yn="${yn:-N}"
  if [[ "${yn^^}" != "Y" ]]; then
    echo -e "${CLR_YELLOW}${TAG_INFO} Full IANA enumeration cancelled.${CLR_RESET}"
    return
  fi
  echo -e "${CLR_CYAN}${TAG_INFO} Running full IANA SRV enumeration with ${WORKERS} workers...${CLR_RESET}"
  cat "$wordlist" | xargs -I{} -P "$WORKERS" bash -c "$INLINE_QUERY" _ {} "$SERVER" "$DOMAIN" "$DIG_OPTS" "$FOUND_FILE" "$NOTFOUND_FILE" "$LOG_FILE"
  echo -e "${CLR_GREEN}${TAG_OK} IANA enumeration finished.${CLR_RESET}"
}

do_axfr() {
  echo -e "${CLR_YELLOW}${TAG_INFO} Attempting AXFR (zone transfer) — this can be noisy.${CLR_RESET}"
  read -rp "Proceed with AXFR? (y/N): " yn; yn="${yn:-N}"
  if [[ "${yn^^}" != "Y" ]]; then
    echo -e "${CLR_YELLOW}${TAG_INFO} AXFR skipped.${CLR_RESET}"; return
  fi
  dig @"$SERVER" "$DOMAIN" AXFR +noall +answer > "${OUTDIR}/${DOMAIN}-axfr.txt" 2>/dev/null || true
  if [[ -s "${OUTDIR}/${DOMAIN}-axfr.txt" ]]; then
    echo -e "${CLR_GREEN}${TAG_OK} AXFR succeeded; saved to ${OUTDIR}/${DOMAIN}-axfr.txt${CLR_RESET}"
    grep -E ' SRV ' "${OUTDIR}/${DOMAIN}-axfr.txt" >> "$FOUND_FILE" 2>/dev/null || true
  else
    echo -e "${CLR_RED}${TAG_WARN} AXFR failed or returned no data.${CLR_RESET}"
  fi
}

do_custom_parallel() {
  echo -e "${CLR_CYAN}${TAG_INFO} Enter custom SRV labels (one per line). Empty line to finish.${CLR_RESET}"
  local tmp="${OUTDIR}/labels_custom.txt"
  : > "$tmp"
  while true; do
    read -rp "label (e.g. _http._tcp): " cl
    cl="${cl// /}"
    [[ -z "$cl" ]] && break
    printf "%s\n" "$cl" >> "$tmp"
  done
  if [[ -s "$tmp" ]]; then
    cat "$tmp" | xargs -I{} -P "$WORKERS" bash -c "$INLINE_QUERY" _ {} "$SERVER" "$DOMAIN" "$DIG_OPTS" "$FOUND_FILE" "$NOTFOUND_FILE" "$LOG_FILE"
    echo -e "${CLR_GREEN}${TAG_OK} Custom queries completed.${CLR_RESET}"
  else
    echo -e "${CLR_YELLOW}${TAG_INFO} No custom labels entered.${CLR_RESET}"
  fi
}

# ---------------- Resolve & report ----------------
resolve_found_targets() {
  if [[ ! -s "$FOUND_FILE" ]]; then
    echo -e "${CLR_YELLOW}${TAG_INFO} No found entries to resolve.${CLR_RESET}"; return
  fi
  echo -e "${CLR_CYAN}${TAG_INFO} Resolving discovered targets and inferring /24 subnets...${CLR_RESET}"
  awk -F'->' '{print $2}' "$FOUND_FILE" | sed -e 's/^[[:space:]]*//' | awk '{print $NF}' | sed 's/\.$//' | sort -u | while read -r host; do
    [[ -z "$host" ]] && continue
    ip=$(dig +short "$host" @"$SERVER" 2>/dev/null | sed -n '1p' || true)
    if [[ -n "$ip" ]]; then
      subnet=$(echo "$ip" | awk -F. '{print $1"."$2"."$3".0/24"}')
      printf "%b %s -> %s  (subnet: %s)%b\n" "${CLR_GREEN}" "$host" "$ip" "$subnet" "${CLR_RESET}"
      printf "%s,%s\n" "$host" "$ip" >> "${OUTDIR}/resolved.csv"
    else
      printf "%b %s (unresolved)%b\n" "${CLR_YELLOW}" "$host" "${CLR_RESET}"
    fi
  done
}

show_summary() {
  echo
  printf "%b\n" "${CLR_WHITE}Session summary - output dir: ${OUTDIR}${CLR_RESET}"
  printf "Found entries: %s\n" "$(wc -l < "$FOUND_FILE" 2>/dev/null || echo 0)"
  printf "Notfound:      %s\n" "$(wc -l < "$NOTFOUND_FILE" 2>/dev/null || echo 0)"
  echo "Full log: $LOG_FILE"
  echo
}

export_report() {
  read -rp "Enter path to save report (e.g. ~/srv_report.txt): " rpt
  if [[ -z "${rpt// /}" ]]; then
    echo "Cancelled"; return
  fi
  {
    echo "DomainSRV report"
    echo "Generated: $(date -u '+%Y-%m-%d %H:%M:%SZ')"
    echo "Server: $SERVER"
    echo "Domain: $DOMAIN"
    echo
    echo "=== FOUND ==="
    if [[ -s "$FOUND_FILE" ]]; then cat "$FOUND_FILE"; else echo "[none]"; fi
    echo
    echo "=== NOTFOUND ==="
    if [[ -s "$NOTFOUND_FILE" ]]; then cat "$NOTFOUND_FILE"; else echo "[none]"; fi
    echo
    if [[ -s "${OUTDIR}/resolved.csv" ]]; then
      echo "=== RESOLVED ==="
      cat "${OUTDIR}/resolved.csv"
    fi
  } > "$rpt"
  echo "Report written: $rpt"
}

# ---------------- Menu ----------------
main_menu() {
  while true; do
    print_banner
    echo -e "${CLR_BOLD}Target: ${CLR_CYAN}${DOMAIN}${CLR_RESET} @ ${CLR_CYAN}${SERVER}${CLR_RESET}"
    echo -e "${CLR_WHITE}Workers:${CLR_RESET} ${WORKERS}"
    pretty_line
    echo "1) AXFR (zone transfer)"
    echo "2) Enumerate common AD SRVs (parallel)"
    echo "3) Bruteforce common prefixes (parallel)"
    echo "4) Enumerate ALL IANA SRVs (parallel, slow)"
    echo "5) Custom SRV labels (parallel)"
    echo "6) Resolve discovered targets"
    echo "7) Show summary"
    echo "8) Export report to file"
    echo "9) Change server/domain/workers"
    echo "0) Exit"
    pretty_line
    read -rp "Choice [0-9]: " ch
    ch="${ch:-}"
    case "$ch" in
      1) do_axfr ;;
      2) do_common_parallel ;;
      3) do_bruteforce_parallel ;;
      4) do_all_iana_parallel ;;
      5) do_custom_parallel ;;
      6) resolve_found_targets ;;
      7) show_summary ;;
      8) export_report ;;
      9)
         read -rp "New DNS server: " SERVER
         read -rp "New domain: " DOMAIN
         read -rp "Workers (concurrency) [default $DEFAULT_WORKERS]: " w
         WORKERS="${w:-$DEFAULT_WORKERS}"
         mk_outdir
         ;;
      0) echo -e "${CLR_GREEN}${TAG_OK} Exiting. Logs retained at ${OUTDIR}${CLR_RESET}"; break ;;
      *) echo -e "${CLR_RED}${TAG_WARN} Invalid choice${CLR_RESET}" ;;
    esac
    read -rp "Press Enter to continue..." _dummy
  done
}

# ---------------- Start ----------------
require_tools
print_banner
read -rp "Enter DNS server IP/hostname: " SERVER
read -rp "Enter DNS domain (FQDN): " DOMAIN
read -rp "Workers (concurrency) [default $DEFAULT_WORKERS]: " W
WORKERS="${W:-$DEFAULT_WORKERS}"

mk_outdir
main_menu