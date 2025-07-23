#!/bin/bash

# Color codes
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
    echo -e "║                    Version : 1.3.5                         ║"
    echo -e "╚════════════════════════════════════════════════════════════╝${RESET}"
    echo
}

pause_return() {
    echo
    read -rp "Press Enter to return to main menu..."
}

# --- DNS Generators ---
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
    printf "2a02:%04x:%04x::%04x:%04x\n" $((RANDOM%65536)) $((RANDOM%65536)) $((RANDOM%65536)) $((RANDOM%65536))
}

generate_ipv4_uae() {
    echo "185.$((RANDOM%256)).$((RANDOM%256)).$((RANDOM%256))"
}
generate_ipv6_uae() {
    printf "2a02:%04x:%04x::%04x:%04x\n" $((RANDOM%65536)) $((RANDOM%65536)) $((RANDOM%65536)) $((RANDOM%65536))
}

dns_generate() {
    local country="$1"
    header
    echo "DNS Generator for $country"
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
        else
            echo "No generator available for $country"
        fi
    done
    pause_return
}

# --- Countries list ---
countries=(
"USA" "UK" "Germany" "France" "Japan" "South Korea" "India" "Brazil" "Canada" "Australia" "Iran" "Saudi Arabia" "Turkey" "UAE" "Russia" "Netherlands" "Singapore" "Sweden" "Italy" "Spain"
)

# --- Games lists ---
games_mobile=(
"PUBG Mobile"
"Call of Duty Mobile"
"Free Fire"
"Arena Breakout"
"Genshin Impact"
"Mobile Legends"
"Among Us"
"Clash of Clans"
"Pokemon Go"
"Roblox"
"Subway Surfers"
"BGMI"
"Minecraft Pocket Edition"
"League of Legends: Wild Rift"
"Call of Duty: Warzone Mobile"
"Mobile PUBG KR"
"Call of Duty Mobile VN"
"Call of Duty Mobile RU"
"FIFA Mobile"
"Garena Speed Drifters"
"Crash Bandicoot Mobile"
"Dragon Raja"
"Arknights"
"Marvel Future Revolution"
"Shadowgun Legends"
"Rules of Survival"
"State of Survival"
"Free Fire MAX"
"Call of Dragons"
"Call of Duty: Mobile (Global)"
"PUBG Mobile Lite"
"Battlelands Royale"
"Brawl Stars"
"Clash Royale"
"Raid: Shadow Legends"
"Among Us VR"
"Minecraft Dungeons"
"Call of Duty Mobile China"
"Call of Duty Mobile Taiwan"
)

games_pc=(
"Valorant"
"Fortnite"
"CS:GO"
"League of Legends"
"Minecraft"
"Dota 2"
"Call of Duty Warzone"
"PUBG PC"
"Apex Legends"
"Overwatch"
"Rainbow Six Siege"
"Counter Strike"
"Rust"
"Battlefield V"
"Among Us PC"
"Destiny 2"
"World of Warcraft"
"Diablo 3"
"Cyberpunk 2077"
"FIFA 22"
"ARK: Survival Evolved"
"Rocket League"
"Team Fortress 2"
"Terraria"
"Fall Guys"
"Dead by Daylight"
"Call of Duty Modern Warfare"
"Valorant Beta"
"League of Legends: TFT"
"Path of Exile"
"GTA V PC"
"Monster Hunter World"
"Sea of Thieves"
"Paladins"
"Warframe"
"PUBG Lite PC"
"Call of Duty Black Ops"
"Minecraft Java Edition"
"Battlefield 1"
)

