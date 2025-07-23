#!/bin/bash

# رنگ‌ها
RED='\033[91m'
GREEN='\033[92m'
YELLOW='\033[93m'
BLUE='\033[94m'
MAGENTA='\033[95m'
CYAN='\033[96m'
RESET='\033[0m'

colors=("$RED" "$GREEN" "$YELLOW" "$BLUE" "$MAGENTA" "$CYAN")

header() {
    color=${colors[$RANDOM % ${#colors[@]}]}
    clear
    echo -e "${color}╔════════════════════════════════════════════════════════════╗"
    echo -e "║            Gaming DNS Management Tool                      ║"
    echo -e "║    Telegram: @Academi_vpn   Admin By: @MahdiAGM0          ║"
    echo -e "║                    Version : 1.5                           ║"
    echo -e "╚════════════════════════════════════════════════════════════╝${RESET}"
    echo
}

pause_return_to_main() {
    echo
    read -rp "Press Enter to return to MAIN MENU..."
}

# ================= DNS Data =======================
# Structure: dns_map["<category>-<game>-<country>"] = ("DNS1 DNS2 DNS3 ...")

# Mobile Games DNS by country
declare -A dns_map

# Example for PUBG Mobile in USA (add many real DNS)
dns_map["mobile-PUBG Mobile-USA"]="8.8.8.8 8.8.4.4 1.1.1.1 1.0.0.1"
dns_map["mobile-PUBG Mobile-Iran"]="185.51.200.2 185.51.200.3 77.88.8.8 77.88.8.1"
dns_map["mobile-Arena Breakout-Iran"]="9.9.9.9 149.112.112.112 8.26.56.26 8.20.247.20"

# Example for Call of Duty Mobile in USA and Iran
dns_map["mobile-Call of Duty Mobile-USA"]="8.8.8.8 8.8.4.4 208.67.222.222 208.67.220.220"
dns_map["mobile-Call of Duty Mobile-Iran"]="185.51.200.10 185.51.200.11 77.88.8.8 77.88.8.1"

# PC Games DNS by country
dns_map["pc-Valorant-USA"]="8.8.8.8 8.8.4.4 1.1.1.1 1.0.0.1"
dns_map["pc-Valorant-Iran"]="185.51.200.5 185.51.200.6 77.88.8.8 77.88.8.1"
dns_map["pc-Fortnite-USA"]="208.67.222.222 208.67.220.220 8.8.8.8 8.8.4.4"

# Console Games DNS by country
dns_map["console-FIFA-USA"]="1.1.1.1 1.0.0.1 8.8.8.8 8.8.4.4"
dns_map["console-FIFA-Iran"]="185.51.200.7 185.51.200.8 77.88.8.8 77.88.8.1"

# DNS Download (some public DNS + some VPN-friendly)
dns_download_primary=("8.8.8.8" "1.1.1.1" "9.9.9.9" "208.67.222.222" "185.51.200.2" "77.88.8.8")
dns_download_secondary=("8.8.4.4" "1.0.0.1" "149.112.112.112" "208.67.220.220" "185.51.200.3" "77.88.8.1")

# ================= Countries and Games ==================

countries=("USA" "Iran")

games_mobile=("PUBG Mobile" "Call of Duty Mobile" "Arena Breakout")
games_pc=("Valorant" "Fortnite")
games_console=("FIFA")

# ================= Functions =================

list_menu() {
    local -n arr=$1
    local i=1
    for item in "${arr[@]}"; do
        echo "$i) $item"
        ((i++))
    done
}

get_random_dns() {
    # Args: list_of_dns
    # Returns 2 random DNS from the list, no duplicates
    local dns_list=($@)
    local size=${#dns_list[@]}
    local idx1=$((RANDOM % size))
    local idx2
    while :; do
        idx2=$((RANDOM % size))
        [[ $idx2 != $idx1 ]] && break
    done
    echo "${dns_list[$idx1]} ${dns_list[$idx2]}"
}

ping_dns() {
    # $1 = DNS IP
    ping -c 1 -W 1 "$1" >/dev/null 2>&1
    if [[ $? -eq 0 ]]; then
        ping -c 1 "$1" | tail -1 | awk -F '/' '{print $5 " ms"}'
    else
        echo "No response"
    fi
}

show_dns_for_game() {
    local category=$1
    local games_list=("${!2}")
    header
    echo "Select a Game:"
    list_menu games_list
    echo
    read -rp "Enter game number (or 0 to go back): " game_choice
    if [[ $game_choice -eq 0 ]]; then return; fi
    if [[ $game_choice -lt 1 || $game_choice -gt ${#games_list[@]} ]]; then
        echo -e "${RED}Invalid choice.${RESET}"
        pause_return_to_main
        return
    fi

    local selected_game="${games_list[$((game_choice-1))]}"

    header
    echo "Select a Country:"
    list_menu countries
    echo
    read -rp "Enter country number (or 0 to go back): " country_choice
    if [[ $country_choice -eq 0 ]]; then return; fi
    if [[ $country_choice -lt 1 || $country_choice -gt ${#countries[@]} ]]; then
        echo -e "${RED}Invalid choice.${RESET}"
        pause_return_to_main
        return
    fi

    local selected_country="${countries[$((country_choice-1))]}"

    local key="${category}-${selected_game}-${selected_country}"

    if [[ -z "${dns_map[$key]}" ]]; then
        echo -e "${RED}No DNS found for $selected_game in $selected_country.${RESET}"
        pause_return_to_main
        return
    fi

    # get dns list from map and split into array
    IFS=' ' read -r -a dns_list <<< "${dns_map[$key]}"
    # pick two random distinct DNS from the list
    dns_pair=($(get_random_dns "${dns_list[@]}"))

    header
    echo -e "${YELLOW}Game:${RESET} $selected_game"
    echo -e "${YELLOW}Country:${RESET} $selected_country"
    echo
    echo "1. Primary DNS: ${dns_pair[0]} | Secondary DNS: ${dns_pair[1]}"
    echo -n "2. Ping Primary DNS (${dns_pair[0]}): "
    ping_dns "${dns_pair[0]}"
    echo -n "   Ping Secondary DNS (${dns_pair[1]}): "
    ping_dns "${dns_pair[1]}"
    pause_return_to_main
}

show_dns_download() {
    header
    # Pick random pair from dns_download arrays
    local size=${#dns_download_primary[@]}
    idx1=$((RANDOM % size))
    idx2=$((RANDOM % size))
    # Avoid duplicate indices
    while [[ $idx2 -eq $idx1 ]]; do
        idx2=$((RANDOM % size))
    done

    echo -e "${YELLOW}Download DNS:${RESET}"
    echo "1. Primary DNS: ${dns_download_primary[$idx1]} | Secondary DNS: ${dns_download_secondary[$idx2]}"
    echo -n "2. Ping Primary DNS (${dns_download_primary[$idx1]}): "
    ping_dns "${dns_download_primary[$idx1]}"
    echo -n "   Ping Secondary DNS (${dns_download_secondary[$idx2]}): "
    ping_dns "${dns_download_secondary[$idx2]}"
    pause_return_to_main
}

# DNS Generator functions for Saudi, Turkey, UAE (from your previous code)

generate_ipv4_saudi() { echo "188.$((RANDOM%256)).$((RANDOM%256)).$((RANDOM%256))"; }
generate_ipv6_saudi() { printf "2a03:%04x:%04x::%04x:%04x\n" $((RANDOM%65536)) $((RANDOM%65536)) $((RANDOM%65536)) $((RANDOM%65536)); }

generate_ipv4_turkey() { echo "185.$((RANDOM%256)).$((RANDOM%256)).$((RANDOM%256))"; }
generate_ipv6_turkey() { printf "2a02:%04x:%04x::%04x:%04x\n" $((RANDOM%65536)) $((RANDOM%65536)) $((RANDOM%65536)) $((RANDOM%65536)); }

generate_ipv4_uae() { echo "185.$((RANDOM%256)).$((RANDOM%256)).$((RANDOM%256))"; }
generate_ipv6_uae() { printf "2a02:%04x:%04x::%04x:%04x\n" $((RANDOM%65536)) $((RANDOM%65536)) $((RANDOM%65536)) $((RANDOM%65536)); }

dns_generate() {
    header
    echo "DNS Generator"
    echo "1) Saudi Arabia"
    echo "2) Turkey"
    echo "3) UAE"
    echo "0) Back"
    echo
    read -rp "Choose a country to generate DNS for: " gen_choice
    case $gen_choice in
        1) country="Saudi Arabia";;
        2) country="Turkey";;
        3) country="UAE";;
        0) return;;
        *) echo -e "${RED}Invalid choice.${RESET}"; pause_return_to_main; return;;
    esac

    read -rp "IPv4 or IPv6? (4/6): " ip_ver
    if [[ "$ip_ver" != "4" && "$ip_ver" != "6" ]]; then
        echo -e "${RED}Invalid IP version choice.${RESET}"
        pause_return_to_main
        return
    fi
    read -rp "How many DNS addresses do you want?: " count
    if ! [[ "$count" =~ ^[0-9]+$ ]]; then
        echo -e "${RED}Please enter a valid number.${RESET}"
        pause_return_to_main
        return
    fi
    echo
    echo "Generated DNS addresses for $country:"
    for ((i=1; i<=count; i++)); do
        if [ "$country" == "Saudi Arabia" ]; then
            if [ "$ip_ver" == "4" ]; then
                echo "$i) $(generate_ipv4_saudi)"
            else
                echo "$i) $(generate_ipv6_saudi)"
            fi
        elif [ "$country" == "Turkey" ]; then
            if [ "$ip_ver" == "4" ]; then
                echo "$i) $(generate_ipv4_turkey)"
            else
                echo "$i) $(generate_ipv6_turkey)"
            fi
        elif [ "$country" == "UAE" ]; then
            if [ "$ip_ver" == "4" ]; then
                echo "$i) $(generate_ipv4_uae)"
            else
                echo "$i) $(generate_ipv6_uae)"
            fi
        fi
    done
    pause_return_to_main
}

# ================= Main Menu =================

main_menu() {
    while true; do
        header
        echo "Main Menu:"
        echo "1) Mobile Games"
        echo "2) PC Games"
        echo "3) Console Games"
        echo "4) DNS Download"
        echo "5) DNS Generate"
        echo "0) Exit"
        echo
        read -rp "Enter your choice: " choice

        case $choice in
            1) show_dns_for_game "mobile" games_mobile[@] ;;
            2) show_dns_for_game "pc" games_pc[@] ;;
            3) show_dns_for_game "console" games_console[@] ;;
            4) show_dns_download ;;
            5) dns_generate ;;
            0) echo "Exiting..."; exit 0 ;;
            *) echo -e "${RED}Invalid choice.${RESET}"; pause_return_to_main ;;
        esac
    done
}

# ================== Run ==================
main_menu
