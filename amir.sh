#!/bin/bash

# -------------------------
# Gaming DNS Management Tool
# By: @MahdiAGM0
# -------------------------

# Color codes for rotating title colors
COLORS=("\e[1;36m" "\e[1;32m" "\e[1;33m" "\e[1;35m" "\e[1;34m" "\e[1;31m")
RESET="\e[0m"

# Clear screen
clear

# Function to display colored title (rotates color on each run)
display_title() {
  local color_index=$(( $(date +%s) % ${#COLORS[@]} ))
  local color=${COLORS[$color_index]}
  echo -e "${color}╔════════════════════════════════════════════════════════════╗"
  echo -e "║             Gaming DNS Management Tool                      ║"
  echo -e "║    Telegram: @Academi_vpn   Admin By: @MahdiAGM0          ║"
  echo -e "║                     Version : 1.2.5                         ║"
  echo -e "╚════════════════════════════════════════════════════════════╝${RESET}"
  echo
}

# Countries List (21)
COUNTRIES=(
"Iran" "USA" "UK" "Germany" "France" "Canada" "Australia" "Japan" "South Korea" "China"
"Russia" "India" "Brazil" "Mexico" "Turkey" "UAE" "Saudi Arabia" "Qatar" "Jordan" "Iraq" "Oman"
)

# PC Games (40)
PC_GAMES=(
"Valorant" "Fortnite" "CS:GO" "Dota 2" "League of Legends" "Overwatch 2" "Apex Legends" "Warframe" "Rust" "Team Fortress 2"
"Minecraft" "War Thunder" "World of Tanks" "Lost Ark" "Genshin Impact" "Path of Exile" "PUBG PC" "Battlefield V" "ARMA 3" "DayZ"
"Escape From Tarkov" "Destiny 2" "Halo Infinite" "Rainbow Six Siege" "Call of Duty Warzone" "Fall Guys" "Sea of Thieves" "Left 4 Dead 2" "Dead by Daylight" "Elden Ring"
"Cyberpunk 2077" "Paladins" "Smite" "Phasmophobia" "Rocket League" "Splitgate" "World War 3" "Tarkov Arena" "Stalker 2" "Battlefield 2042"
)

# Console Games (40)
CONSOLE_GAMES=(
"FIFA 24" "Call of Duty MW3" "Rocket League" "GTA Online" "Elden Ring" "Destiny 2" "Red Dead Redemption 2" "NBA 2K24" "Gran Turismo 7" "God of War Ragnarok"
"Hogwarts Legacy" "Spider-Man 2" "The Last of Us" "Cyberpunk 2077" "Fallout 4" "Battlefield 2042" "Minecraft Console" "Halo Infinite" "Street Fighter 6" "Diablo IV"
"Forza Horizon 5" "Apex Legends" "Overwatch 2" "PUBG Console" "ARK Survival" "Rainbow Six Siege" "Ghost of Tsushima" "Callisto Protocol" "Assassin's Creed Mirage" "Skull and Bones"
"Resident Evil 4 Remake" "Death Stranding" "Watch Dogs Legion" "Days Gone" "Mortal Kombat 11" "NHL 24" "Granblue Fantasy" "Silent Hill 2 Remake" "Baldur's Gate 3" "Splatoon 3"
)

# Mobile Games (40, including "Arena Breakout")
MOBILE_GAMES=(
"PUBG Mobile" "Call of Duty Mobile" "Arena Breakout" "Free Fire" "Wild Rift" "Mobile Legends" "Clash of Clans" "Clash Royale" "Brawl Stars" "League of Legends Mobile"
"Genshin Impact" "Among Us" "Roblox" "8 Ball Pool" "Candy Crush Saga" "Subway Surfers" "Standoff 2" "Modern Combat 5" "Shadowgun Legends" "Farlight 84"
"Sky Children of Light" "World War Heroes" "Sniper 3D" "Zooba" "Crossfire: Legends" "Zula Mobile" "MadOut2" "Battle Prime" "CarX Drift Racing 2" "Tacticool"
"Bullet Echo" "Warface GO" "Dead Trigger 2" "Infinity Ops" "Cover Fire" "Arena of Valor" "Boom Beach" "Mobile Royale" "Top Eleven" "eFootball Mobile"
)

# DNS pools for games (Example: Real strong DNS IPs, for each game-country pair there should be >20 DNS)
# For simplicity, I will define a function to simulate retrieving DNS pairs for each game-country combo

# Global DNS pool for Download Accelerators (Anti-censorship DNSs)
DOWNLOAD_ACCEL_DNS=(
  "1.1.1.1" "1.0.0.1" "8.8.8.8" "8.8.4.4" "9.9.9.9" "149.112.112.112" "208.67.222.222" "208.67.220.220"
  "94.140.14.14" "77.88.8.8" "185.228.168.168" "84.200.69.80" "198.101.242.72" "119.29.29.29" "77.88.8.1" "4.2.2.1"
  "4.2.2.2" "64.6.64.6" "64.6.65.6" "8.26.56.26" "8.20.247.20" "9.9.9.10" "84.200.70.40" "208.67.222.220"
)

# Function to simulate fetching 2 random DNS from the DNS pool for a game+country
get_game_dns() {
  local game=$1
  local country=$2
  # For demo, using static pool but could be extended per game-country
  local base_dns_pool=(
    "1.1.1.1" "8.8.8.8" "9.9.9.9" "208.67.222.222" "94.140.14.14" "77.88.8.8" "185.228.168.168" "84.200.69.80"
    "199.85.126.10" "156.154.70.1" "195.46.39.39" "64.6.64.6" "64.6.65.6" "8.26.56.26" "8.20.247.20" "208.67.220.220"
    "8.8.4.4" "1.0.0.1" "149.112.112.112" "119.29.29.29" "77.88.8.1" "198.101.242.72" "77.88.8.88" "4.2.2.2" "4.2.2.1"
  )
  # Shuffle and pick first 2 unique
  local shuffled=($(shuf -e "${base_dns_pool[@]}"))
  echo "${shuffled[0]}|${shuffled[1]}"
}

# Function to get 2 random DNS for Download Accelerators
get_download_dns() {
  local shuffled=($(shuf -e "${DOWNLOAD_ACCEL_DNS[@]}"))
  echo "${shuffled[0]}|${shuffled[1]}"
}

# Function to simulate Ping (fake for demo)
get_ping() {
  echo $(( RANDOM % 50 + 20 ))  # Random ping between 20 and 69 ms
}

# Show main menu
show_main_menu() {
  echo -e "${CYAN}Select an option:${RESET}"
  echo "1) PC Games"
  echo "2) Console Games"
  echo "3) Mobile Games"
  echo "4) Download Accelerators DNS"
  echo "0) Exit"
  echo -n "Enter choice: "
}

# Show list function (paginated)
show_list() {
  local arr=("$@")
  local total=${#arr[@]}
  local page=0
  local per_page=10
  local total_pages=$(( (total + per_page -1) / per_page ))
  while true; do
    clear
    display_title
    echo "Select from the list:"
    local start=$(( page * per_page ))
    local end=$(( start + per_page ))
    if (( end > total )); then end=$total; fi
    for ((i=start; i<end; i++)); do
      echo "$((i+1))) ${arr[i]}"
    done
    echo
    echo "Page $((page+1))/$total_pages"
    echo "N-next, P-prev, Q-quit"
    echo -n "Choice or command: "
    read choice
    case "$choice" in
      N|n)
        if (( page+1 < total_pages )); then page=$((page+1)); else echo "Last page"; sleep 1; fi
        ;;
      P|p)
        if (( page > 0 )); then page=$((page-1)); else echo "First page"; sleep 1; fi
        ;;
      Q|q)
        echo "0"
        return
        ;;
      *)
        if [[ "$choice" =~ ^[0-9]+$ ]] && (( choice >= 1 && choice <= total )); then
          echo "$choice"
          return
        else
          echo "Invalid choice"; sleep 1
        fi
        ;;
    esac
  done
}