games_console=(
"FIFA"
"Call of Duty"
"Minecraft Console"
"GTA V"
"Rocket League"
"The Last of Us"
"Halo Infinite"
"God of War"
"Spider-Man"
"Assassin's Creed"
"Mortal Kombat"
"Resident Evil"
"Super Mario Odyssey"
"Cyberpunk 2077 Console"
"Call of Duty Modern Warfare"
"Fall Guys Console"
"Fortnite Console"
"Ghost of Tsushima"
"Call of Duty Black Ops"
"NBA 2K"
"Zelda Breath of the Wild"
"Splatoon"
"Animal Crossing"
"Minecraft Dungeons Console"
"Street Fighter"
"Smash Bros"
"Overwatch Console"
"Borderlands 3"
"Mass Effect"
"Dark Souls"
"Metro Exodus"
"Persona 5"
"Uncharted"
"Halo 5"
"Dead Space"
"FIFA 21"
"Call of Duty Mobile Console"
"Final Fantasy"
"Watch Dogs"
"Battlefield V Console"
"Destiny 2 Console"
)

# --- DNS mapping for Mobile Games (Primary|Secondary|Ping) ---
declare -A dns_mobile=(
["PUBG Mobile-USA"]="8.8.8.8|8.8.4.4|15"
["PUBG Mobile-UK"]="1.1.1.1|1.0.0.1|20"
["PUBG Mobile-Germany"]="9.9.9.9|149.112.112.112|25"
["PUBG Mobile-Iran"]="185.51.200.2|185.51.200.3|35"
["PUBG Mobile-South Korea"]="8.8.8.8|8.8.4.4|18"
["Call of Duty Mobile-USA"]="8.8.8.8|8.8.4.4|22"
["Call of Duty Mobile-UK"]="1.1.1.1|1.0.0.1|27"
["Call of Duty Mobile-Germany"]="9.9.9.9|149.112.112.112|30"
["Free Fire-USA"]="8.8.8.8|8.8.4.4|18"
["Free Fire-UK"]="1.1.1.1|1.0.0.1|25"
["Arena Breakout-Iran"]="185.51.200.2|185.51.200.3|35"
["Genshin Impact-Japan"]="8.8.8.8|8.8.4.4|18"
["Mobile Legends-Singapore"]="1.1.1.1|1.0.0.1|22"
["Among Us-USA"]="8.8.8.8|8.8.4.4|20"
["Clash of Clans-UK"]="1.1.1.1|1.0.0.1|23"
["BGMI-India"]="8.8.8.8|8.8.4.4|16"
["Call of Duty Mobile-Vietnam"]="8.8.8.8|8.8.4.4|22"
["Free Fire MAX-Brazil"]="9.9.9.9|149.112.112.112|24"
["Mobile PUBG Korea-South Korea"]="8.8.8.8|8.8.4.4|18"
["Call of Duty Mobile Russia-Russia"]="9.9.9.9|149.112.112.112|28"
["FIFA Mobile-USA"]="8.8.8.8|8.8.4.4|20"
["Garena Speed Drifters-Singapore"]="1.1.1.1|1.0.0.1|22"
["Dragon Raja-China"]="185.51.200.2|185.51.200.3|32"
["Arknights-China"]="185.51.200.2|185.51.200.3|30"
["Rules of Survival-China"]="185.51.200.2|185.51.200.3|29"
)

# --- DNS mapping for PC Games ---
declare -A dns_pc=(
["Valorant-USA"]="8.8.8.8|8.8.4.4|22"
["Fortnite-UK"]="1.1.1.1|1.0.0.1|27"
["CS:GO-Germany"]="9.9.9.9|149.112.112.112|30"
["League of Legends-USA"]="8.8.8.8|8.8.4.4|25"
["Minecraft-USA"]="8.8.8.8|8.8.4.4|20"
["Dota 2-USA"]="8.8.8.8|8.8.4.4|22"
["Call of Duty Warzone-USA"]="1.1.1.1|1.0.0.1|28"
["PUBG PC-USA"]="8.8.8.8|8.8.4.4|26"
["Apex Legends-USA"]="8.8.8.8|8.8.4.4|30"
["Overwatch-USA"]="8.8.8.8|8.8.4.4|24"
)

# --- DNS mapping for Console Games ---
declare -A dns_console=(
["FIFA-USA"]="8.8.8.8|8.8.4.4|25"
["Call of Duty-USA"]="1.1.1.1|1.0.0.1|21"
["Minecraft Console-USA"]="8.8.8.8|8.8.4.4|20"
["GTA V-USA"]="8.8.8.8|8.8.4.4|26"
["Rocket League-USA"]="8.8.8.8|8.8.4.4|24"
)

