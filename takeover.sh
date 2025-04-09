#!/bin/bash

# Colors
GREEN="\e[92m"
BLUE="\e[94m"
CYAN="\e[96m"
YELLOW="\e[93m"
RED="\e[91m"
PURPLE="\e[95m"
RESET="\e[0m"

# Banner
printf "${CYAN}╔════════════════════════════════════════════════════════════╗${RESET}\n"
printf "${CYAN}║${RESET}        ${GREEN}🛡  Advanced Subdomain Takeover Automation Tool${RESET}        ${CYAN}║${RESET}\n"
printf "${CYAN}║${RESET}                                                          ${CYAN}║${RESET}\n"
printf "${CYAN}║${RESET}   ${BLUE}💻  Coded by:${RESET} ${YELLOW}Yatun Hassen Rafi${RESET}                           ${CYAN}║${RESET}\n"
printf "${CYAN}║${RESET}   ${BLUE}🌐  GitHub:${RESET}   ${YELLOW}https://github.com/yhrsec${RESET}                 ${CYAN}║${RESET}\n"
printf "${CYAN}║${RESET}   ${BLUE}🔥  Version:${RESET}  ${PURPLE}2.0 - Power Mode${RESET}                          ${CYAN}║${RESET}\n"
printf "${CYAN}╚════════════════════════════════════════════════════════════╝${RESET}\n"

# Check input
if [ -z "$1" ]; then
    echo -e "${RED}[x] Error: No input file provided.${RESET}"
    echo -e "${YELLOW}Usage: $0 <input_file>${RESET}"
    exit 1
fi

INPUT_FILE="$1"
echo -e "${GREEN}[*] Using input file: $INPUT_FILE${RESET}"

if [ ! -f "$INPUT_FILE" ]; then
    echo -e "${RED}[x] Input file '$INPUT_FILE' not found!${RESET}"
    exit 1
fi

# Create output dir
OUTPUT_DIR="takeover_output"
mkdir -p "$OUTPUT_DIR"
echo -e "${GREEN}[*] Output directory created: $OUTPUT_DIR${RESET}"

# Progress bar
progress_bar() {
    local current=$1
    local total=$2
    local width=40
    local percent=$(( 100 * current / total ))
    local filled=$(( width * current / total ))
    local empty=$(( width - filled ))

    printf "\r["
    for ((i=0; i<filled; i++)); do printf "#"; done
    for ((i=0; i<empty; i++)); do printf "-"; done
    printf "] %3d%%" "$percent"
}

# Run tasks
TOTAL_STEPS=4
STEP=1

echo -e "${GREEN}\n[=== PHASE 1: HTTPX ENUMERATION ===]${RESET}"
httpx -l "$INPUT_FILE" -silent -status-code -cname | grep -E "400|404|500" | awk '{print $1, $2, $3}' > "$OUTPUT_DIR/possible_takeovers.txt"
progress_bar $STEP $TOTAL_STEPS; ((STEP++)); sleep 0.5

echo -e "\n${GREEN}[=== PHASE 2: CNAME FILTERING ===]${RESET}"
grep "\[" "$OUTPUT_DIR/possible_takeovers.txt" | grep -E "\[.*\]\s+\[.*\]" > "$OUTPUT_DIR/cname_present.txt"
progress_bar $STEP $TOTAL_STEPS; ((STEP++)); sleep 0.5

echo -e "\n${GREEN}[=== PHASE 3: DOMAIN CLEANUP ===]${RESET}"
cut -d "/" -f3 "$OUTPUT_DIR/cname_present.txt" | cut -d " " -f1 | sort -u > "$OUTPUT_DIR/clean_domains.txt"
progress_bar $STEP $TOTAL_STEPS; ((STEP++)); sleep 0.5

echo -e "\n${GREEN}[=== PHASE 4: RUNNING SUBZY ===]${RESET}"
subzy run --targets "$OUTPUT_DIR/clean_domains.txt" --concurrency 100 --verify_ssl
progress_bar $STEP $TOTAL_STEPS; echo
sleep 0.5

echo -e "${CYAN}\n[✔] Done! Output saved to ${YELLOW}${OUTPUT_DIR}${CYAN}${RESET}"
