#!/bin/bash

# =====================================================================
# Network Research - Automated Remote Control System
# Student Name: Rami Hacmon
# Student Code: S13
# Class Code: NX201
# Lecturer's Name: Roi Mizrachi
# 
# This script automates network reconnaissance tasks,
# enabling cyber units to scan and analyze targets anonymously.
# 
# The operations include:
# - Checking anonymity using Tor
# - Running Whois and Nmap scans via a remote server
# - Saving and compressing results for analysis
# ======================================================================

# ======================================================================
#              TOOLS SUMMARY - DESCRIPTION OF EACH COMMAND
# ======================================================================
# | Tool           | Description                                    
# |----------------|--------------------------------
# | sshpass        | Automates SSH authentication with passwords 
# | tor            | Provides anonymity by routing traffic through Tor 
# | nmap           | Scans networks and detects open ports/services
# | whois          | Retrieves domain/IP ownership information
# | proxychains4   | Forces tools to run through Tor/Proxy
# | curl           | Fetches data or sends HTTP requests
# | jq             | Parses and processes JSON in Bash 
# | zip            | Compresses files into a ZIP archive
# | geoiplookup    | Identifies the geographic location of an IP address
# =======================================================================


# Color Variables
RED='\e[31m'
GREEN='\e[32m'
YELLOW='\e[33m'
BLUE='\e[34m'
CYAN='\e[36m'
RESET='\e[0m'

# Log file
RESULTS_DIR="results"
mkdir -p "$RESULTS_DIR"

# Professional log file
PRO_LOG_FILE="professional_network_research.log"

# Function to log actions professionally
log_action() {
    local SOURCE_IP="$1"
    local TARGET_IP="$2"
    local ACTION="$3"
    local STATUS="$4"
    local COMMENT="$5"
    echo "$(date '+%Y-%m-%d %H:%M:%S') | Source: $SOURCE_IP | Target: $TARGET_IP | Action: $ACTION | Status: $STATUS | Comment: $COMMENT" >> "$PRO_LOG_FILE"
}

# Tools
TOOLS=(sshpass tor nmap whois proxychains4 curl jq zip geoiplookup)

# Function to install missing tools
install_tools() {
    echo -e "${CYAN}Checking for required tools...${RESET}" 
    SOURCE_IP=$(curl -s ifconfig.me)

    for tool in "${TOOLS[@]}"; do
        if ! command -v "$tool" &>/dev/null; then
            echo -e "${RED}$tool not found. Installing...${RESET}" 
            if sudo apt install -y "$tool" &>/dev/null; then
                log_action "$SOURCE_IP" "localhost" "Install $tool" "Success" "$tool installed successfully"
            else
                log_action "$SOURCE_IP" "localhost" "Install $tool" "Failed" "Failed to install $tool"
            fi
        else
            echo -e "${GREEN}$tool is already installed.${RESET}" 
            log_action "$SOURCE_IP" "localhost" "Check $tool" "Success" "$tool already installed"
        fi
    done

    echo -e "${CYAN}Configuring ProxyChains for Tor...${RESET}" 
    sudo sed -i 's/^socks4.*/socks5 127.0.0.1 9050/' /etc/proxychains4.conf
    log_action "$SOURCE_IP" "localhost" "Configure ProxyChains" "Success" "ProxyChains configured for Tor"
}

