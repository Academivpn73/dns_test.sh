#!/bin/bash

# Colors
RED='\033[31m'; GREEN='\033[32m'; YELLOW='\033[33m'; BLUE='\033[34m'; MAGENTA='\033[35m'; CYAN='\033[36m'; RESET='\033[0m'

COLORS=($RED $GREEN $YELLOW $BLUE $MAGENTA $CYAN)

# Animate Title (simple scrolling effect)
animate_title() {
  local title_lines=(
"╔════════════════════════════════════════════════════════════╗"
"║            Gaming DNS Management Tool                      ║"
"║    Telegram: @Academi_vpn   Admin By: @MahdiAGM0          ║"
"║                    Version : 1.2.5                         ║"
"╚════════════════════════════════════════════════════════════╝"
  )
  local color=${COLORS[$RANDOM % ${#COLORS[@]}]}
  clear
  for line in "${title_lines[@]}"; do
    echo -e "${color}${line}${RESET}"
    sleep 0.05
  done
  echo
}

# Countries list (21 countries + Iran)
COUNTRIES=(
"United States"
"Canada"
"United Kingdom"
"Germany"
"France"
"Japan"
"South Korea"
"Australia"
"Brazil"
"India"
"Russia"
"Netherlands"
"Sweden"
"Singapore"
"Turkey"
"United Arab Emirates"
"South Africa"
"Mexico"
"Poland"
"Italy"
"Iran"
)

# 40 games list (sample names, add more or change as needed)
GAMES=(
"Fortnite"
"Call of Duty"
"League of Legends"
"Apex Legends"
"Valorant"
"PUBG Mobile"
"Mobile Legends"
"Clash of Clans"
"Among Us"
"Roblox"
"Minecraft"
"Rainbow Six Siege"
"Overwatch"
"FIFA"
"Genshin Impact"
"World of Warcraft"
"Counter-Strike"
"Battlefield"
"Dota 2"
"Rocket League"
"Warframe"
"Terraria"
"Dead by Daylight"
"Sea of Thieves"
"ARK: Survival Evolved"
"Cyberpunk 2077"
"Fall Guys"
"Assassin's Creed"
"Final Fantasy XIV"
"Black Desert"
"Pokemon Go"
"Destiny 2"
"Skyrim"
"Dark Souls"
"Clash Royale"
"Call of Duty Mobile"
"Arena Breakout"   # Added to mobile games as per your note
"League of Legends: Wild Rift"
"Genshin Impact Mobile"
"Magic: The Gathering Arena"
"Minecraft Dungeons"
)

# DNS data structure (Associative arrays: DNS for each game & country)
# For simplicity, this is just a sample DNS pool per game-country
# Real DNS servers should be used here. For demo, using popular public DNS and VPN-friendly DNS

declare -A DNS_PRIMARY
declare -A DNS_SECONDARY
declare -A DNS_PING

# Sample function to fill DNS for a game-country combo (with 25 DNS entries per combo)
fill_dns_for_game_country() {
  local game="$1"
  local country="$2"
  local key="${game}_${country}"

  # Example: assign random DNS from a big global list (simulate real servers)
  local dns_pool=(
    "8.8.8.8" "8.8.4.4" "1.1.1.1" "1.0.0.1" "9.9.9.9" "149.112.112.112" "208.67.222.222" "208.67.220.220"
    "77.88.8.8" "77.88.8.1" "185.228.168.9" "185.228.169.9" "84.200.69.80" "84.200.70.40"
    "94.140.14.14" "94.140.15.15" "64.6.64.6" "64.6.65.6" "156.154.70.1" "156.154.71.1"
    "198.101.242.72" "23.253.163.53" "185.222.222.222" "185.222.220.220" "45.90.28.0" "45.90.30.0"
  )

  DNS_PRIMARY[$key]=""
  DNS_SECONDARY[$key]=""
  DNS_PING[$key]=""

  # Select random 25 pairs from dns_pool as primary|secondary with ping
  # For demo: just assign first 25 pairs (or less if dns_pool smaller)
  local count=0
  for ((i=0; i<${#dns_pool[@]}-1; i+=2)); do
    if (( count >= 25 )); then break; fi
    # For ping, fake random between 15-80ms
    local ping=$((RANDOM % 66 + 15))
    DNS_PRIMARY[$key]+="${dns_pool[i]}"
    DNS_SECONDARY[$key]+="${dns_pool[i+1]}"
    DNS_PING[$key]+="$ping"
    ((count++))
    if (( count < 25 )); then
      DNS_PRIMARY[$key]+="|"
      DNS_SECONDARY[$key]+="|"
      DNS_PING[$key]+="|"
    fi
  done
}

# Pre-fill all DNS combos (for demo fill for all game-country combos)
for game in "${GAMES[@]}"; do
  for country in "${COUNTRIES[@]}"; do
    fill_dns_for_game_country "$game" "$country"
  done
done

# Show paginated list and get user choice
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
    echo "N-next, P-prev, Q-exit"
    echo -n "Choice or command: "
    read -r choice
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

select_country() {
  while true; do
    clear
    animate_title
    echo -e "${CYAN}Select your country:${RESET}"
    for i in "${!COUNTRIES[@]}"; do
      echo "$((i+1))) ${COUNTRIES[i]}"
    done
    echo -n "Enter choice (number): "
    read -r c_choice
    if [[ "$c_choice" =~ ^[0-9]+$ ]] && (( c_choice >= 1 && c_choice <= ${#COUNTRIES[@]} )); then
      echo "${COUNTRIES[$((c_choice-1))]}"
      return
    else
      echo "Invalid choice, try again."
      sleep 1
    fi
  done
}

# Show DNS output format for games
show_dns_game() {
  local game="$1"
  local country="$2"
  local key="${game}_${country}"
  local IFS='|'
  read -r -a primaries <<< "${DNS_PRIMARY[$key]}"
  read -r -a secondaries <<< "${DNS_SECONDARY[$key]}"
  read -r -a pings <<< "${DNS_PING[$key]}"
  echo
  echo -e "${YELLOW}Game:${RESET} $game"
  echo -e "${YELLOW}Country:${RESET} $country"
  for i in "${!primaries[@]}"; do
    echo "$((i+1)). Primary: ${primaries[i]} | Secondary: ${secondaries[i]}"
    echo "   Ping: ${pings[i]} ms"
  done
  echo
  read -p "Press Enter to return to menu..."
}

# Show DNS output format for general (non-game) options
show_dns_general() {
  local country="$1"
  local key="general_${country}"
  local IFS='|'
  read -r -a primaries <<< "${DNS_PRIMARY[$key]}"
  read -r -a secondaries <<< "${DNS_SECONDARY[$key]}"
  read -r -a pings <<< "${DNS_PING[$key]}"
  echo
  echo -e "${YELLOW}Country:${RESET} $country"
  for i in "${!primaries[@]}"; do
    echo "$((i+1)). Primary: ${primaries[i]} | Secondary: ${secondaries[i]}"
    echo "   Ping: ${pings[i]} ms"
  done
  echo
  read -p "Press Enter to return to menu..."
}

# Pre-fill general DNS for each country
for country in "${COUNTRIES[@]}"; do
  fill_dns_for_game_country "general" "$country"
done

# Main menu loop
while true; do
  clear
  animate_title
  echo -e "${CYAN}Main Menu:${RESET}"
  echo "1) PC Games DNS"
  echo "2) Mobile Games DNS"
  echo "3) Console Games DNS"
  echo "4) Auto Mode (Random DNS selection)"
  echo "0) Exit"
  echo -n "Choose an option: "
  read -r main_choice

  case $main_choice in
    1) # PC Games
      country=$(select_country)
      if [ "$country" == "0" ]; then continue; fi
      game_index=$(show_list "${GAMES[@]}")
      if [ "$game_index" == "0" ]; then continue; fi
      game=${GAMES[$((game_index-1))]}
      show_dns_game "$game" "$country"
      ;;
    2) # Mobile Games (subset + Arena Breakout)
      country=$(select_country)
      if [ "$country" == "0" ]; then continue; fi
      # Mobile games subset (for demo take some from GAMES + Arena Breakout)
      MOBILE_GAMES=(
        "PUBG Mobile"
        "Mobile Legends"
        "Arena Breakout"
        "Genshin Impact Mobile"
        "League of Legends: Wild Rift"
        "Call of Duty Mobile"
        "Clash Royale"
        "Pokemon Go"
        "Minecraft Dungeons"
        "Magic: The Gathering Arena"
      )
      game_index=$(show_list "${MOBILE_GAMES[@]}")
      if [ "$game_index" == "0" ]; then continue; fi
      game=${MOBILE_GAMES[$((game_index-1))]}
      show_dns_game "$game" "$country"
      ;;
    3) # Console Games (subset for demo)
      country=$(select_country)
      if [ "$country" == "0" ]; then continue; fi
      CONSOLE_GAMES=(
        "Fortnite"
        "Call of Duty"
        "FIFA"
        "Overwatch"
        "Rainbow Six Siege"
        "Rocket League"
        "Battlefield"
        "Destiny 2"
        "Cyberpunk 2077"
        "Skyrim"
      )
      game_index=$(show_list "${CONSOLE_GAMES[@]}")
      if [ "$game_index" == "0" ]; then continue; fi
      game=${CONSOLE_GAMES[$((game_index-1))]}
      show_dns_game "$game" "$country"
      ;;
    4) # Auto Mode (Random DNS for random game & country)
      random_game=${GAMES[$RANDOM % ${#GAMES[@]}]}
      random_country=${COUNTRIES[$RANDOM % ${#COUNTRIES[@]}]}
      echo "Random selection:"
      echo "Game: $random_game"
      echo "Country: $random_country"
      show_dns_game "$random_game" "$random_country"
      ;;
    0)
      clear
      echo "Bye!"
      exit 0
      ;;
    *)
      echo "Invalid option"
      sleep 1
      ;;
  esac
done
