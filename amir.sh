#!/bin/bash

# ====================================
# Academi Game & Country DNS Manager
# Version: 1.2.5
# Telegram: @Academii73
# Admin By: @MahdiAGM0
# ====================================

# Terminal colors (rotate on each run)
colors=(31 32 33 34 35 36)
color=${colors[$RANDOM % ${#colors[@]}]}

function print_title() {
  clear
  echo -e "\e[1;${color}m"
  echo "╔══════════════════════════════════════════╗"
  echo "║          Academi Game & Country DNS      ║"
  echo "║                 Manager                  ║"
  echo "╠══════════════════════════════════════════╣"
  echo "║ Version: 1.2.5                           ║"
  echo "║ Telegram: @Academii73                    ║"
  echo "║ Admin By: @MahdiAGM0                     ║"
  echo "╚══════════════════════════════════════════╝"
  echo -e "\e[0m"
}

# --- Data Section ---

# --- Sample game lists for each category ---

console_games=(
  "Call of Duty"
  "FIFA 22"
  "Minecraft"
  "Assassin's Creed"
  "The Last of Us"
  "God of War"
  "Halo"
  "Spider-Man"
  "Gran Turismo"
  "Battlefield"
  "Red Dead Redemption"
  "Fortnite"
  "Cyberpunk 2077"
  "Elden Ring"
  "GTA V"
  "Forza Horizon"
  "Rocket League"
  "Mortal Kombat"
  "Street Fighter"
  "Overwatch"
  "Dark Souls"
  "Destiny 2"
  "Persona 5"
  "Doom Eternal"
  "Skyrim"
  "Monster Hunter"
  "Crash Bandicoot"
  "Ratchet & Clank"
  "Godzilla"
  "Watch Dogs"
  "Just Dance"
  "Mario Kart"
  "Zelda"
  "Pokemon"
  "Sonic"
  "Tomb Raider"
  "Resident Evil"
  "Call of Juarez"
  "Battletoads"
  "Dead Space"
)

pc_games=(
  "Counter-Strike"
  "League of Legends"
  "Valorant"
  "Minecraft"
  "World of Warcraft"
  "PUBG PC"
  "Fortnite"
  "Dota 2"
  "Apex Legends"
  "Overwatch"
  "Cyberpunk 2077"
  "Elden Ring"
  "Rainbow Six Siege"
  "GTA V"
  "Rust"
  "ARK: Survival Evolved"
  "Skyrim"
  "Call of Duty Warzone"
  "Fall Guys"
  "Team Fortress 2"
  "Dead by Daylight"
  "Path of Exile"
  "Terraria"
  "Rocket League"
  "The Witcher 3"
  "Battlefield V"
  "Among Us"
  "Hades"
  "Valorant"
  "Escape from Tarkov"
  "Minecraft Dungeons"
  "Destiny 2"
  "League of Legends: Wild Rift"
  "Starcraft II"
  "PUBG Mobile" # Added for PC for your special case (optional)
  "The Sims 4"
  "Garry's Mod"
  "Fallout 4"
  "Dark Souls III"
)

mobile_games=(
  "PUBG Mobile"
  "Call of Duty Mobile"
  "Garena Free Fire"
  "Clash of Clans"
  "Mobile Legends"
  "Among Us Mobile"
  "Genshin Impact Mobile"
  "Brawl Stars"
  "Candy Crush Saga"
  "Subway Surfers"
  "Clash Royale"
  "AFK Arena"
  "Call of Duty Mobile"
  "League of Legends: Wild Rift"
  "Roblox Mobile"
  "Pokemon Go"
  "Minecraft Pocket Edition"
  "Fortnite Mobile"
  "Arena Breakout"
  "Mobile PUBG Lite" # Your special game here
  "Lords Mobile"
  "Rules of Survival"
  "Critical Ops"
  "Honkai Impact 3rd"
  "Summoners War"
  "Dragon Ball Legends"
  "State of Survival"
  "Marvel Contest of Champions"
  "Vainglory"
  "Mobile Legends: Bang Bang"
  "Shadowgun Legends"
  "World of Tanks Blitz"
  "PUBG New State"
  "Gacha Life"
  "Idle Heroes"
  "AFK Arena"
  "FIFA Mobile"
  "Brawl Stars"
)

# --- Countries List ---

countries=(
  "USA"
  "Iran"
  "Turkey"
  "UAE"
  "Saudi Arabia"
  "Germany"
  "Japan"
  "South Korea"
  "France"
  "Russia"
  "Canada"
)

# --- DNS Lists per game and country ---
# For brevity, here are example DNS servers for PUBG Mobile - USA & Iran (add more yourself later)

declare -A game_country_dns

# PUBG Mobile USA DNS (50+ recommended, only 10 sample here)
game_country_dns["PUBG Mobile-USA"]="8.8.8.8 8.8.4.4 1.1.1.1 1.0.0.1 9.9.9.9 149.112.112.112 208.67.222.222 208.67.220.220 76.76.19.19 76.76.21.21"

# PUBG Mobile Iran DNS (example, some public DNS known in Iran region)
game_country_dns["PUBG Mobile-Iran"]="185.51.200.2 185.51.200.22 77.88.8.8 77.88.8.1 91.239.100.100 91.239.100.101 185.228.168.168 185.228.169.168 103.86.96.100 103.86.99.100"

# Example for Arena Breakout Iran
game_country_dns["Arena Breakout-Iran"]="8.8.8.8 8.8.4.4 1.1.1.1 1.0.0.1 149.112.112.112 149.112.112.113 9.9.9.9 9.9.9.10 76.76.19.19 76.76.21.21"

# For Console games (Call of Duty USA)
game_country_dns["Call of Duty-USA"]="8.8.8.8 8.8.4.4 208.67.222.222 208.67.220.220 9.9.9.9 149.112.112.112 1.1.1.1 1.0.0.1 64.6.64.6 64.6.65.6"

# Add more as needed following this structure:
# game_country_dns["<game>-<country>"]="DNS1 DNS2 DNS3 DNS4 DNS5 ..."

# --- DNS Download (Circumvention) DNS servers ---

download_dns=(
  "8.8.8.8"
  "8.8.4.4"
  "1.1.1.1"
  "1.0.0.1"
  "9.9.9.9"
  "149.112.112.112"
  "208.67.222.222"
  "208.67.220.220"
  "76.76.19.19"
  "76.76.21.21"
)

# --- DNS Generate country IP ranges ---
# For IPv4 ranges, IPv6 prefixes (example ranges)

declare -A ip_ranges_ipv4=(
  ["Saudi Arabia"]="188.0.0.0/8"
  ["Turkey"]="85.0.0.0/8"
  ["UAE"]="94.100.0.0/16"
  ["Iran"]="185.51.200.0/21"
)

declare -A ip_ranges_ipv6=(
  ["Saudi Arabia"]="2a03::/32"
  ["Turkey"]="2a02::/32"
  ["UAE"]="2a05::/32"
  ["Iran"]="2a01::/32"
)

# === Functions ===

function wait_for_enter() {
  echo
  read -rp "Press ENTER to return to main menu..."
}

function ping_dns() {
  local dns_ip=$1
  ping -c 2 -W 1 "$dns_ip" &> /dev/null
  if [ $? -eq 0 ]; then
    ping -c 2 -W 1 "$dns_ip" | tail -2 | head -1 | awk '{print $4}' | cut -d '/' -f 2
  else
    echo "Timeout"
  fi
}

function generate_ipv4() {
  local base_range=$1
  # Simple random IP in /8 or /16 (depending on your range)
  IFS='.' read -ra parts <<< "$base_range"
  echo "${parts[0]}.$((RANDOM % 256)).$((RANDOM % 256)).$((RANDOM % 256))"
}

function generate_ipv6() {
  local prefix=$1
  # Generate a random IPv6 inside prefix
  printf "%s:%x:%x::%x:%x\n" "$prefix" $((RANDOM % 65535)) $((RANDOM % 65535)) $((RANDOM % 65535)) $((RANDOM % 65535))
}

function generate_dns_for_country() {
  local country=$1
  local ip_version=$2
  local count=$3
  local dns_list=()
  local range
  if [[ "$ip_version" == "ipv4" ]]; then
    range=${ip_ranges_ipv4[$country]}
    for ((i=0; i<count; i++)); do
      dns_list+=("$(generate_ipv4 "$range")")
    done
  else
    range=${ip_ranges_ipv6[$country]}
    for ((i=0; i<count; i++)); do
      dns_list+=("$(generate_ipv6 "$range")")
    done
  fi
  echo "${dns_list[@]}"
}

function print_dns_list() {
  local dns_array=("$@")
  echo -e "\nGenerated DNS Servers:"
  for dns in "${dns_array[@]}"; do
    echo "  $dns"
  done
}

function select_country() {
  echo "Select Country:"
  select country in "${countries[@]}" "Back"; do
    if [[ "$country" == "Back" ]]; then
      return 1
    elif [[ " ${countries[*]} " == *" $country "* ]]; then
      echo "You selected: $country"
      echo "$country"
      return 0
    else
      echo "Invalid selection. Try again."
    fi
  done
}

function select_game() {
  local category_games=("$@")
  echo "Select Game:"
  select game in "${category_games[@]}" "Back"; do
    if [[ "$game" == "Back" ]]; then
      return 1
    elif [[ " ${category_games[*]} " == *" $game "* ]]; then
      echo "$game"
      return 0
    else
      echo "Invalid selection. Try again."
    fi
  done
}

function select_ip_version() {
  echo "Select IP version:"
  select ip_ver in "IPv4" "IPv6" "Back"; do
    case $ip_ver in
      IPv4|IPv6)
        echo "${ip_ver,,}" # lowercase
        return 0
        ;;
      Back)
        return 1
        ;;
      *)
        echo "Invalid selection."
        ;;
    esac
  done
}

