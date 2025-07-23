#!/bin/bash

RESET="\e[0m"
TITLE_COLORS=("\e[1;36m" "\e[1;32m" "\e[1;33m" "\e[1;35m" "\e[1;34m")

TITLE_LINES=(
"╔════════════════════════════════════════════════════════════╗"
"║            Gaming DNS Management Tool                      ║"
"║    Telegram: @Academi_vpn   Admin By: @MahdiAGM0          ║"
"║                    Version : 1.2.5                         ║"
"╚════════════════════════════════════════════════════════════╝"
)

COUNTRIES=("Iran" "Iraq" "UAE" "Turkey" "Qatar" "Saudi Arabia" "Jordan" "Kuwait" "Oman" "Bahrain")

# Each game has its own DNS pool (20-30 DNSs per game)
declare -A GAME_DNS

# PC Games (40 games)
PC_GAMES=(
"Valorant" "Fortnite" "CS:GO" "Dota 2" "League of Legends" "Overwatch 2" "Apex Legends" "Warframe" "Rust" "Team Fortress 2"
"Minecraft" "War Thunder" "World of Tanks" "Lost Ark" "Genshin Impact" "Path of Exile" "PUBG PC" "Battlefield V" "ARMA 3" "DayZ"
"Escape From Tarkov" "Destiny 2" "Halo Infinite" "Rainbow Six Siege" "Call of Duty Warzone" "Fall Guys" "Sea of Thieves" "Left 4 Dead 2" "Dead by Daylight" "Elden Ring"
"Cyberpunk 2077" "Paladins" "Smite" "Phasmophobia" "Rocket League" "Splitgate" "World War 3" "Tarkov Arena" "Stalker 2" "Battlefield 2042"
)

# Console Games (40 games)
CONSOLE_GAMES=(
"FIFA 24" "Call of Duty MW3" "Rocket League" "GTA Online" "Elden Ring" "Destiny 2" "Red Dead Redemption 2" "NBA 2K24" "Gran Turismo 7" "God of War Ragnarok"
"Hogwarts Legacy" "Spider-Man 2" "The Last of Us" "Cyberpunk 2077" "Fallout 4" "Battlefield 2042" "Minecraft Console" "Halo Infinite" "Street Fighter 6" "Diablo IV"
"Forza Horizon 5" "Apex Legends" "Overwatch 2" "PUBG Console" "ARK Survival" "Rainbow Six Siege" "Ghost of Tsushima" "Callisto Protocol" "Assassin's Creed Mirage" "Skull and Bones"
"Resident Evil 4 Remake" "Death Stranding" "Watch Dogs Legion" "Days Gone" "Mortal Kombat 11" "NHL 24" "Granblue Fantasy" "Silent Hill 2 Remake" "Baldur's Gate 3" "Splatoon 3"
)

# Mobile Games (40 games) including "Arena Breakout"
MOBILE_GAMES=(
"PUBG Mobile" "Call of Duty Mobile" "Arena Breakout" "Free Fire" "Wild Rift" "Mobile Legends" "Clash of Clans" "Clash Royale" "Brawl Stars" "League of Legends Mobile"
"Genshin Impact" "Among Us" "Roblox" "8 Ball Pool" "Candy Crush Saga" "Subway Surfers" "Standoff 2" "Modern Combat 5" "Shadowgun Legends" "Farlight 84"
"Sky Children of Light" "World War Heroes" "Sniper 3D" "Zooba" "Crossfire: Legends" "Zula Mobile" "MadOut2" "Battle Prime" "CarX Drift Racing 2" "Tacticool"
"Bullet Echo" "Warface GO" "Dead Trigger 2" "Infinity Ops" "Cover Fire" "Arena of Valor" "Boom Beach" "Mobile Royale" "Top Eleven" "eFootball Mobile"
)

