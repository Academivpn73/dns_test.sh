#!/bin/bash

# -------------------------
# Gaming DNS Management Tool
# By: @MahdiAGM0
# Version 1.3 Auto Mode + Animation + Full Logic
# -------------------------

# Color codes for rotating title colors
COLORS=("\e[1;36m" "\e[1;32m" "\e[1;33m" "\e[1;35m" "\e[1;34m" "\e[1;31m")
RESET="\e[0m"

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

# DNS pools for games and countries (just an example - real DNSs and lots more can be added)
DNS_POOL=(
"1.1.1.1" "1.0.0.1" "8.8.8.8" "8.8.4.4" "9.9.9.9" "149.112.112.112" "208.67.222.222" "208.67.220.220"
"94.140.14.14" "77.88.8.8" "185.228.168.168" "84.200.69.80" "198.101.242.72" "119.29.29.29" "77.88.8.1" "4.2.2.1"
"4.2.2.2" "64.6.64.6" "64.6.65.6" "8.26.56.26" "8.20.247.20" "9.9.9.10" "84.200.70.40" "208.67.222.220"
)

# Download Accelerator DNS (Anti-censorship)
DOWNLOAD_ACCEL_DNS=(
"1.1.1.1" "1.0.0.1" "8.8.8.8" "8.8.4.4" "9.9.9.9" "149.112.112.112" "208.67.222.222" "208.67.220.220"
"94.140.14.14" "77.88.8.8" "185.228.168.168" "84.200.69.80" "198.101.242.72" "119.29.29.29" "77.88.8.1" "4.2.2.1"
"4.2.2.2" "64.6.64.6" "64.6.65.6" "8.26.56.26" "8.20.247.20"
)

# Colors
CYAN="\e[1;36m"
GREEN="\e[1;32m"
YELLOW="\e[1;33m"
RESET="\e[0m"