function select_number_of_dns() {
  while true; do
    read -rp "How many DNS servers do you want to generate? (1-10): " num
    if [[ "$num" =~ ^[1-9]$|^10$ ]]; then
      echo "$num"
      return 0
    else
      echo "Invalid number. Enter 1 to 10."
    fi
  done
}

function get_dns_for_game_country() {
  local game=$1
  local country=$2
  local key="$game-$country"
  local dns_string=${game_country_dns[$key]}
  if [ -z "$dns_string" ]; then
    echo ""
  else
    echo "$dns_string"
  fi
}

function show_dns_for_game() {
  local game=$1
  local country=$2
  local dns_string
  dns_string=$(get_dns_for_game_country "$game" "$country")
  if [ -z "$dns_string" ]; then
    echo "No DNS data available for $game in $country."
  else
    # pick two random DNS servers from list
    IFS=' ' read -ra dns_arr <<< "$dns_string"
    local count=${#dns_arr[@]}
    if (( count < 2 )); then
      echo "DNS list too short for $game in $country."
      return
    fi
    # random pick 2 unique
    idx1=$((RANDOM % count))
    idx2=$idx1
    while [[ $idx2 -eq $idx1 ]]; do
      idx2=$((RANDOM % count))
    done
    echo -e "\nDNS servers for $game in $country:"
    echo "Primary DNS: ${dns_arr[$idx1]}"
    echo "Secondary DNS: ${dns_arr[$idx2]}"
    echo "Pings:"
    ping1=$(ping_dns "${dns_arr[$idx1]}")
    ping2=$(ping_dns "${dns_arr[$idx2]}")
    echo "  ${dns_arr[$idx1]} : $ping1 ms"
    echo "  ${dns_arr[$idx2]} : $ping2 ms"
  fi
  wait_for_enter
}

# --- Menus ---

function menu_generate_dns() {
  echo "=== DNS Generator ==="
  select_country
  if [ $? -ne 0 ]; then return; fi
  local country=$REPLY
  country=$(sed -n "${REPLY}p" <<< "${countries[@]//$'\n'/ }")
  country=$(printf "%s\n" "${countries[@]}" | sed -n "${REPLY}p")
  country=${country:-""}
  if [ -z "$country" ]; then
    echo "Invalid country selection."
    return
  fi

  select_ip_version
  if [ $? -ne 0 ]; then return; fi
  local ip_ver=$REPLY

  select_number_of_dns
  if [ $? -ne 0 ]; then return; fi
  local count=$REPLY

  dns_generated=$(generate_dns_for_country "$country" "$ip_ver" "$count")
  print_dns_list $dns_generated
  wait_for_enter
}

function menu_games() {
  echo "Select Game Category:"
  select cat in "Console" "PC" "Mobile" "Back"; do
    case $cat in
      Console)
        select_game "${console_games[@]}"
        if [ $? -eq 0 ]; then
          local game=$REPLY
          select_country
          if [ $? -eq 0 ]; then
            local country=$REPLY
            show_dns_for_game "$game" "$country"
          fi
        fi
        ;;
      PC)
        select_game "${pc_games[@]}"
        if [ $? -eq 0 ]; then
          local game=$REPLY
          select_country
          if [ $? -eq 0 ]; then
            local country=$REPLY
            show_dns_for_game "$game" "$country"
          fi
        fi
        ;;
      Mobile)
        select_game "${mobile_games[@]}"
        if [ $? -eq 0 ]; then
          local game=$REPLY
          select_country
          if [ $? -eq 0 ]; then
            local country=$REPLY
            show_dns_for_game "$game" "$country"
          fi
        fi
        ;;
      Back)
        return
        ;;
      *)
        echo "Invalid selection."
        ;;
    esac
  done
}