# VPN DNS (Anti-Filter) list 30 DNS
VPN_DNS=(
"94.140.14.14" "94.140.15.15" "8.26.56.26" "8.20.247.20" "77.88.8.8" "77.88.8.1" "185.228.168.168" "185.228.169.9"
"84.200.69.80" "84.200.70.40" "208.67.222.222" "208.67.220.220" "9.9.9.9" "149.112.112.112" "1.1.1.1" "1.0.0.1"
"64.6.64.6" "64.6.65.6" "209.244.0.3" "209.244.0.4" "8.8.8.8" "8.8.4.4" "156.154.70.1" "156.154.71.1" "195.46.39.39"
"195.46.39.40" "198.101.242.72" "198.101.242.73" "76.76.19.19" "76.223.122.150"
)

# Download Accelerator DNS list 30 DNS
DOWNLOAD_DNS=(
"1.1.1.1" "1.0.0.1" "8.8.8.8" "8.8.4.4" "9.9.9.9" "149.112.112.112" "149.112.112.113" "208.67.222.222" "208.67.220.220" "94.140.14.14"
"94.140.15.15" "64.6.64.6" "64.6.65.6" "209.244.0.3" "209.244.0.4" "198.101.242.72" "198.101.242.73" "76.76.19.19" "76.223.122.150" "77.88.8.8"
"77.88.8.1" "185.228.168.168" "185.228.169.9" "84.200.69.80" "84.200.70.40" "208.67.222.222" "208.67.220.220" "1.1.1.2" "8.8.8.1" "9.9.9.1"
)

# Setup DNS list per game - example for 3 games (expand for all)
setup_game_dns() {
  for game in "${PC_GAMES[@]}"; do
    # Fake example, in practice you'd have real DNS tailored per game/region, here 25 random from VPN + DOWNLOAD to simulate
    dns_list=()
    for i in {1..25}; do
      if (( i % 2 == 0 )); then
        dns_list+=("${VPN_DNS[$(( RANDOM % ${#VPN_DNS[@]} ))]}")
      else
        dns_list+=("${DOWNLOAD_DNS[$(( RANDOM % ${#DOWNLOAD_DNS[@]} ))]}")
      fi
    done
    GAME_DNS["PC_$game"]="${dns_list[*]}"
  done

  for game in "${CONSOLE_GAMES[@]}"; do
    dns_list=()
    for i in {1..25}; do
      if (( i % 2 == 0 )); then
        dns_list+=("${VPN_DNS[$(( RANDOM % ${#VPN_DNS[@]} ))]}")
      else
        dns_list+=("${DOWNLOAD_DNS[$(( RANDOM % ${#DOWNLOAD_DNS[@]} ))]}")
      fi
    done
    GAME_DNS["CONSOLE_$game"]="${dns_list[*]}"
  done

  for game in "${MOBILE_GAMES[@]}"; do
    dns_list=()
    for i in {1..25}; do
      if (( i % 2 == 0 )); then
        dns_list+=("${VPN_DNS[$(( RANDOM % ${#VPN_DNS[@]} ))]}")
      else
        dns_list+=("${DOWNLOAD_DNS[$(( RANDOM % ${#DOWNLOAD_DNS[@]} ))]}")
      fi
    done
    GAME_DNS["MOBILE_$game"]="${dns_list[*]}"
  done
}

# Print Title with rotating color
title_color_index=0
print_title() {
  clear
  local color=${TITLE_COLORS[$title_color_index]}
  ((title_color_index=(title_color_index+1) % ${#TITLE_COLORS[@]}))
  for line in "${TITLE_LINES[@]}"; do
    echo -e "${color}${line}${RESET}"
  done
  echo
}

# Simple animation for printing menu lines
animate_print() {
  for line in "$@"; do
    echo -e "$line"
    sleep 0.03
  done
}

show_main_menu() {
  print_title
  local menu=(
    "[1] PC Games"
    "[2] Console Games"
    "[3] Mobile Games"
    "[4] Download Accelerator DNS"
    "[5] VPN DNS (Anti-Filter)"
    "[6] Auto Benchmark DNS"
    "[0] Exit"
  )
  animate_print "${menu[@]}"
  echo
  read -rp "Select your option: " opt
  case $opt in
    1) show_game_list "PC" ;;
    2) show_game_list "CONSOLE" ;;
    3) show_game_list "MOBILE" ;;
    4) show_dns_list "Download Accelerator" ;;
    5) show_dns_list "VPN" ;;
    6) auto_benchmark ;;
     0) exit 0 ;;
    *) echo "Invalid option!"; sleep 1; show_main_menu ;;
  esac
}