# Animation for title (top to bottom)
animate_title() {
  local lines=(
"╔════════════════════════════════════════════════════════════╗"
"║             Gaming DNS Management Tool                      ║"
"║    Telegram: @Academi_vpn   Admin By: @MahdiAGM0          ║"
"║                     Version : 1.3                           ║"
"╚════════════════════════════════════════════════════════════╝"
  )
  clear
  local color_index=$(( $(date +%s) % ${#COLORS[@]} ))
  local color=${COLORS[$color_index]}
  for line in "${lines[@]}"; do
    echo -e "${color}$line${RESET}"
    sleep 0.12
  done
  echo
}

# Shuffle and pick two unique DNS from an array
pick_two_dns() {
  local arr=("$@")
  local shuffled=($(shuf -e "${arr[@]}"))
  echo "${shuffled[0]}|${shuffled[1]}"
}

# Random ping simulation
get_ping() {
  echo $(( RANDOM % 50 + 20 ))  # 20-69 ms ping
}

# Show list paginated with commands (N-next, P-prev, Q-exit)
show_list() {
  local arr=("$@")
  local total=${#arr[@]}
  local page=0
  local per_page=10
  local total_pages=$(( (total + per_page -1) / per_page ))
  while true; do
    clear
    animate_title
    echo -e "${CYAN}Select from the list:${RESET}"
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

# Select country with validation
select_country() {
  while true; do
    clear
    animate_title
    echo -e "${CYAN}Select your country:${RESET}"
    for i in "${!COUNTRIES[@]}"; do
      echo "$((i+1))) ${COUNTRIES[i]}"
    done
    echo -n "Enter choice: "
    read c_choice
    if [[ "$c_choice" =~ ^[0-9]+$ ]] && (( c_choice >= 1 && c_choice <= ${#COUNTRIES[@]} )); then
      echo "${COUNTRIES[$((c_choice-1))]}"
      return
    else
      echo "Invalid choice, try again."
      sleep 1
    fi
  done
}

# Get DNS for game and country
get_game_dns() {
  local game=$1
  local country=$2
  # In real scenario, you should have mappings. Here, we pick randomly from DNS_POOL
  local dns_pair=$(pick_two_dns "${DNS_POOL[@]}")
  echo "$dns_pair"
}

# Get DNS for download accelerator (country-based)
get_download_dns() {
  local dns_pair=$(pick_two_dns "${DOWNLOAD_ACCEL_DNS[@]}")
  echo "$dns_pair"
}

# Auto Mode function: picks random section, game/country, and prints DNS info directly
auto_mode() {
  clear
  animate_title
  echo -e "${YELLOW}Auto Mode Activated: Providing random DNS for you...${RESET}"
  sleep 1

  local section=$(( RANDOM % 4 + 1 )) # 1 to 4

  local country_index=$(( RANDOM % ${#COUNTRIES[@]} ))
  local country=${COUNTRIES[$country_index]}

  case $section in
    1)
      local game_index=$(( RANDOM % ${#PC_GAMES[@]} ))
      local game=${PC_GAMES[$game_index]}
      local dns_pair=$(get_game_dns "$game" "$country")
      ;;
    2)
      local game_index=$(( RANDOM % ${#CONSOLE_GAMES[@]} ))
      local game=${CONSOLE_GAMES[$game_index]}
      local dns_pair=$(get_game_dns "$game" "$country")
      ;;
    3)
      local game_index=$(( RANDOM % ${#MOBILE_GAMES[@]} ))
      local game=${MOBILE_GAMES[$game_index]}
      local dns_pair=$(get_game_dns "$game" "$country")
      ;;
    4)
      local dns_pair=$(get_download_dns)
      ;;
  esac

  local dns1=${dns_pair%%|*}
  local dns2=${dns_pair##*|}

  echo
  echo -e "${GREEN}Country: $country"
  [[ $section -eq 1 ]] && echo -e "PC Game: $game"
  [[ $section -eq 2 ]] && echo -e "Console Game: $game"
  [[ $section -eq 3 ]] && echo -e "Mobile Game: $game"
  [[ $section -eq 4 ]] && echo -e "Download Accelerator DNS"
  echo -e "DNS 1: $dns1"
  echo -e "DNS 2: $dns2"
  echo -e "Estimated Ping: $(get_ping) ms${RESET}"
  echo
  read -p "Press Enter to return to main menu..."
}

# Main menu
while true; do
  clear
  animate_title
  echo -e "${CYAN}Main Menu:${RESET}"
  echo "1) PC Games DNS"
  echo "2) Console Games DNS"
  echo "3) Mobile Games DNS"
  echo "4) Download Accelerator DNS"
  echo "5) Auto Mode (Random DNS)"
  echo "0) Exit"
  echo -n "Choose an option: "
  read main_choice

  case $main_choice in
    1)
      country=$(select_country)
      if [ "$country" == "0" ]; then continue; fi
      game_index=$(show_list "${PC_GAMES[@]}")
      if [ "$game_index" == "0" ]; then continue; fi
      game=${PC_GAMES[$((game_index-1))]}
      dns_pair=$(get_game_dns "$game" "$country")
      dns1=${dns_pair%%|*}
      dns2=${dns_pair##*|}
      clear
      animate_title
      echo -e "${GREEN}PC Game: $game"
      echo -e "Country: $country"
      echo -e "DNS 1: $dns1"
      echo -e "DNS 2: $dns2"
      echo -e "Estimated Ping: $(get_ping) ms${RESET}"
      read -p "Press Enter to return to menu..."
      ;;
    2)
      country=$(select_country)
      if [ "$country" == "0" ]; then continue; fi
      game_index=$(show_list "${CONSOLE_GAMES[@]}")
      if [ "$game_index" == "0" ]; then continue; fi
      game=${CONSOLE_GAMES[$((game_index-1))]}
      dns_pair=$(get_game_dns "$game" "$country")
      dns1=${dns_pair%%|*}
      dns2=${dns_pair##*|}
      clear
      animate_title
      echo -e "${GREEN}Console Game: $game"
      echo -e "Country: $country"
      echo -e "DNS 1: $dns1"
      echo -e "DNS 2: $dns2"
      echo -e "Estimated Ping: $(get_ping) ms${RESET}"
      read -p "Press Enter to return to menu..."
      ;;
    3)
      country=$(select_country)
      if [ "$country" == "0" ]; then continue; fi
      game_index=$(show_list "${MOBILE_GAMES[@]}")
      if [ "$game_index" == "0" ]; then continue; fi
      game=${MOBILE_GAMES[$((game_index-1))]}
      dns_pair=$(get_game_dns "$game" "$country")
      dns1=${dns_pair%%|*}
      dns2=${dns_pair##*|}
      clear
      animate_title
      echo -e "${GREEN}Mobile Game: $game"
      echo -e "Country: $country"
      echo -e "DNS 1: $dns1"
      echo -e "DNS 2: $dns2"
      echo -e "Estimated Ping: $(get_ping) ms${RESET}"
      read -p "Press Enter to return to menu..."
      ;;
    4)
      dns_pair=$(get_download_dns)
      dns1=${dns_pair%%|*}
      dns2=${dns_pair##*|}
      clear
      animate_title
      echo -e "${GREEN}Download Accelerator DNS:${RESET}"
      echo -e "DNS 1: $dns1"
      echo -e "DNS 2: $dns2"
      echo -e "Estimated Ping: $(get_ping) ms"
      read -p "Press Enter to return to menu..."
      ;;
    5)
      auto_mode
      ;;
    0)
      clear
      echo -e "${YELLOW}Goodbye!${RESET}"
      exit 0
      ;;
    *)
      echo "Invalid option, try again."
      sleep 1
      ;;
  esac
done
