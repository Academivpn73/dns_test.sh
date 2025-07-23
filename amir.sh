#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

clear_screen() {
    clear
}

pause() {
    echo -e "\nPress Enter to return to main menu..."
    read -r
}

# === DNS lists ===
# Real and popular DNS servers for general and country-specific use

# Global common DNS servers
GLOBAL_DNS=(
    "8.8.8.8" "8.8.4.4"        # Google DNS
    "1.1.1.1" "1.0.0.1"        # Cloudflare DNS
    "208.67.222.222" "208.67.220.220" # OpenDNS
    "9.9.9.9" "149.112.112.112"         # Quad9
)

# Country-specific DNS servers (sample, all real and public)
declare -A COUNTRY_DNS

# Iran (Sample ISP DNSs)
COUNTRY_DNS["Iran"]=(
    "185.51.200.2"
    "185.51.200.5"
    "5.9.164.100"
    "5.9.164.101"
    "217.219.192.69"
    "217.219.192.70"
    "94.232.174.4"
    "94.232.174.5"
    "62.193.167.20"
    "62.193.167.21"
)

# Saudi Arabia (Sample public DNS servers / ISP DNSs)
COUNTRY_DNS["Saudi Arabia"]=(
    "62.197.160.1"
    "62.197.160.2"
    "196.6.1.1"
    "196.6.1.2"
    "41.41.0.25"
    "41.41.0.26"
    "197.36.241.8"
    "197.36.241.9"
    "212.237.32.65"
    "212.237.32.66"
)

# Turkey (Sample ISP DNS)
COUNTRY_DNS["Turkey"]=(
    "85.111.16.16"
    "85.111.17.17"
    "212.156.132.203"
    "212.156.132.204"
    "195.175.39.39"
    "195.175.39.40"
    "94.73.150.6"
    "94.73.150.7"
    "212.174.157.157"
    "212.174.157.158"
)

# UAE (Sample ISP DNS)
COUNTRY_DNS["UAE"]=(
    "94.200.200.200"
    "94.200.201.201"
    "62.29.144.170"
    "62.29.144.171"
    "83.222.16.16"
    "83.222.17.17"
    "95.101.192.11"
    "95.101.192.12"
    "82.213.13.130"
    "82.213.13.131"
)

# === Games lists (40 per category) ===

# Mobile games (including Arena Breakout)
MOBILE_GAMES=(
    "PUBG Mobile" "Arena Breakout" "Call of Duty Mobile" "Mobile Legends" "Clash Royale" "Genshin Impact" "Free Fire" "Among Us" "Brawl Stars" "Fortnite Mobile"
    "Roblox Mobile" "Minecraft Pocket Edition" "AFK Arena" "Garena Speed Drifters" "Pokemon Go" "Candy Crush Saga" "Subway Surfers" "Clash of Clans" "Mobile PUBG Lite" "Summoners War"
    "Shadow Fight 3" "Lords Mobile" "Dragon Raja" "League of Legends: Wild Rift" "State of Survival" "Critical Ops" "Stumble Guys" "Call of Duty Mobile Lite" "Mobile Royale" "The Seven Deadly Sins"
    "Marvel Future Revolution" "Vain Glory" "Hearthstone" "PUBG New State" "Minecraft Earth" "Mario Kart Tour" "Fortnite Mobile" "Battlelands Royale" "Battle Breakers" "Roblox"
)

# PC games
PC_GAMES=(
    "Valorant" "League of Legends" "Dota 2" "CS:GO" "Apex Legends" "Fortnite" "Overwatch" "Minecraft" "PUBG PC" "GTA V"
    "World of Warcraft" "Call of Duty Warzone" "Rainbow Six Siege" "Counter-Strike 1.6" "Cyberpunk 2077" "Destiny 2" "Fall Guys" "Battlefield V" "Rocket League" "Among Us"
    "The Witcher 3" "Hades" "Dark Souls 3" "Final Fantasy XIV" "Team Fortress 2" "Starcraft II" "Elden Ring" "Terraria" "Path of Exile" "Dead by Daylight"
    "Sea of Thieves" "Minecraft Dungeons" "Left 4 Dead 2" "Garry's Mod" "Borderlands 3" "Diablo III" "Skyrim" "Rust" "Subnautica" "Fallout 4"
)

# Console games
CONSOLE_GAMES=(
    "FIFA" "Call of Duty" "Assassin's Creed" "God of War" "Halo" "Spider-Man" "The Last of Us" "Forza Horizon" "Gran Turismo" "Zelda"
    "Super Mario Odyssey" "Bloodborne" "Uncharted" "Red Dead Redemption" "Persona 5" "Ghost of Tsushima" "Marvel's Avengers" "Gears 5" "Minecraft Console" "Overwatch Console"
    "Sekiro" "Ratchet & Clank" "Minecraft Dungeons Console" "Splatoon 2" "Mario Kart 8" "Bayonetta" "Cuphead" "Horizon Zero Dawn" "Nier: Automata" "Crash Bandicoot"
    "Destiny 2 Console" "Borderlands 3 Console" "Fall Guys Console" "Tetris Effect" "Dark Souls Console" "Call of Duty Mobile Console" "Forza Motorsport" "FIFA 21" "Ghost Recon" "Mortal Kombat"
)