function menu_auto_mode() {
  echo "=== Auto Mode ==="
  echo "This feature is under development."
  wait_for_enter
}

function menu_auto_benchmark() {
  echo "=== Auto Benchmark (Ping all DNS) ==="
  echo "Pinging all DNS servers in dataset, please wait..."
  declare -A ping_results
  for key in "${!game_country_dns[@]}"; do
    dns_list=${game_country_dns[$key]}
    IFS=' ' read -ra dns_arr <<< "$dns_list"
    for dns_ip in "${dns_arr[@]}"; do
      ping_ms=$(ping_dns "$dns_ip")
      ping_results["$dns_ip"]=$ping_ms
    done
  done
  echo "DNS Ping Results:"
  printf "%-20s %-10s\n" "DNS IP" "Ping (ms)"
  echo "----------------------------------"
  for dns_ip in "${!ping_results[@]}"; do
    printf "%-20s %-10s\n" "$dns_ip" "${ping_results[$dns_ip]}"
  done
  wait_for_enter
}

function menu_download_dns() {
  echo "=== Download (Bypass) DNS ==="
  echo "Recommended DNS for bypassing geo blocks or censorship:"
  for dns in "${download_dns[@]}"; do
    ping_ms=$(ping_dns "$dns")
    echo "DNS: $dns - Ping: $ping_ms ms"
  done
  wait_for_enter
}

# --- Main menu loop ---

function main_menu() {
  while true; do
    print_title
    echo "Main Menu:"
    echo "1) Generate DNS by Country & IP version"
    echo "2) Game DNS List"
    echo "3) Download (Bypass) DNS"
    echo "4) Auto Mode"
    echo "5) Auto Benchmark"
    echo "6) Exit"
    read -rp "Select option: " opt
    case $opt in
      1) menu_generate_dns ;;
      2) menu_games ;;
      3) menu_download_dns ;;
      4) menu_auto_mode ;;
      5) menu_auto_benchmark ;;
      6) echo "Goodbye!"; exit 0 ;;
      *) echo "Invalid option." ;;
    esac
  done
}

# --- Run the script ---
main_menu
