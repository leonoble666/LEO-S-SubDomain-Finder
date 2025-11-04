#!/bin/bash

# ===============================================
# Subdomain Finder Script (The "Leo" Project)
# ===============================================

# --- 1. Define ANSI Colors ---
RED='\033[0;31m'    # Error/Attention
GREEN='\033[0;32m'  # Success/Starting
YELLOW='\033[0;33m' # Info/Spinner
BLUE='\033[0;34m'   # Results/Header
NC='\033[0m'        # No Color (Reset)

# --- 2. The "Leo" Header ---
echo -e "${BLUE}
           __                           __
          / /_____  ____ _____  ___  __/ /_
         / __/ __ \/ __ \/ __ \/ _ \/ / __/
        / /_/ /_/ / /_/ / /_/ /  __/ / /_
        \__/\____/ .___/\____/\___/_/\__/
                 /_/
${RED}Simple Subdomain Enumerator v1.0${NC}
"

# --- 3. Loading Spinner Function ---
# This function runs in parallel with the main search command
spin() {
    local pid=$1
    local delay=0.1
    local spin_chars="/-\|"

    # Keep looping while the process with $pid is still running
    while [ "$(ps a | awk '{print $1}' | grep $pid)" ]; do
        # Print the next character in the sequence, then move back
        printf "  ${YELLOW}[%c] Searching...${NC} " "$spin_chars"
        local temp=${spin_chars#?}
        local spin_chars=$temp${spin_chars%"$temp"}
        sleep $delay
        printf "\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b" # Clear the line
    done
    printf "                                    \b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b"
}

# --- 4. Main Script Logic ---

DOMAIN=""

# Check if a domain argument was provided via the command line
if [ -z "$1" ]; then
    # If not provided, prompt the user for input
    echo -e "${GREEN}[?] Please enter the domain name you want to search (e.g., example.com):${NC}"
    read DOMAIN
else
    # If provided, use the command-line argument
    DOMAIN=$1
fi

# Input validation (in case the user hit enter without typing anything when prompted)
if [ -z "$DOMAIN" ]; then
    echo -e "${RED}Error:${NC} No domain name provided. Exiting."
    exit 1
fi

echo -e "${GREEN}[+] Starting passive search for subdomains of: ${BLUE}$DOMAIN${NC}"
echo -e "${YELLOW}[-] Querying Certificate Transparency logs (crt.sh)...${NC}"

# Start the actual search command in a subshell in the background
(
    # Use curl to fetch the HTML content from crt.sh
    # We search for domains matching the pattern ending in our target domain
    # and use grep to extract them, then sort for uniqueness.
    curl -s "https://crt.sh/?q=%.${DOMAIN}" | \
    grep -oE '([a-zA-Z0-9-]+\.){1,10}'"${DOMAIN}" | \
    sort -u | \
    while read SUBDOMAIN; do
        # Print each unique subdomain with a colorful marker
        echo -e "${BLUE}  --> ${SUBDOMAIN}${NC}"
    done
) &

# Capture the Process ID (PID) of the background job
PID=$!

# Start the spinner function, waiting on the search job PID
spin $PID

# Wait for the background job to actually finish
wait $PID

echo -e "\n${GREEN}[+] Search complete! All found subdomains are listed above.${NC}"

# --- 5. Dependency Note ---
# This script relies on 'curl' and 'grep', which are typically pre-installed on Linux/macOS systems.
