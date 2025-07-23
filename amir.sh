#!/bin/bash

# ======================
# Academi Game & Country DNS Manager v1.2.5
# Telegram: @Academii73
# Admin By: @MahdiAGM0
# ======================

# Colors for fancy title box & outputs
colors=(
"\e[91m" # Red
"\e[92m" # Green
"\e[93m" # Yellow
"\e[94m" # Blue
"\e[95m" # Magenta
"\e[96m" # Cyan
)

reset_color="\e[0m"

# Pick a random color for title box each run
color="${colors[$RANDOM % ${#colors[@]}]}"

# Title Box
print_title() {
    clear
    echo -e "${color}==============================================="
    echo -e "     Academi Game & Country DNS Manager        "
    echo -e "                 Version: 1.2.5                 "
    echo -e "           Telegram: @Academii73                "
    echo -e "           Admin By: @MahdiAGM0                 "
    echo -e "===============================================${reset_color}\n"
}

# Wait for user to press enter then go to main menu
pause_return() {
    echo
    read -rp "Press Enter to return to main menu..."
}

# --------------- Data Section ---------------

# Countries List (Including Iran, Saudi Arabia, Turkey, UAE and more)
countries=(
"Iran"
"Saudi Arabia"
"Turkey"
"United Arab Emirates"
"USA"
"Germany"
"France"
"UK"
"Japan"
"South Korea"
)

# DNS Ranges for DNS Generate per country
declare -A dns_ranges_ipv4=(
    ["Iran"]="185.51.200"
    ["Saudi Arabia"]="188.0.0"
    ["Turkey"]="178.132.0"
    ["United Arab Emirates"]="185.190.0"
)

declare -A dns_ranges_ipv6=(
    ["Iran"]="2a01:5e00"
    ["Saudi Arabia"]="2a03:2880"
    ["Turkey"]="2a02:5180"
    ["United Arab Emirates"]="2a05:d018"
)

# Download/Bypass DNS list (fast, low ping, reliable)
download_dns=(
"1.1.1.1"      "1.0.0.1"      # Cloudflare
"8.8.8.8"      "8.8.4.4"      # Google DNS
"94.140.14.14" "94.140.15.15" # AdGuard DNS
"208.67.222.222" "208.67.220.220" # OpenDNS
"64.6.64.6"    "64.6.65.6"    # Verisign
)

# Games lists with DNS (each game has a DNS array)
# Sample of structure shown, full 40 games & 50 DNS each to be added similarly

# Console Games List (40 games sample)
console_games=(
"Call of Duty"
"FIFA 22"
"Fortnite"
"God of War"
"Halo Infinite"
"Minecraft"
"NBA 2K22"
"Spider-Man"
"The Last of Us"
"Resident Evil"
"Assassin's Creed"
"Mortal Kombat"
"Gran Turismo"
"Rocket League"
"Cyberpunk 2077"
"Overwatch"
"Street Fighter"
"Tekken"
"Battlefield"
"Destiny 2"
"Dark Souls"
"Far Cry"
"Ghost of Tsushima"
"Crash Bandicoot"
"Red Dead Redemption"
"Super Smash Bros"
"Monster Hunter"
"Watch Dogs"
"Call of Duty: Warzone"
"League of Legends"
"Valorant"
"Doom Eternal"
"Death Stranding"
"Rainbow Six Siege"
"Among Us"
"Splatoon 2"
"Final Fantasy"
"Godfall"
"Hades"
"Sea of Thieves"
)

# Mobile Games List (including that special game you mentioned + 39 others)
mobile_games=(
"PUBG Mobile"
"Clash of Clans"
"Free Fire"
"Call of Duty Mobile"
"Mobile Legends"
"Among Us"
"Roblox Mobile"
"Genshin Impact"
"Fortnite Mobile"
"Clash Royale"
"Garena Speed Drifters"
"Subway Surfers"
"Pokemon Go"
"AFK Arena"
"State of Survival"
"Coin Master"
"Brawl Stars"
"Summoners War"
"8 Ball Pool"
"World of Warcraft Mobile"
"Legends of Runeterra"
"Dragon Ball Legends"
"Marvel Future Fight"
"Lineage 2"
"Vainglory"
"FIFA Mobile"
"Shadowgun Legends"
"Mobile Strike"
"Clash of Kings"
"Idle Heroes"
"Call of Mini"
"Shadow Fight"
"Battlelands Royale"
"Archero"
"Knives Out"
"King of Avalon"
"Dragon Raja"
"Albion Online"
"Raid: Shadow Legends"
"Magic: The Gathering"
)

