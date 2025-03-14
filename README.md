# SOC Remote Control – Automated Cyber Operations

## Overview
**SOC Remote Control** is a **Bash automation tool** that allows **SOC analysts** to remotely execute security operations while maintaining anonymity.  
It enables cybersecurity teams to perform **network scanning, reconnaissance, and security assessments** via a remote server.

## Features
✅ **Automated SSH connection to remote server**  
✅ **Executes Nmap and Whois lookups anonymously**  
✅ **Logs results and audits security operations**  
✅ **Uses TOR and Nipe for anonymized connections**  
✅ **Supports manual or automated IP selection**  

## Project Structure
- **Installations & Anonymity Check:**
  - Installs required tools (Nmap, Torify, Whois, SSHpass).
  - Checks if the connection is anonymous and displays the spoofed country.
  - Allows the user to specify an IP address to scan.

- **Automated Remote Execution via SSH:**
  - Retrieves server details (country, IP, uptime).
  - Runs `whois` and `nmap` scans on a given target remotely.

- **Results & Logging:**
  - Stores scan results and logs attack data locally for auditing.

## Tools Used
- 🔹 **Sshpass** – Automates SSH authentication.
- 🔹 **Nipe** – Routes traffic through Tor for anonymity.
- 🔹 **Torify** – Wraps commands to use the Tor network.
- 🔹 **Nmap** – Network scanning and reconnaissance.
- 🔹 **Whois** – Gathers domain and IP registration details.

## Installation & Usage
```bash
chmod +x soc_remote_control.sh
sudo ./soc_remote_control.sh
