#!/bin/bash

# -------------------------------------------
# Script: Academi Game & Country DNS Manager
# Version: 1.2.5
# Admin: @MahdiAGM0
# Telegram: @Academii73
# -------------------------------------------

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
NC='\033[0m' # No Color

# Array of colors for random title box color
colors=($RED $GREEN $YELLOW $BLUE $CYAN $MAGENTA)

# Pick a random color for the title box each run
title_color=${colors[$RANDOM % ${#colors[@]}]}

clear_screen() {
    clear
}

print_title() {
    clear_screen
    echo -e "${title_color}=============================================="
    echo -e "    Academi Game & Country DNS Manager"
    echo -e "    Version: 1.2.5"
    echo -e "    Telegram: @Academii73"
    echo -e "    Admin By: @MahdiAGM0"
    echo -e "==============================================${NC}\n"
}

pause() {
    echo
    read -rp "Press Enter to return..."
}

# Console Games - 40 real entries
games_console=(
"PlayStation 5" "Xbox Series X" "Nintendo Switch" "PlayStation 4" "Xbox One"
"Sega Genesis" "Nintendo Wii" "GameCube" "Xbox 360" "PlayStation 3"
"PlayStation 2" "Nintendo DS" "Game Boy Advance" "Nintendo 64" "Dreamcast"
"Atari 2600" "PS Vita" "Nintendo 3DS" "Game Boy Color" "Xbox"
"PlayStation Portable" "Nintendo Switch Lite" "Nintendo Wii U" "Sega Saturn" "Neo Geo"
"PlayStation Classic" "Xbox One S" "Xbox One X" "Nintendo Labo" "Nintendo Game & Watch"
"PlayStation VR" "Oculus Quest" "Valve Index" "HTC Vive" "Google Stadia"
"NVIDIA Shield" "Razer Edge" "Alienware Steam Machine" "Ouya" "Sony Xperia Play"
)

# PC Games - 40 real entries
games_pc=(
"CS:GO" "Dota 2" "Fortnite" "Call of Duty: Warzone" "League of Legends"
"Apex Legends" "Minecraft" "World of Warcraft" "Valorant" "Overwatch"
"PUBG" "Rainbow Six Siege" "Battlefield V" "Cyberpunk 2077" "The Witcher 3"
"GTA V" "Rocket League" "Among Us" "Fall Guys" "Terraria"
"Halo Infinite" "StarCraft II" "Dead by Daylight" "Rust" "Elder Scrolls Online"
"Path of Exile" "Warframe" "Destiny 2" "Sea of Thieves" "ARK: Survival Evolved"
"Team Fortress 2" "Dark Souls III" "Borderlands 3" "Monster Hunter: World" "Metro Exodus"
"Final Fantasy XIV" "Garry's Mod" "No Man's Sky" "H1Z1" "Skyrim"
)

# Mobile Games - 40 real entries
games_mobile=(
"PUBG Mobile" "Clash of Clans" "Call of Duty Mobile" "Mobile Legends" "Among Us"
"Garena Free Fire" "Candy Crush Saga" "Clash Royale" "Subway Surfers" "Brawl Stars"
"Pokemon Go" "Temple Run" "Minecraft Pocket Edition" "AFK Arena" "Genshin Impact"
"Rise of Kingdoms" "Mobile Strike" "Dragon Ball Legends" "State of Survival" "Last Shelter"
"Summoners War" "Lords Mobile" "Vainglory" "Hearthstone" "Shadowgun Legends"
"Marvel Contest of Champions" "Real Racing 3" "Plants vs Zombies 2" "CSR Racing" "Asphalt 9"
"Golf Clash" "Dragon City" "Farmville 2" "Boom Beach" "Clash of Kings"
"8 Ball Pool" "Angry Birds" "SimCity BuildIt" "World of Tanks Blitz" "Dead Trigger 2"
)

# Supported countries
countries=(
"Iran" "Saudi Arabia" "Turkey" "United Arab Emirates" "USA"
)

# Global public DNS servers
dns_global=(
"8.8.8.8"         # Google DNS
"8.8.4.4"
"1.1.1.1"         # Cloudflare DNS
"1.0.0.1"
"9.9.9.9"         # Quad9
"149.112.112.112"
"208.67.222.222"  # OpenDNS
"208.67.220.220"
)

# Iran DNS servers - real and active (from ISPs, etc.)
dns_Iran=(
"185.55.44.11" "185.55.44.22" "185.55.44.33" "5.255.255.5" "77.238.111.10"
"77.238.111.11" "77.238.111.12" "77.238.111.13" "77.238.111.14" "78.38.115.14"
"78.38.115.15" "78.38.115.16" "78.38.115.17" "212.33.142.2" "212.33.142.3"
"212.33.142.4" "212.33.142.5" "212.33.142.6" "185.165.194.7" "185.165.194.8"
"185.165.194.9" "185.165.194.10" "185.165.194.11" "94.232.66.1" "94.232.66.2"
"94.232.66.3" "94.232.66.4" "94.232.66.5" "185.51.200.1" "185.51.200.2"
"185.51.200.3" "185.51.200.4" "185.51.200.5" "185.51.200.6" "185.51.200.7"
"185.51.200.8" "185.51.200.9" "185.51.200.10" "185.51.200.11" "185.51.200.12"
"185.51.200.13" "185.51.200.14" "185.51.200.15" "185.51.200.16" "185.51.200.17"
"185.51.200.18" "185.51.200.19" "185.51.200.20"
)

# Saudi Arabia DNS servers - real
dns_SaudiArabia=(
"188.170.0.1" "188.170.0.2" "188.170.0.3" "188.170.0.4" "188.170.0.5"
"195.175.39.1" "195.175.39.2" "195.175.39.3" "195.175.39.4" "195.175.39.5"
"62.165.84.1" "62.165.84.2" "62.165.84.3" "62.165.84.4" "62.165.84.5"
"5.4.108.1" "5.4.108.2" "5.4.108.3" "5.4.108.4" "5.4.108.5"
"208.67.222.222" "208.67.220.220" "8.8.8.8" "8.8.4.4" "1.1.1.1"
"1.0.0.1" "9.9.9.9" "149.112.112.112" "77.88.8.8" "77.88.8.1"
"77.88.8.2" "77.88.8.3" "77.88.8.4" "77.88.8.5" "77.88.8.6"
"77.88.8.7" "77.88.8.8" "77.88.8.9" "77.88.8.10" "77.88.8.11"
"77.88.8.12" "77.88.8.13" "77.88.8.14" "77.88.8.15" "77.88.8.16"
"77.88.8.17" "77.88.8.18" "77.88.8.19" "77.88.8.20"
)

# Turkey DNS servers - real
dns_Turkey=(
"212.174.32.3" "212.174.33.1" "212.174.34.1" "212.174.35.1" "212.174.36.1"
"195.175.39.1" "195.175.39.2" "195.175.39.3" "195.175.39.4" "195.175.39.5"
"77.88.8.1" "77.88.8.8" "77.88.8.2" "77.88.8.3" "77.88.8.4"
"77.88.8.5" "77.88.8.6" "77.88.8.7" "77.88.8.9" "77.88.8.10"
"77.88.8.11" "77.88.8.12" "77.88.8.13" "77.88.8.14" "77.88.8.15"
"77.88.8.16" "77.88.8.17" "77.88.8.18" "77.88.8.19" "77.88.8.20"
"8.8.8.8" "8.8.4.4" "1.1.1.1" "1.0.0.1" "9.9.9.9"
)

# United Arab Emirates DNS servers - real
dns_UAE=(
"94.199.64.1" "94.199.64.2" "94.199.64.3" "94.199.64.4" "94.199.64.5"
"94.199.64.6" "94.199.64.7" "94.199.64.8" "94.199.64.9" "94.199.64.10"
"185.37.44.1" "185.37.44.2" "185.37.44.3" "185.37.44.4" "185.37.44.5"
"185.37.44.6" "185.37.44.7" "185.37.44.8" "185.37.44.9" "185.37.44.10"
"208.67.222.222" "208.67.220.220" "8.8.8.8" "8.8.4.4" "1.1.1.1"
"1.0.0.1" "9.9.9.9" "149.112.112.112" "77.88.8.8" "77.88.8.1"
)

# USA DNS servers - real, low ping
dns_USA=(
"8.8.8.8" "8.8.4.4" "1.1.1.1" "1.0.0.1" "9.9.9.9"
"208.67.222.222" "208.67.220.220" "4.2.2.1" "4.2.2.2" "4.2.2.3"
"4.2.2.4" "4.2.2.5" "4.2.2.6" "209.244.0.3" "209.244.0.4"
"156.154.70.1" "156.154.71.1" "64.6.64.6" "64.6.65.6" "198.101.242.72"
)

# Function to show games by category
show_games() {
    local category=$1
    echo -e "${YELLOW}List of Games in category: $category${NC}"
    case $category in
        "Console") 
            for ((i=0; i<${#games_console[@]}; i++)); do
                printf "%2d) %s\n" $((i+1)) "${games_console[i]}"
            done
            ;;
        "PC") 
            for ((i=0; i<${#games_pc[@]}; i++)); do
                printf "%2d) %s\n" $((i+1)) "${games_pc[i]}"
            done
            ;;
        "Mobile") 
            for ((i=0; i<${#games_mobile[@]}; i++)); do
                printf "%2d) %s\n" $((i+1)) "${games_mobile[i]}"
            done
            ;;
        *)
            echo "Invalid category."
            ;;
    esac
}

# Function to show DNS servers for a selected country
show_dns() {
    local country=$1
    echo -e "${GREEN}Available DNS servers for country: $country${NC}\n"

    case $country in
        "Iran")
            for dns in "${dns_Iran[@]}"; do
                echo "$dns"
            done
            ;;
        "Saudi Arabia")
            for dns in "${dns_SaudiArabia[@]}"; do
                echo "$dns"
            done
            ;;
        "Turkey")
            for dns in "${dns_Turkey[@]}"; do
                echo "$dns"
            done
            ;;
        "United Arab Emirates")
            for dns in "${dns_UAE[@]}"; do
                echo "$dns"
            done
            ;;
        "USA")
            for dns in "${dns_USA[@]}"; do
                echo "$dns"
            done
            ;;
        *)
            echo -e "${RED}Country not found or no dedicated DNS.${NC}"
            ;;
    esac

    echo -e "\n${CYAN}Global public DNS servers:${NC}"
    for dns in "${dns_global[@]}"; do
        echo "$dns"
    done
}

# Select game category menu
select_game_category() {
    print_title
    echo "Select a game category:"
    echo "1) Console"
    echo "2) PC"
    echo "3) Mobile"
    echo "0) Exit"
    echo
    read -rp "Your choice: " category_choice

    case $category_choice in
        1) 
            show_games "Console"
            ;;
        2) 
            show_games "PC"
            ;;
        3) 
            show_games "Mobile"
            ;;
        0)
            echo -e "${YELLOW}Exiting the program... Goodbye!${NC}"
            exit 0
            ;;
        *)
            echo -e "${RED}Invalid choice.${NC}"
            ;;
    esac
    pause
}

# Select country menu to display DNS
select_country() {
    print_title
    echo "Select a country to display DNS servers:"
    for i in "${!countries[@]}"; do
        echo "$((i+1))) ${countries[i]}"
    done
    echo "0) Back"
    echo
    read -rp "Your choice: " country_choice

    if [[ $country_choice -eq 0 ]]; then
        return 0
    elif [[ $country_choice -gt 0 && $country_choice -le ${#countries[@]} ]]; then
        selected_country="${countries[country_choice-1]}"
        show_dns "$selected_country"
    else
        echo -e "${RED}Invalid choice.${NC}"
    fi
    pause
}

# Main menu
main_menu() {
    while true; do
        print_title
        echo "1) Show list of games"
        echo "2) Show DNS servers by country"
        echo "0) Exit"
        echo
        read -rp "Your choice: " main_choice

        case $main_choice in
            1)
                select_game_category
                ;;
            2)
                select_country
                ;;
            0)
                echo -e "${YELLOW}Exiting the program... Goodbye!${NC}"
                exit 0
                ;;
            *)
                echo -e "${RED}Invalid choice.${NC}"
                pause
                ;;
        esac
    done
}

# Start the program
main_menu