# PC Games List (40 games sample)
pc_games=(
"CS:GO"
"Dota 2"
"Valorant"
"Fortnite PC"
"League of Legends PC"
"Overwatch PC"
"Apex Legends"
"Minecraft PC"
"Cyberpunk 2077 PC"
"World of Warcraft"
"Rainbow Six Siege PC"
"Fall Guys"
"Among Us PC"
"PUBG PC"
"Rocket League PC"
"Terraria"
"Final Fantasy XIV"
"Battlefield V"
"The Witcher 3"
"Starcraft II"
"Team Fortress 2"
"GTA V PC"
"Dead by Daylight"
"Left 4 Dead 2"
"Portal 2"
"Diablo III"
"Warframe"
"ARK: Survival Evolved"
"League of Legends"
"Destiny 2 PC"
"Dark Souls III"
"Assassin's Creed Odyssey"
"Metro Exodus"
"Borderlands 3"
"Monster Hunter World"
"Halo: The Master Chief Collection"
"Star Wars Jedi: Fallen Order"
"Fallout 4"
)

# DNS for each game and country (this is a demo, real DNSs must be populated accordingly)
# For brevity, here just a small set, but in your actual script expand to 50+ per game

declare -A game_dns_console
declare -A game_dns_mobile
declare -A game_dns_pc

# Example of adding some DNS entries for a game in Iran:
game_dns_console["Call of Duty-Iran"]="185.51.200.1 185.51.200.2 185.51.200.3 185.51.200.4 185.51.200.5"
game_dns_mobile["PUBG Mobile-Iran"]="185.51.200.10 185.51.200.11 185.51.200.12 185.51.200.13 185.51.200.14"
game_dns_pc["CS:GO-Iran"]="185.51.200.20 185.51.200.21 185.51.200.22 185.51.200.23 185.51.200.24"

# Similar entries for other countries & games would be added here...

# ---------------- Function Section -------------------

# Generate DNS for given country & IP version (IPv4/IPv6) and count
generate_dns() {
    local country="$1"
    local ip_version="$2"
    local count="$3"
    local base_ipv4=${dns_ranges_ipv4[$country]}
    local base_ipv6=${dns_ranges_ipv6[$country]}

    echo -e "\nGenerated DNS addresses for $country ($ip_version):"
    for ((i=1; i<=count; i++)); do
        if [[ $ip_version == "4" ]]; then
            octet=$((RANDOM % 255))
            dns="$base_ipv4.$octet"
            echo "$i. $dns"
        else
            # IPv6 generate example range + random suffix
            r1=$(printf '%x' $((RANDOM % 65535)))
            r2=$(printf '%x' $((RANDOM % 65535)))
            r3=$(printf '%x' $((RANDOM % 65535)))
            dns="$base_ipv6:$r1:$r2::$r3"
            echo "$i. $dns"
        fi
    done
}

# Print list with numbering
print_list() {
    local arr=("$@")
    for i in "${!arr[@]}"; do
        echo "$((i+1))) ${arr[$i]}"
    done
}