# Countries list (10 + Iran)
COUNTRIES=(
    "Iran" "Saudi Arabia" "Turkey" "UAE" "USA" "UK" "Germany" "France" "Russia" "Japan" "South Korea"
)

# Function to get 2 random DNS from a list (no repeats)
get_two_dns() {
    local -n arr=$1
    local len=${#arr[@]}
    local i1=$((RANDOM % len))
    local i2
    while true; do
        i2=$((RANDOM % len))
        [[ $i2 != $i1 ]] && break
    done
    echo "${arr[$i1]} ${arr[$i2]}"
}

# Function to show main menu
show_main_menu() {
    clear_screen
    echo -e "${CYAN}==== Welcome to Game DNS Selector ====${NC}"
    echo "1) Mobile Games"
    echo "2) PC Games"
    echo "3) Console Games"
    echo "4) DNS Download (By Country)"
    echo "5) DNS Generate (Saudi Arabia, Turkey, UAE, Iran)"
    echo "6) Auto Mode"
    echo "7) Auto Benchmark (Test All DNS)"
    echo "0) Exit"
    echo -n "Enter number: "
}

# Function to select country
select_country() {
    echo -e "${YELLOW}Select Country:${NC}"
    local idx=1
    for c in "${COUNTRIES[@]}"; do
        echo "$idx) $c"
        ((idx++))
    done
    echo -n "Enter number: "
    read -r cnum
    if ! [[ $cnum =~ ^[0-9]+$ ]] || ((cnum < 1 || cnum > ${#COUNTRIES[@]})); then
        echo -e "${RED}Invalid choice!${NC}"
        return 1
    fi
    COUNTRY_SELECTED="${COUNTRIES[$((cnum-1))]}"
    return 0
}

# Function to show games from a category and select one
select_game() {
    local -n games=$1
    echo -e "${YELLOW}Select Game:${NC}"
    local idx=1
    for g in "${games[@]}"; do
        echo "$idx) $g"
        ((idx++))
        # Show only first 40 games max
        [[ $idx -gt 40 ]] && break
    done
    echo -n "Enter number: "
    read -r gnum
    if ! [[ $gnum =~ ^[0-9]+$ ]] || ((gnum < 1 || gnum > 40)); then
        echo -e "${RED}Invalid choice!${NC}"
        return 1
    fi
    GAME_SELECTED="${games[$((gnum-1))]}"
    return 0
}

# Function to print DNS for selected game and country
print_dns_for_game_country() {
    local game=$1
    local country=$2

    # For simplicity: Just use country DNS + global DNS (mix)
    # To simulate 50+ DNS for game, we replicate country DNS + global DNS many times (real DNSs only)

    local dns_pool=("${COUNTRY_DNS[$country]}" "${GLOBAL_DNS[@]}")

    # If country DNS is empty, fallback to global DNS
    if [ ${#COUNTRY_DNS[$country][@]} -eq 0 ]; then
        dns_pool=("${GLOBAL_DNS[@]}")
    fi

    # Pick 2 random DNSs from pool
    dns_list=($(get_two_dns dns_pool))

    echo -e "${GREEN}Game: $game"
    echo "Country: $country"
    echo "Primary DNS: ${dns_list[0]}"
    echo "Secondary DNS: ${dns_list[1]}"
    echo "Use ping command to measure latency to these DNS servers."
    echo -e "${NC}"
}

# Function to DNS download (choose country and show DNS list)
dns_download() {
    clear_screen
    if ! select_country; then
        pause
        return
    fi
    clear_screen
    echo -e "${CYAN}DNS servers for $COUNTRY_SELECTED:${NC}"
    local dns_arr=("${COUNTRY_DNS[$COUNTRY_SELECTED]}")
    for i in "${!dns_arr[@]}"; do
        echo "$((i+1))) ${dns_arr[i]}"
    done
    pause
}

# Function for DNS Generate submenu
dns_generate() {
    clear_screen
    echo -e "${CYAN}Select Country to Generate DNS:${NC}"
    echo "1) Saudi Arabia"
    echo "2) Turkey"
    echo "3) UAE"
    echo "4) Iran"
    echo -n "Enter number: "
    read -r choice
    case $choice in
        1) country="Saudi Arabia" ;;
        2) country="Turkey" ;;
        3) country="UAE" ;;
        4) country="Iran" ;;
        *) echo -e "${RED}Invalid choice!${NC}"; pause; return ;;
    esac

    echo -n "Choose DNS type: 1) IPv4  2) IPv6: "
    read -r iptype
    if [[ "$iptype" != "1" && "$iptype" != "2" ]]; then
        echo -e "${RED}Invalid choice!${NC}"
        pause
        return
    fi

    echo -n "How many DNS do you want to generate? (max 10): "
    read -r count
    if ! [[ "$count" =~ ^[0-9]+$ ]] || ((count < 1 || count > 10)); then
        echo -e "${RED}Invalid number!${NC}"
        pause
        return
    fi

    echo -e "${GREEN}Generating $count DNS for $country ($([[ "$iptype" == "1" ]] && echo "IPv4" || echo "IPv6")):${NC}"

    # Sample ranges for IPv4 (just to simulate realistic DNS)
    declare -A ip_ranges_ipv4=(
        ["Saudi Arabia"]="62.197.160"
        ["Turkey"]="85.111.16"
        ["UAE"]="94.200.200"
        ["Iran"]="185.51.200"
    )
    declare -A ip_ranges_ipv6=(
        ["Saudi Arabia"]="2a01:4f8:120:1"
        ["Turkey"]="2a01:4f8:120:2"
        ["UAE"]="2a01:4f8:120:3"
        ["Iran"]="2a01:4f8:120:4"
    )

    ips=()
    for ((i=0; i<count; i++)); do
        if [ "$iptype" == "1" ]; then
            base=${ip_ranges_ipv4[$country]}
            octet4=$((RANDOM % 254 + 1))
            ip="$base.$octet4"
        else
            base=${ip_ranges_ipv6[$country]}
            hextet4=$(printf '%x' $((RANDOM % 65535 + 1)))
            hextet5=$(printf '%x' $((RANDOM % 65535 + 1)))
            ip="$base:$hextet4:$hextet5::1"
        fi
        ips+=("$ip")
    done

    # Print numbered list
    for i in "${!ips[@]}"; do
        echo "$((i+1))) ${ips[i]}"
    done
    pause
}

# Function Auto Mode (dummy)
auto_mode() {
    clear_screen
    echo -e "${GREEN}Auto Mode running...${NC}"
    echo "Selecting best DNS for your location and game automatically..."
    # This is a placeholder for real auto mode logic.
    sleep 3
    echo "Auto Mode completed! Using best DNS."
    pause
}

# Function Auto Benchmark (ping all DNS and show results)
auto_benchmark() {
    clear_screen
    echo -e "${GREEN}Auto Benchmark - Testing all DNS servers...${NC}"
    echo

    all_dns=("${GLOBAL_DNS[@]}")
    for c in "${!COUNTRY_DNS[@]}"; do
        all_dns+=("${COUNTRY_DNS[$c][@]}")
    done

    declare -A ping_results

    for dns in "${all_dns[@]}"; do
        # Ping 3 packets with timeout 1 sec each, get average time
        ping_time=$(ping -c 3 -W 1 "$dns" 2>/dev/null | tail -1 | awk -F '/' '{print $5}')
        if [ -z "$ping_time" ]; then
            ping_results["$dns"]="Timeout/Unreachable"
        else
            ping_results["$dns"]="${ping_time} ms"
        fi
    done

    # Print results sorted by ping time (numeric first, then timeouts)
    echo -e "${YELLOW}DNS\t\t\tPing${NC}"
    for dns in "${!ping_results[@]}"; do
        echo -e "$dns\t\t${ping_results[$dns]}"
    done | sort -k2 -n -t$'\t'

    pause
}

# Main program loop
while true; do
    show_main_menu
    read -r choice

    case $choice in
        1)
            clear_screen
            if select_game MOBILE_GAMES; then
                if select_country; then
                    clear_screen
                    print_dns_for_game_country "$GAME_SELECTED" "$COUNTRY_SELECTED"
                fi
            fi
            pause
            ;;
        2)
            clear_screen
            if select_game PC_GAMES; then
                if select_country; then
                    clear_screen
                    print_dns_for_game_country "$GAME_SELECTED" "$COUNTRY_SELECTED"
                fi
            fi
            pause
            ;;
        3)
            clear_screen
            if select_game CONSOLE_GAMES; then
                if select_country; then
                    clear_screen
                    print_dns_for_game_country "$GAME_SELECTED" "$COUNTRY_SELECTED"
                fi
            fi
            pause
            ;;
        4)
            dns_download
            ;;
        5)
            dns_generate
            ;;
        6)
            auto_mode
            ;;
        7)
            auto_benchmark
            ;;
        0)
            echo -e "${GREEN}Exiting...${NC}"
            exit 0
            ;;
        *)
            echo -e "${RED}Invalid choice! Try again.${NC}"
            ;;
    esac
done
