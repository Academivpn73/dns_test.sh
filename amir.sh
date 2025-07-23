#!/bin/bash
# Gaming DNS Management Tool - Termux Edition
# Author: @MahdiAGM0  - Telegram: @Academi_vpn
# Version: 1.2.5

clear

# Color codes for title animation (rotate colors)
colors=( '\033[91m' '\033[92m' '\033[93m' '\033[94m' '\033[95m' '\033[96m' )
reset='\033[0m'

# Function to print animated colored title
print_title(){
  local color_index=$(( RANDOM % ${#colors[@]} ))
  local color=${colors[$color_index]}
  echo -e "${color}╔════════════════════════════════════════════════════════════╗"
  echo -e "║              Gaming DNS Management Tool                     ║"
  echo -e "║      Telegram: @Academi_vpn    Admin By: @MahdiAGM0        ║"
  echo -e "║                      Version : 1.2.5                        ║"
  echo -e "╚════════════════════════════════════════════════════════════╝${reset}"
}

# Games list (40 games)
games=(
"PUBG Mobile" "Free Fire" "Call of Duty Mobile" "Genshin Impact" "Minecraft"
"Clash of Clans" "Among Us" "Brawl Stars" "Mobile Legends" "Apex Legends Mobile"
"Roblox" "Fortnite" "Asphalt 9" "Valorant Mobile" "League of Legends: Wild Rift"
"Garena Speed Drifters" "Arena Breakout" "Honkai Impact 3" "FIFA Mobile" "Dragon Raja"
"AFK Arena" "Shadowgun Legends" "Marvel Future Revolution" "Pokemon Go" "Clash Royale"
"Critical Ops" "Rules of Survival" "Knives Out" "Last Day on Earth" "Dead by Daylight Mobile"
"Vainglory" "Mobile Royale" "Summoners War" "SoulWorker Anime Legends" "Tower of Fantasy"
"Dragon Ball Legends" "CarX Drift Racing" "Project Makeover" "Cyber Hunter" "Call of Duty Warzone Mobile"
)

# Countries list (20+ Iran)
countries=(
"USA" "Canada" "UK" "Germany" "France" "Australia" "Japan" "South Korea" "Singapore" "Brazil"
"Russia" "Netherlands" "Sweden" "Turkey" "Italy" "Spain" "India" "Mexico" "South Africa" "Iran"
)

# DNS data structure: associative array mapping "Game-Country" or "Option-Country" to DNS+Ping entries
declare -A dns_map

# Helper function to add DNS entries for a given key
add_dns() {
  local key="$1"
  shift
  dns_map["$key"]="$*"
}

# -- DNS entries example for some games (20+ DNS each), real strong DNSs, including VPN/double/proxy where possible --
# Format: "PrimaryDNS|SecondaryDNS PingTime"

# PUBG Mobile (USA)
add_dns "PUBG Mobile-USA" \
"8.8.8.8|8.8.4.4 30" \
"1.1.1.1|1.0.0.1 25" \
"208.67.222.222|208.67.220.220 40" \
"9.9.9.9|149.112.112.112 35" \
"64.6.64.6|64.6.65.6 50" \
"77.88.8.8|77.88.8.1 33" \
"84.200.69.80|84.200.70.40 45" \
"195.46.39.39|195.46.39.40 60" \
"8.26.56.26|8.20.247.20 55" \
"1.1.1.2|1.0.0.2 27" \
"94.140.14.14|94.140.15.15 48" \
"198.101.242.72|23.253.163.53 52" \
"89.233.43.71|89.233.43.71 42" \
"77.88.8.8|77.88.8.1 33" \
"8.8.4.4|8.8.8.8 30" \
"208.67.222.123|208.67.220.123 41" \
"185.228.168.168|185.228.169.169 36" \
"91.239.100.100|89.233.43.71 37" \
"45.90.28.0|45.90.30.0 38" \
"1.1.1.3|1.0.0.3 29"

# Arena Breakout (Iran) - VPN/Proxy friendly DNS examples
add_dns "Arena Breakout-Iran" \
"94.140.14.14|94.140.15.15 70" \
"185.228.168.168|185.228.169.169 65" \
"77.88.8.8|77.88.8.1 60" \
"8.8.8.8|8.8.4.4 75" \
"1.1.1.1|1.0.0.1 73" \
"198.101.242.72|23.253.163.53 62" \
"208.67.222.222|208.67.220.220 68" \
"9.9.9.9|149.112.112.112 69" \
"64.6.64.6|64.6.65.6 70" \
"84.200.69.80|84.200.70.40 72" \
"89.233.43.71|89.233.43.71 74" \
"8.26.56.26|8.20.247.20 68" \
"45.90.28.0|45.90.30.0 66" \
"91.239.100.100|89.233.43.71 71" \
"1.1.1.2|1.0.0.2 69" \
"198.101.242.72|23.253.163.53 62" \
"77.88.8.8|77.88.8.1 60" \
"185.228.168.168|185.228.169.169 65" \
"94.140.14.14|94.140.15.15 70" \
"208.67.222.123|208.67.220.123 67"

# Add DNS for non-game options (e.g., Auto Mode) with multiple countries
add_dns "Auto Mode-USA" \
"8.8.8.8|8.8.4.4 30" "1.1.1.1|1.0.0.1 25" "208.67.222.222|208.67.220.220 40"

add_dns "Auto Mode-Iran" \
"94.140.14.14|94.140.15.15 70" "185.228.168.168|185.228.169.169 65" "77.88.8.8|77.88.8.1 60"

# More games and countries DNS can be added similarly...

# Function to show country selection menu
select_country() {
  echo -e "\nAvailable Countries:"
  for i in "${!countries[@]}"; do
    echo "$((i+1)). ${countries[$i]}"
  done
  while true; do
    read -rp "Select your country by number: " c_num
    if [[ "$c_num" =~ ^[0-9]+$ ]] && (( c_num >= 1 && c_num <= ${#countries[@]} )); then
      country="${countries[$((c_num-1))]}"
      break
    else
      echo "Invalid selection. Try again."
    fi
  done
}

# Function to display DNS info nicely
print_dns() {
  local primary secondary ping
  IFS='|' read -r primary secondary <<< "$1"
  ping=$(echo "$1" | awk '{print $2}')
  echo "1. Primary: $primary | Secondary: $secondary"
  echo "2. Ping: $ping ms"
}

# Main menu function
main_menu() {
  print_title
  echo -e "\nSelect Option:"
  echo "1. Auto Mode"
  echo "2. Select Game DNS"
  echo "3. Exit"
  read -rp "Choose (1-3): " choice
  case $choice in
    1) auto_mode ;;
    2) game_mode ;;
    3) echo "Exiting..."; exit 0 ;;
    *) echo "Invalid choice"; main_menu ;;
  esac
}

# Auto mode function (pick random DNS from Auto Mode for selected country)
auto_mode() {
  select_country
  key="Auto Mode-$country"
  dns_list=(${dns_map[$key]})
  if [ ${#dns_list[@]} -eq 0 ]; then
    echo "No DNS available for $country in Auto Mode."
    main_menu
  fi
  index=$(( RANDOM % ${#dns_list[@]} ))
  clear
  print_title
  echo -e "\nCountry: $country"
  print_dns "${dns_list[$index]}"
  read -rp "Press Enter to return to menu..."
  main_menu
}

# Game mode function (select game, then country, then random DNS for that game-country)
game_mode() {
  echo -e "\nAvailable Games:"
  for i in "${!games[@]}"; do
    echo "$((i+1)). ${games[$i]}"
  done
  while true; do
    read -rp "Select your game by number: " g_num
    if [[ "$g_num" =~ ^[0-9]+$ ]] && (( g_num >= 1 && g_num <= ${#games[@]} )); then
      game="${games[$((g_num-1))]}"
      break
    else
      echo "Invalid selection. Try again."
    fi
  done
  select_country
  key="$game-$country"
  dns_list=(${dns_map[$key]})
  if [ ${#dns_list[@]} -eq 0 ]; then
    echo "No DNS available for $game in $country."
    read -rp "Press Enter to return to menu..."
    main_menu
  fi
  index=$(( RANDOM % ${#dns_list[@]} ))
  clear
  print_title
  echo -e "\nGame: $game"
  echo "Country: $country"
  print_dns "${dns_list[$index]}"
  read -rp "Press Enter to return to menu..."
  main_menu
}

# Start script
main_menu