# Select DNS for Game and Country - pick two random DNSs from that list
select_dns_for_game() {
    local category="$1" # console, mobile, pc
    local game="$2"
    local country="$3"

    local key="${game}-${country}"
    local dns_list_var="game_dns_${category}[$key]"
    local dns_list

    # indirect reference to associative array
    if [[ "$category" == "console" ]]; then
        dns_list="${game_dns_console[$key]}"
    elif [[ "$category" == "mobile" ]]; then
        dns_list="${game_dns_mobile[$key]}"
    else
        dns_list="${game_dns_pc[$key]}"
    fi

    if [[ -z "$dns_list" ]]; then
        echo "No DNS found for $game in $country."
        return 1
    fi

    # Convert dns_list string to array
    IFS=' ' read -r -a dns_array <<< "$dns_list"

    # Pick 2 random unique DNS from dns_array
    len=${#dns_array[@]}
    if (( len < 2 )); then
        echo "Not enough DNS entries for $game in $country."
        return 1
    fi

    idx1=$((RANDOM % len))
    idx2=$((RANDOM % len))
    while [ "$idx2" -eq "$idx1" ]; do
        idx2=$((RANDOM % len))
    done

    echo "Primary DNS: ${dns_array[$idx1]}"
    echo "Secondary DNS: ${dns_array[$idx2]}"

    # Optionally show ping result for primary DNS
    echo -n "Pinging primary DNS (${dns_array[$idx1]}) ... "
    ping -c 1 -W 1 "${dns_array[$idx1]}" &> /dev/null
    if [ $? -eq 0 ]; then
        echo "Success"
    else
        echo "Failed"
    fi
}

# Auto Benchmark: Ping all DNSs and display results
auto_benchmark() {
    echo -e "\nAuto Benchmarking all DNS servers (this may take some time)..."
    echo "DNS Address | Ping Result (ms)"
    echo "------------------------------"

    # Combine all DNS lists for test (download_dns + generated DNS + all games DNS)
    all_dns=()

    # Add download DNS
    for d in "${download_dns[@]}"; do
        all_dns+=("$d")
    done

    # Add DNS from games (for brevity, only a subset)
    for key in "${!game_dns_console[@]}"; do
        IFS=' ' read -r -a dns_arr <<< "${game_dns_console[$key]}"
        for dns in "${dns_arr[@]}"; do
            all_dns+=("$dns")
        done
    done
    for key in "${!game_dns_mobile[@]}"; do
        IFS=' ' read -r -a dns_arr <<< "${game_dns_mobile[$key]}"
        for dns in "${dns_arr[@]}"; do
            all_dns+=("$dns")
        done
    done
    for key in "${!game_dns_pc[@]}"; do
        IFS=' ' read -r -a dns_arr <<< "${game_dns_pc[$key]}"
        for dns in "${dns_arr[@]}"; do
            all_dns+=("$dns")
        done
    done

    # Test ping for each DNS and print result
    for dns in "${all_dns[@]}"; do
        ping -c 1 -W 1 "$dns" &> /dev/null
        if [ $? -eq 0 ]; then
            ping_ms=$(ping -c 1 "$dns" | grep 'time=' | awk -F'time=' '{print $2}' | awk '{print $1}')
            echo "$dns | $ping_ms ms"
        else
            echo "$dns | Timeout/No response"
        fi
    done

    echo -e "\nBenchmark complete."
    pause_return
}

# Auto Mode: Automatically pick best DNS from download_dns by ping
auto_mode() {
    echo -e "\nAuto Mode: Selecting best DNS from trusted download DNS servers..."
    best_dns=""
    best_ping=9999

    for dns in "${download_dns[@]}"; do
        ping -c 1 -W 1 "$dns" &> /dev/null
        if [ $? -eq 0 ]; then
            ping_ms=$(ping -c 1 "$dns" | grep 'time=' | awk -F'time=' '{print $2}' | awk '{print $1}')
            ping_ms_int=${ping_ms%.*}
            if (( ping_ms_int < best_ping )); then
                best_ping=$ping_ms_int
                best_dns=$dns
            fi
        fi
    done

    if [[ -z $best_dns ]]; then
        echo "No DNS servers responded in Auto Mode."
    else
        echo "Best DNS server selected: $best_dns with ping $best_ping ms"
    fi

    pause_return
}

# ------------------ Menu Section -------------------

# Main menu
main_menu() {
    while true; do
        print_title
        echo "Main Menu:"
        echo "1) DNS Generate"
        echo "2) Games Menu"
        echo "3) Auto Mode"
        echo "4) DNS Download (Bypass/Unblock)"
        echo "5) Auto Benchmark"
        echo "0) Exit"
        echo
        read -rp "Select an option: " main_choice

        case "$main_choice" in
            1) dns_generate_menu ;;
            2) games_menu ;;
            3) auto_mode ;;
            4) download_dns_menu ;;
            5) auto_benchmark ;;
            0) echo "Exiting..."; exit 0 ;;
            *) echo "Invalid option!"; sleep 1 ;;
        esac
    done
}