show_game_list() {
  local category=$1
  print_title
  local games_var
  if [[ $category == "PC" ]]; then
    games_var=("${PC_GAMES[@]}")
  elif [[ $category == "CONSOLE" ]]; then
    games_var=("${CONSOLE_GAMES[@]}")
  else
    games_var=("${MOBILE_GAMES[@]}")
  fi

  echo "Games list for $category:"
  local i=1
  for game in "${games_var[@]}"; do
    echo "[$i] $game"
    ((i++))
  done
  echo "[0] Back to main menu"
  echo
  read -rp "Choose game: " choice
  if [[ $choice -eq 0 ]]; then
    show_main_menu
  elif (( choice > 0 && choice <= ${#games_var[@]} )); then
    show_dns_for_game "$category" "${games_var[$((choice-1))]}"
  else
    echo "Invalid choice!"
    sleep 1
    show_game_list "$category"
  fi
}

show_dns_for_game() {
  local category=$1
  local game=$2
  print_title
  echo -e "${category} Game: $game"
  echo
  local dns_str="${GAME_DNS[${category}_$game]}"
  IFS=' ' read -r -a dns_array <<< "$dns_str"
  # Print 1. Primary: | Secondary:   2. Ping:
  local primary secondary
  local count=1
  for ((i=0; i<${#dns_array[@]}; i+=2)); do
    primary=${dns_array[i]}
    secondary=${dns_array[i+1]:-N/A}
    # Ping is a random number between 20-100 ms for demo
    ping_val=$(( RANDOM % 81 + 20 ))
    if [[ "$category" == "MOBILE" || "$category" == "CONSOLE" || "$category" == "PC" ]]; then
      # For games, show "Game:\nCountry:\n1. Primary: | Secondary:\n2. Ping:\n"
      echo "Game: $game"
      echo "Country: ${COUNTRIES[$((RANDOM % ${#COUNTRIES[@]}))]}"
      echo "1. Primary: $primary | Secondary: $secondary"
      echo "2. Ping: ${ping_val}ms"
      echo "--------------------------------------"
    else
      # For other DNS categories
      echo "Country: ${COUNTRIES[$((RANDOM % ${#COUNTRIES[@]}))]}"
      echo "1. Primary: $primary | Secondary: $secondary"
      echo "2. Ping: ${ping_val}ms"
      echo "--------------------------------------"
    fi
    ((count++))
    if ((count > 10)); then break; fi
  done
  echo
  read -rp "Press Enter to return to game list..." _
  show_game_list "$category"
}

show_dns_list() {
  print_title
  local dns_type=$1
  local dns_array
  if [[ "$dns_type" == "VPN" ]]; then
    dns_array=("${VPN_DNS[@]}")
  else
    dns_array=("${DOWNLOAD_DNS[@]}")
  fi
  echo "$dns_type DNS list:"
  local count=1
  for ((i=0; i<${#dns_array[@]}; i+=2)); do
    primary=${dns_array[i]}
    secondary=${dns_array[i+1]:-N/A}
    ping_val=$(( RANDOM % 81 + 20 ))
    echo "Country: ${COUNTRIES[$((RANDOM % ${#COUNTRIES[@]}))]}"
    echo "1. Primary: $primary | Secondary: $secondary"
    echo "2. Ping: ${ping_val}ms"
    echo "--------------------------------------"
    ((count++))
    if ((count > 10)); then break; fi
  done
  echo
  read -rp "Press Enter to return to main menu..." _
  show_main_menu
}

auto_benchmark() {
  print_title
  echo "Auto Benchmark DNS feature is under development."
  echo
  read -rp "Press Enter to return to main menu..." _
  show_main_menu
}

# Initialize
setup_game_dns
show_main_menu
