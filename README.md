🔎 Subdomain Finder Script (The "Leo" Project)

Simple Subdomain Enumerator v1.0

A lightweight and passive Bash script for enumerating subdomains of a target domain using Certificate Transparency (CT) logs via the crt.sh public service. This script is designed for quick, initial reconnaissance.

✨ Features

    Passive Enumeration: Queries the publicly available crt.sh database, avoiding direct interaction with the target domain's servers.

    Simple & Fast: Utilizes standard Linux/macOS command-line tools (curl, grep, sort).

    Loading Spinner: Includes a non-intrusive terminal spinner to indicate that the search is actively running in the background.

    Clean Output: Lists unique subdomains with clear color-coded formatting.

🛠️ Prerequisites

The script relies on common command-line utilities that are usually pre-installed on most Linux and macOS distributions:

    bash: The shell environment.

    curl: Used to fetch data from the crt.sh website.

    grep: Used to filter and extract the subdomain patterns from the HTML response.

    sort: Used to ensure the list of found subdomains is unique.

🚀 Installation & Setup

    Save the script: Copy the script content into a file named, for example, leo.sh.
    Bash

$ nano leo.sh
# Paste the script content...

Make it Executable: Grant execution permissions to the script.
Bash

    $ chmod +x leo.sh

💻 Usage

The script can be executed in two ways: by providing the domain as a command-line argument, or by running it without arguments and entering the domain when prompted.

1. Using a Command-Line Argument

Provide the target domain immediately after the script name.
Bash

$ ./leo.sh example.com

2. Interactive Prompt

Run the script without any arguments and it will prompt you for input.
Bash

$ ./leo.sh
[?] Please enter the domain name you want to search (e.g., example.com):
example.com

Example Output:

Plaintext

         __                      
        / /_____ ____ _____ ___ __/ /_
       / __/ __ \/ __ \/ __ \/ _ \/ / __/
      / /_/ /_/ / /_/ / /_/ /  __/ / /_
      \__/\____/ .___/\____/\___/_/\__/
               /_/
Simple Subdomain Enumerator v1.0

[+] Starting passive search for subdomains of: example.com
[-] Querying Certificate Transparency logs (crt.sh)... [|] Searching... 
  --> mail.example.com
  --> staging.example.com
  --> www.example.com
  --> blog.example.com
  --> api.example.com

[+] Search complete! All found subdomains are listed above.

📝 How It Works

The script performs the following key actions:

    It constructs a curl request to https://crt.sh/?q=%.{DOMAIN}, which searches the Certificate Transparency (CT) logs for any SSL/TLS certificates issued for the target domain and its subdomains.

    It uses grep with a Regular Expression (grep -oE '([a-zA-Z0-9-]+\.){1,10}'"${DOMAIN}") to extract all strings that match the subdomain pattern from the returned HTML.

    The results are piped to sort -u to display only unique subdomains.

    The entire search operation runs as a background job, and the separate spin function monitors the job's Process ID (PID) to provide the loading animation until the search is finished.

⚠️ Disclaimer

This tool is for educational and authorized security testing purposes only. Always ensure you have explicit permission from the domain owner before performing any reconnaissance or security checks. The developer is not responsible for any misuse of this script.


Gemini can make mistakes, so double-check it 