# DNS Generate submenu
dns_generate_menu() {
    print_title
    echo "DNS Generate Countries:"
    print_list "${!dns_ranges_ipv4[@]}"
    echo "0) Back to Main Menu"
    echo
    read -rp "Select country: " country_choice

    if [[ "$country_choice" == "0" ]]; then return; fi

    country_keys=("${!dns_ranges_ipv4[@]}")
    country="${country_keys[$((country_choice-1))]}"

    if [[ -z "$country" ]]; then
        echo "Invalid country selection!"
        pause_return
        return
    fi

    # Ask IPv4 or IPv6
    echo
    echo "Select IP Version:"
    echo "1) IPv4"
    echo "2) IPv6"
    read -rp "Choose 1 or 2: " ip_ver_choice

    if [[ "$ip_ver_choice" == "1" ]]; then ip_ver="4"
    elif [[ "$ip_ver_choice" == "2" ]]; then ip_ver="6"
    else
        echo "Invalid IP version choice!"
        pause_return
        return
    fi

    read -rp "How many DNS addresses do you want to generate? " count
    if ! [[ "$count" =~ ^[0-9]+$ ]] || (( count <= 0 )); then
        echo "Invalid number!"
        pause_return
        return
    fi

    generate_dns "$country" "$ip_ver" "$count"
    pause_return
}

# Games menu
games_menu() {
    while true; do
        print_title
        echo "Games Menu:"
        echo "1) Console Games"
        echo "2) Mobile Games"
        echo "3) PC Games"
        echo "0) Back to Main Menu"
        echo
        read -rp "Select category: " cat_choice

        case "$cat_choice" in
            1) select_game "console" ;;
            2) select_game "mobile" ;;
            3) select_game "pc" ;;
            0) return ;;
            *) echo "Invalid option!"; sleep 1 ;;
        esac
    done
}

# Select game from list
select_game() {
    local category="$1"
    local games_arr

    if [[ "$category" == "console" ]]; then games_arr=("${console_games[@]}")
    elif [[ "$category" == "mobile" ]]; then games_arr=("${mobile_games[@]}")
    else games_arr=("${pc_games[@]}"); fi

    while true; do
        print_title
        echo "Select a game from $category:"
        print_list "${games_arr[@]}"
        echo "0) Back"
        echo
        read -rp "Your choice: " game_choice

        if [[ "$game_choice" == "0" ]]; then return; fi

        if ! [[ "$game_choice" =~ ^[0-9]+$ ]] || (( game_choice < 1 || game_choice > ${#games_arr[@]} )); then
            echo "Invalid choice!"
            sleep 1
            continue
        fi

        selected_game="${games_arr[$((game_choice-1))]}"

        # Choose country for DNS
        print_title
        echo "Select Country for DNS of $selected_game:"
        print_list "${countries[@]}"
        echo "0) Back"
        echo
        read -rp "Your choice: " country_choice

        if [[ "$country_choice" == "0" ]]; then return; fi

        if ! [[ "$country_choice" =~ ^[0-9]+$ ]] || (( country_choice < 1 || country_choice > ${#countries[@]} )); then
            echo "Invalid choice!"
            sleep 1
            continue
        fi

        selected_country="${countries[$((country_choice-1))]}"

        # Show DNS for selected game & country
        print_title
        echo "DNS for $selected_game in $selected_country:"
        select_dns_for_game "$category" "$selected_game" "$selected_country"
        pause_return
        return
    done
}

# Download DNS menu
download_dns_menu() {
    print_title
    echo "Download/Bypass DNS servers:"
    for ((i=0; i<${#download_dns[@]}; i+=2)); do
        echo "$((i/2+1))) Primary: ${download_dns[i]} | Secondary: ${download_dns[i+1]}"
    done
    pause_return
}

# ----------------- Main ------------------------

main_menu