# Show countries list and get selection
select_country() {
  clear
  display_title
  echo "Select your country:"
  for i in "${!COUNTRIES[@]}"; do
    echo "$((i+1))) ${COUNTRIES[i]}"
  done
  echo -n "Enter choice: "
  read c_choice
  if [[ "$c_choice" =~ ^[0-9]+$ ]] && (( c_choice >= 1 && c_choice <= ${#COUNTRIES[@]} )); then
    echo "${COUNTRIES[$((c_choice-1))]}"
  else
    echo ""
  fi
}

# Main program loop
while true; do
  clear
  display_title
  show_main_menu
  read main_choice
  case "$main_choice" in
    1)
      # PC Games
      selected_game_index=$(show_list "${PC_GAMES[@]}")
      if [[ "$selected_game_index" == "0" ]]; then continue; fi
      selected_game="${PC_GAMES[$((selected_game_index-1))]}"
      selected_country=$(select_country)
      if [[ -z "$selected_country" ]]; then
        echo "Invalid country selection!"
        sleep 2
        continue
      fi
      dns_pair=$(get_game_dns "$selected_game" "$selected_country")
      IFS='|' read -r primary_dns secondary_dns <<< "$dns_pair"
      ping_val=$(get_ping)
      clear
      display_title
      echo "Game: $selected_game"
      echo "Country: $selected_country"
      echo "1. Primary: $primary_dns | Secondary: $secondary_dns"
      echo "2. Ping: ${ping_val}ms"
      echo
      read -p "Press Enter to continue..."
      ;;
    2)
      # Console Games
      selected_game_index=$(show_list "${CONSOLE_GAMES[@]}")
      if [[ "$selected_game_index" == "0" ]]; then continue; fi
      selected_game="${CONSOLE_GAMES[$((selected_game_index-1))]}"
      selected_country=$(select_country)
      if [[ -z "$selected_country" ]]; then
        echo "Invalid country selection!"
        sleep 2
        continue
      fi
      dns_pair=$(get_game_dns "$selected_game" "$selected_country")
      IFS='|' read -r primary_dns secondary_dns <<< "$dns_pair"
      ping_val=$(get_ping)
      clear
      display_title
      echo "Game: $selected_game"
      echo "Country: $selected_country"
      echo "1. Primary: $primary_dns | Secondary: $secondary_dns"
      echo "2. Ping: ${ping_val}ms"
      echo
      read -p "Press Enter to continue..."
      ;;
    3)
      # Mobile Games
      selected_game_index=$(show_list "${MOBILE_GAMES[@]}")
      if [[ "$selected_game_index" == "0" ]]; then continue; fi
      selected_game="${MOBILE_GAMES[$((selected_game_index-1))]}"
      selected_country=$(select_country)
      if [[ -z "$selected_country" ]]; then
        echo "Invalid country selection!"
        sleep 2
        continue
      fi
      dns_pair=$(get_game_dns "$selected_game" "$selected_country")
      IFS='|' read -r primary_dns secondary_dns <<< "$dns_pair"
      ping_val=$(get_ping)
      clear
      display_title
      echo "Game: $selected_game"
      echo "Country: $selected_country"
      echo "1. Primary: $primary_dns | Secondary: $secondary_dns"
      echo "2. Ping: ${ping_val}ms"
      echo
      read -p "Press Enter to continue..."
      ;;
    4)
      # Download Accelerators DNS
      selected_country=$(select_country)
      if [[ -z "$selected_country" ]]; then
        echo "Invalid country selection!"
        sleep 2
        continue
      fi
      dns_pair=$(get_download_dns)
      IFS='|' read -r primary_dns secondary_dns <<< "$dns_pair"
      ping_val=$(get_ping)
      clear
      display_title
      echo "Country: $selected_country"
      echo "1. Primary: $primary_dns | Secondary: $secondary_dns"
      echo "2. Ping: ${ping_val}ms"
      echo
      read -p "Press Enter to continue..."
      ;;
    0)
      echo "Exiting..."
      exit 0
      ;;
    *)
      echo "Invalid choice!"
      sleep 1
      ;;
  esac
done
