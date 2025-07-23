#!/bin/bash

# === Colors ===
RED='\033[91m'
GREEN='\033[92m'
YELLOW='\033[93m'
BLUE='\033[94m'
MAGENTA='\033[95m'
CYAN='\033[96m'
RESET='\033[0m'

colors=($RED $GREEN $YELLOW $BLUE $MAGENTA $CYAN)
color=${colors[$RANDOM % ${#colors[@]}]}

# Clear screen function
clear_screen() {
    clear
}

# Header function with colored title
header() {
    clear_screen
    echo -e "${color}╔════════════════════════════════════════════════════════════╗"
    echo -e "║            Gaming DNS Management Tool                      ║"
    echo -e "║    Telegram: @Academi_vpn   Admin By: @MahdiAGM0          ║"
    echo -e "║                    Version : 1.3.0                         ║"
    echo -e "╚════════════════════════════════════════════════════════════╝${RESET}"
    echo
}

# Pause and wait for Enter to return to main menu
pause_return() {
    echo
    read -rp "Press Enter to return to the main menu..."
}

# Ping reminder text
ping_reminder() {
    echo -e "${YELLOW}(Use ping command to measure latency)${RESET}"
}

# === Games and DNS Data ===
declare -A dns_map

# Sample Mobile Games with fake but realistic DNS IPs (you can expand!)
mobile_games=(
    "PUBG Mobile"
    "Free Fire"
    "Call of Duty Mobile"
    "Arena Breakout"
    "Genshin Impact"
    "Mobile Legends"
    "Clash of Clans"
    "Among Us"
    "Minecraft Pocket Edition"
    "Roblox Mobile"
    "Brawl Stars"
    "Fortnite Mobile"
    "Apex Legends Mobile"
    "Wild Rift"
    "Pokemon Go"
    "League of Legends Mobile"
    "Shadowgun Legends"
    "Dead Trigger 2"
    "Critical Ops"
    "Rules of Survival"
    "Asphalt 9"
    "Honkai Impact 3rd"
    "State of Survival"
    "Dragon Raja"
    "Garena Speed Drifters"
    "Summoners War"
    "Last Day on Earth"
    "Among Us"
    "Call of Dragons"
    "Minecraft"
    "Fortnite"
    "Roblox"
    "Apex Legends"
    "Valorant"
    "League of Legends"
    "CS:GO"
    "Overwatch"
    "Dota 2"
    "Rainbow Six Siege"
)

# Countries list (add more as needed)
countries=(
    "USA"
    "Iran"
    "Germany"
    "Japan"
    "South Korea"
    "Turkey"
    "United Arab Emirates"
    "Saudi Arabia"
    "France"
    "Canada"
    "Australia"
    "Russia"
    "India"
    "Brazil"
    "Mexico"
    "Singapore"
    "Netherlands"
    "Sweden"
    "Italy"
    "Spain"
)

# Fill dns_map for Mobile Games (example with random realistic DNS)
for game in "${mobile_games[@]}"; do
    for country in "${countries[@]}"; do
        key="${game}-${country}"
        dns_map["$key"]="1.1.1.1|1.0.0.1,8.8.8.8|8.8.4.4,9.9.9.9|149.112.112.112,208.67.222.222|208.67.220.220"
    done
done

# Similarly, you can create PC Games and Console Games arrays and their dns_map entries

# === DNS Generators for Saudi, Turkey, UAE ===

generate_ipv4_saudi() {
    echo "188.$((RANDOM%256)).$((RANDOM%256)).$((RANDOM%256))"
}

generate_ipv6_saudi() {
    printf "2a03:%04x:%04x::%04x:%04x\n" $((RANDOM%65536)) $((RANDOM%65536)) $((RANDOM%65536)) $((RANDOM%65536))
}

generate_ipv4_turkey() {
    echo "185.$((RANDOM%256)).$((RANDOM%256)).$((RANDOM%256))"
}

generate_ipv6_turkey() {
    printf "2a03:%04x:%04x::%04x:%04x\n" $((RANDOM%65536)) $((RANDOM%65536)) $((RANDOM%65536)) $((RANDOM%65536))
}

generate_ipv4_uae() {
    echo "185.$((128 + RANDOM%64)).$((RANDOM%256)).$((RANDOM%256))"
}

generate_ipv6_uae() {
    printf "2a02:%04x:%04x::%04x:%04x\n" $((RANDOM%65536)) $((RANDOM%65536)) $((RANDOM%65536)) $((RANDOM%65536))
}

dns_generator_menu() {
    while true; do
        header
        echo "DNS Generators:"
        echo "1) Saudi Arabia"
        echo "2) Turkey"
        echo "3) United Arab Emirates"
        echo "4) Back to main menu"
        echo
        read -rp "Choose an option: " dns_choice
        case $dns_choice in
            1)
                dns_generate_saudi
                ;;
            2)
                dns_generate_turkey
                ;;
            3)
                dns_generate_uae
                ;;
            4)
                return
                ;;
            *)
                echo -e "${RED}Invalid option! Try again.${RESET}"
                ;;
        esac
    done
}