select_game() {
    local platform="$1"
    local games_list
    local dns_map

    case $platform in
        mobile)
            games_list=("${games_mobile[@]}")
            dns_map="dns_mobile"
            ;;
        pc)
            games_list=("${games_pc[@]}")
            dns_map="dns_pc"
            ;;
        console)
            games_list=("${games_console[@]}")
            dns_map="dns_console"
            ;;
        *)
            echo -e "${RED}Invalid platform!${RESET}"
            pause_return
            return
            ;;
    esac

    while true; do
        header
        echo "Select a game ($platform):"
        local i=1
        for game in "${games_list[@]}"; do
            echo "$i) $game"
            ((i++))
        done
        echo "0) Back to main menu"
        echo
        read -rp "Enter number: " game_choice

        if [[ "$game_choice" == "0" ]]; then
            return
        fi
        if ! [[ "$game_choice" =~ ^[0-9]+$ ]] || (( game_choice < 1 || game_choice > ${#games_list[@]} )); then
            echo -e "${RED}Invalid choice.${RESET}"
            sleep 1
            continue
        fi

        local selected_game="${games_list[$((game_choice-1))]}"
        select_country "$platform" "$selected_game" "$dns_map"
    done
}

select_country() {
    local platform="$1"
    local game="$2"
    local dns_map="$3"

    while true; do
        header
        echo "Selected game: $game"
        echo "Select a country:"
        local i=1
        for country in "${countries[@]}"; do
            echo "$i) $country"
            ((i++))
        done
        echo "0) Back to previous menu"
        echo
        read -rp "Enter number: " country_choice

        if [[ "$country_choice" == "0" ]]; then
            return
        fi
        if ! [[ "$country_choice" =~ ^[0-9]+$ ]] || (( country_choice < 1 || country_choice > ${#countries[@]} )); then
            echo -e "${RED}Invalid choice.${RESET}"
            sleep 1
            continue
        fi

        local selected_country="${countries[$((country_choice-1))]}"
        display_dns "$platform" "$game" "$selected_country" "$dns_map"
    done
}

display_dns() {
    local platform="$1"
    local game="$2"
    local country="$3"
    local dns_map="$4"

    header
    echo "Game: $game"
    echo "Country: $country"
    local key="${game}-${country}"
    local dns_entry="${!dns_map}[$key]"

    # Try to get DNS and ping, fallback if not found
    eval "local dns_value=\${$dns_map[\"\$key\"]}"

    if [[ -z "$dns_value" ]]; then
        echo -e "${YELLOW}No DNS found for $game in $country.${RESET}"
        pause_return
        return
    fi

    IFS='|' read -r primary_dns secondary_dns ping_ms <<< "$dns_value"

    echo -e "${GREEN}Primary DNS: $primary_dns${RESET}"
    echo -e "${GREEN}Secondary DNS: $secondary_dns${RESET}"
    echo -e "${CYAN}Ping: ${ping_ms} ms (use ping command to measure)${RESET}"

    pause_return
}

download_dns() {
    header
    echo "Download DNS for VPN/Proxy"
    echo "This section can be expanded with actual download links or scripts."
    pause_return
}

while true; do
    header
    echo "Select an option:"
    echo "1) Mobile Games DNS"
    echo "2) PC Games DNS"
    echo "3) Console Games DNS"
    echo "4) Download DNS (VPN/Proxy)"
    echo "5) Generate Saudi Arabia DNS"
    echo "6) Generate Turkey DNS"
    echo "7) Generate UAE DNS"
    echo "0) Exit"
    echo
    read -rp "Enter number: " choice
    case $choice in
        1) select_game "mobile" ;;
        2) select_game "pc" ;;
        3) select_game "console" ;;
        4) download_dns ;;
        5) dns_generate "Saudi Arabia" ;;
        6) dns_generate "Turkey" ;;
        7) dns_generate "UAE" ;;
        0) echo "Bye!"; exit 0 ;;
        *) echo -e "${RED}Invalid choice.${RESET}" ;;
    esac
done