# Function to validate IP address
validate_ip() {
    if [[ ! "$TARGET_ADDRESS" =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
        echo -e "${RED}Invalid IP address format! Please enter a valid IPv4 address.${RESET}" 
        exit 1
    fi
}

# Function to check if target is reachable via ping
check_ping() {
    SOURCE_IP=$(proxychains curl -s https://api64.ipify.org)
    echo -e "${CYAN}Checking if the target is online...${RESET}" 
    if ping -c 2 "$TARGET_ADDRESS" &>/dev/null; then
        echo -e "${GREEN}The target is responding to ping.${RESET}" 
        log_action "$SOURCE_IP" "$TARGET_ADDRESS" "Ping Test" "Success" "Target is online and reachable"
    else
        echo -e "${RED}The target is not responding to ping.${RESET}" 
        log_action "$SOURCE_IP" "$TARGET_ADDRESS" "Ping Test" "Failed" "Target unreachable or blocking ICMP"
    fi
}

# Function to ensure Tor is running
start_tor() {
    SOURCE_IP=$(proxychains curl -s https://api64.ipify.org)
    echo -e "${CYAN}Starting Tor for anonymity...${RESET}" 
    sudo systemctl start tor
    sleep 5
    if systemctl is-active --quiet tor; then
        echo -e "${GREEN}✅ Tor is running successfully.${RESET}" 
        log_action "$SOURCE_IP" "localhost" "Start Tor" "Success" "Tor started successfully"
    else
        echo -e "${RED}❌ Failed to start Tor. Exiting...${RESET}" 
        log_action "$SOURCE_IP" "localhost" "Start Tor" "Failed" "Tor failed to start"
        exit 1
    fi
}

# Function to check if Tor is providing anonymity and get spoofed country
check_anonymity() {
    echo -e "${CYAN}Checking network anonymity...${RESET}" 
    REAL_IP=$(ip a | grep -Eo 'inet [0-9]+\.[0-9]+\.[0-9]+\.[0-9]+' | awk '{print $2}' | grep -v "127.0.0.1" | head -n 1)
    TOR_IP=$(proxychains4 curl -s https://check.torproject.org/api/ip | jq -r '.IP')
    SPOOFED_COUNTRY=$(geoiplookup $TOR_IP | awk -F ': ' '{print $2}')

    echo -e "${YELLOW}Real IP: $REAL_IP${RESET}" 
    echo -e "${YELLOW}Tor IP: $TOR_IP${RESET}" 
    echo -e "${YELLOW}Spoofed Country: $SPOOFED_COUNTRY${RESET}" 

    if [ "$REAL_IP" != "$TOR_IP" ]; then
        echo -e "${GREEN}✅ Anonymity confirmed. Your Tor exit IP is: $TOR_IP${RESET}" 
        log_action "$REAL_IP" "$TOR_IP" "Check Anonymity" "Success" "Spoofed country: $COUNTRY"
    else
        echo -e "${RED}❌ Anonymity check failed. IP addresses are identical.${RESET}" 
        log_action "$REAL_IP" "$TOR_IP" "Check Anonymity" "Failed" "Anonymity not established"
        exit 1
    fi
}

# Function to get user input for target address
get_target_address() {
    read -p "Enter the target address to scan via the remote server:" TARGET_ADDRESS
    echo -e "${GREEN}Target address set to: $TARGET_ADDRESS${RESET}" 
    validate_ip
    check_ping
}

# Function to display remote server details
display_remote_server_details() {
    SOURCE_IP=$(proxychains curl -s https://api64.ipify.org)
    REMOTE_IP=$TARGET_ADDRESS
    REMOTE_COUNTRY=$(geoiplookup "$TARGET_ADDRESS" | awk -F ': ' '{print $2}')
    REMOTE_UPTIME=$(uptime -p)

    echo -e "${CYAN}Retrieving remote server details...${RESET}" 
    echo -e "${YELLOW}Remote Server IP: $REMOTE_IP${RESET}" 
    echo -e "${YELLOW}Remote Server Country: $REMOTE_COUNTRY${RESET}" 
    echo -e "${YELLOW}Remote Server Uptime: $REMOTE_UPTIME${RESET}" 

    log_action "$SOURCE_IP" "$REMOTE_IP" "Retrieve Remote Details" "Success" "Server located in: $REMOTE_COUNTRY, uptime: $REMOTE_UPTIME"
}


# Function to perform Whois lookup on target address
whois_lookup() {
    SOURCE_IP=$(proxychains curl -s https://api64.ipify.org)
    echo -e "${CYAN}Performing Whois lookup on $TARGET_ADDRESS...${RESET}" 
    if WHOIS_RESULT=$(proxychains4 whois "$TARGET_ADDRESS"); then
        echo "$WHOIS_RESULT" 
        echo "$WHOIS_RESULT" > "$RESULTS_DIR/whois_$TARGET_ADDRESS.txt"
        log_action "$SOURCE_IP" "$TARGET_ADDRESS" "Whois Lookup" "Success" "Whois data saved"
    else
        log_action "$SOURCE_IP" "$TARGET_ADDRESS" "Whois Lookup" "Failed" "Whois lookup failed"
    fi
}

# Function to perform Nmap scan on target address
nmap_scan() {
    SOURCE_IP=$(proxychains curl -s https://api64.ipify.org)
    echo -e "${CYAN}Performing Nmap scan on $TARGET_ADDRESS...${RESET}" 
    if NMAP_RESULT=$(proxychains4 nmap -sV -Pn "$TARGET_ADDRESS"); then
        echo "$NMAP_RESULT" 
        echo "$NMAP_RESULT" > "$RESULTS_DIR/nmap_$TARGET_ADDRESS.txt"
        log_action "$SOURCE_IP" "$TARGET_ADDRESS" "Nmap Scan" "Success" "Nmap results saved"
    else
        log_action "$SOURCE_IP" "$TARGET_ADDRESS" "Nmap Scan" "Failed" "Nmap scan failed"
    fi
}


# Function to compress results into a zip file
compress_results() {
    echo -e "${CYAN}Compressing all results into a ZIP file...${RESET}" 
    ZIP_FILE="network_research_results.zip"
    zip -r "$ZIP_FILE" "$RESULTS_DIR" "$PRO_LOG_FILE" > /dev/null
    echo -e "${GREEN}✅ Results compressed into $ZIP_FILE${RESET}" 
}

# Function to print summary
print_summary() {
    echo -e "${CYAN}===== Summary Report =====${RESET}" 
    echo -e "${YELLOW}Target IP:${RESET} $TARGET_ADDRESS" 
    echo -e "${YELLOW}Whois Report Saved:${RESET} results/whois_$TARGET_ADDRESS.txt" 
    echo -e "${YELLOW}Nmap Scan Report Saved:${RESET} results/nmap_$TARGET_ADDRESS.txt" 
    echo -e "${YELLOW}Full results archived in:${RESET} network_research_results.zip" 
}

# Function to remove ANSI escape sequences from log
clean_log_file() {
    sed -i 's/\x1B\[[0-9;]*[mK]//g' "$1"
}

# Main Execution
install_tools
start_tor
check_anonymity
get_target_address
display_remote_server_details
whois_lookup
nmap_scan
compress_results
print_summary

echo -e "${GREEN}Tor setup, target selection, remote server details, Whois lookup, Nmap scan, compression, and summary completed successfully.${RESET}"
clean_log_file "$PRO_LOG_FILE"