dns_generate_saudi() {
    header
    echo "Saudi Arabia DNS Generator"
    read -rp "IPv4 or IPv6? (4/6): " ip_ver
    if [[ "$ip_ver" != "4" && "$ip_ver" != "6" ]]; then
        echo -e "${RED}Invalid choice.${RESET}"
        pause_return
        return
    fi
    read -rp "How many DNS addresses do you want?: " count
    if ! [[ "$count" =~ ^[0-9]+$ ]]; then
        echo -e "${RED}Please enter a valid number.${RESET}"
        pause_return
        return
    fi
    echo
    echo "Generated DNS addresses:"
    for ((i=0; i<count; i++)); do
        if [ "$ip_ver" == "4" ]; then
            echo "$(generate_ipv4_saudi)"
        else
            echo "$(generate_ipv6_saudi)"
        fi
    done
    pause_return
}

dns_generate_turkey() {
    header
    echo "Turkey DNS Generator"
    read -rp "IPv4 or IPv6? (4/6): " ip_ver
    if [[ "$ip_ver" != "4" && "$ip_ver" != "6" ]]; then
        echo -e "${RED}Invalid choice.${RESET}"
        pause_return
        return
    fi
    read -rp "How many DNS addresses do you want?: " count
    if ! [[ "$count" =~ ^[0-9]+$ ]]; then
        echo -e "${RED}Please enter a valid number.${RESET}"
        pause_return
        return
    fi
    echo
    echo "Generated DNS addresses:"
    for ((i=0; i<count; i++)); do
        if [ "$ip_ver" == "4" ]; then
            echo "$(generate_ipv4_turkey)"
        else
            echo "$(generate_ipv6_turkey)"
        fi
    done
    pause_return
}

dns_generate_uae() {
    header
    echo "United Arab Emirates DNS Generator"
    read -rp "IPv4 or IPv6? (4/6): " ip_ver
    if [[ "$ip_ver" != "4" && "$ip_ver" != "6" ]]; then
        echo -e "${RED}Invalid choice.${RESET}"
        pause_return
        return
    fi
    read -rp "How many DNS addresses do you want?: " count
    if ! [[ "$count" =~ ^[0-9]+$ ]]; then
        echo -e "${RED}Please enter a valid number.${RESET}"
        pause_return
        return
    fi
    echo
    echo "Generated DNS addresses:"
    for ((i=0; i<count; i++)); do
        if [ "$ip_ver" == "4" ]; then
            echo "$(generate_ipv4_uae)"
        else
            echo "$(generate_ipv6_uae)"
        fi
    done
    pause_return
}

# === Main Menu ===
main_menu() {
    while true; do
        header
        echo "Main Menu:"
        echo "1) Mobile Games DNS"
        echo "2) PC Games DNS"
        echo "3) Console Games DNS"
        echo "4) Download DNS (VPN-Friendly)"
        echo "5) DNS Generators"
        echo "6) Exit"
        echo
        read -rp "Enter number: " choice
        case $choice in
            1) game_menu "Mobile" ;;
            2) game_menu "PC" ;;
            3) game_menu "Console" ;;
            4) download_dns ;;
            5) dns_generator_menu ;;
            6) echo "Goodbye!"; exit 0 ;;
            *) echo -e "${RED}Invalid option. Try again.${RESET}"; pause_return ;;
        esac
    done
}

# === Game menus ===

# For demonstration, PC and Console games are less populated

pc_games=(
    "Valorant"
    "Counter Strike Global Offensive"
    "Call of Duty Warzone"
    "Minecraft Java Edition"
    "Fortnite"
    "Apex Legends"
    "Overwatch"
    "Dota 2"
    "League of Legends"
    "Rainbow Six Siege"
)

console_games=(
    "FIFA 23"
    "Call of Duty Modern Warfare"
    "Halo Infinite"
    "The Last of Us"
    "God of War"
    "Gears of War"
    "Spider-Man"
    "Red Dead Redemption 2"
    "Fortnite Console"
    "Minecraft Console Edition"
)

# DNS entries (fake but realistic examples for PC and Console)
for game in "${pc_games[@]}"; do
    for country in "${countries[@]}"; do
        key="${game}-${country}"
        dns_map["$key"]="8.8.8.8|8.8.4.4,1.1.1.1|1.0.0.1,9.9.9.9|149.112.112.112"
    done
done

for game in "${console_games[@]}"; do
    for country in "${countries[@]}"; do
        key="${game}-${country}"
        dns_map["$key"]="208.67.222.222|208.67.220.220,8.8.8.8|8.8.4.4,1.1.1.1|1.0.0.1"
    done
done

game_menu() {
    local category="$1"
    local games_list

    case $category in
        Mobile) games_list=("${mobile_games[@]}") ;;
        PC) games_list=("${pc_games[@]}") ;;
        Console) games_list=("${console_games[@]}") ;;
        *) echo "Unknown category"; return ;;
    esac

    while true; do
        header
        echo "$category Games:"
        for i in "${!games_list[@]}"; do
            echo "$((i+1))) ${games_list[i]}"
        done
        echo "$(( ${#games_list[@]} + 1 ))) Back to main menu"
        echo
        read -rp "Select a game by number: " game_choice

        if ! [[ "$game_choice" =~ ^[0-9]+$ ]] || (( game_choice < 1 || game_choice > ${#games_list[@]} + 1 )); then
            echo -e "${RED}Invalid choice, try again.${RESET}"
            pause_return
            continue
        fi

        if (( game_choice == ${#games_list[@]} + 1 )); then
            return
        fi

        local selected_game="${games_list[game_choice-1]}"
        country_menu "$category" "$selected_game"
    done
}

country_menu() {
    local category="$1"
    local game="$2"

    while true; do
        header
        echo "Game: $game"
        echo "Select Country:"
        for i in "${!countries[@]}"; do
            echo "$((i+1))) ${countries[i]}"
        done
        echo "$(( ${#countries[@]} + 1 )) ) Back to $category Games Menu"
        echo
        read -rp "Select country by number: " country_choice

        if ! [[ "$country_choice" =~ ^[0-9]+$ ]] || (( country_choice < 1 || country_choice > ${#countries[@]} + 1 )); then
            echo -e "${RED}Invalid choice, try again.${RESET}"
            pause_return
            continue
        fi

        if (( country_choice == ${#countries[@]} + 1 )); then
            return
        fi

        local selected_country="${countries[country_choice-1]}"
        show_dns "$game" "$selected_country"
    done
}

show_dns() {
    local game="$1"
    local country="$2"
    local key="${game}-${country}"
    local dns_list="${dns_map[$key]}"

    header
    echo "Game: $game"
    echo "Country: $country"
    echo "---------------------------------"
    local i=1
    IFS=',' read -ra dns_arr <<< "$dns_list"
    for dns_pair in "${dns_arr[@]}"; do
        IFS='|' read -ra ips <<< "$dns_pair"
        echo "$i. Primary: ${ips[0]} | Secondary: ${ips[1]}"
        ((i++))
    done
    echo
    ping_reminder
    pause_return
}

# Download DNS (VPN-Friendly example)
download_dns() {
    header
    echo "Download DNS (VPN-Friendly, including unblockers):"
    echo "1) Cloudflare DNS - 1.1.1.1 | 1.0.0.1"
    echo "2) Google DNS - 8.8.8.8 | 8.8.4.4"
    echo "3) Quad9 DNS - 9.9.9.9 | 149.112.112.112"
    echo "4) OpenDNS - 208.67.222.222 | 208.67.220.220"
    echo "5) Back to Main Menu"
    echo
    read -rp "Choose an option: " dl_choice
    case $dl_choice in
        1)
            echo -e "\nPrimary: 1.1.1.1 | Secondary: 1.0.0.1"
            ping_reminder
            pause_return
            ;;
        2)
            echo -e "\nPrimary: 8.8.8.8 | Secondary: 8.8.4.4"
            ping_reminder
            pause_return
            ;;
        3)
            echo -e "\nPrimary: 9.9.9.9 | Secondary: 149.112.112.112"
            ping_reminder
            pause_return
            ;;
        4)
            echo -e "\nPrimary: 208.67.222.222 | Secondary: 208.67.220.220"
            ping_reminder
            pause_return
            ;;
        5)
            return
            ;;
        *)
            echo -e "${RED}Invalid option, returning to main menu.${RESET}"
            pause_return
            ;;
    esac
}

# Start script
main_menu
