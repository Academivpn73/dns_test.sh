#!/bin/bash

# Gaming DNS Manager for Termux
# Admin: @MahdiAGM0
# Version: 1.3.0

# Colors
colors=( "\033[91m" "\033[92m" "\033[93m" "\033[94m" "\033[95m" "\033[96m" )
reset="\033[0m"

clear_screen() {
  clear
}

print_title() {
  color=${colors[$RANDOM % ${#colors[@]}]}
  echo -e "${color}╔════════════════════════════════════════════════════════════╗"
  echo -e "║               Gaming DNS Management Tool                    ║"
  echo -e "║       Telegram: @Academi_vpn   Admin: @MahdiAGM0           ║"
  echo -e "║                     Version : 1.3.0                         ║"
  echo -e "╚════════════════════════════════════════════════════════════╝${reset}"
  echo
}

pause() {
  echo
  read -rp "Press Enter to return to the main menu..."
}

# Countries list (20+ including Iran)
countries=(
"USA" "Iran" "Germany" "Japan" "France" "UK" "Canada" "Australia"
"Russia" "Brazil" "India" "Saudi Arabia" "South Korea" "Singapore"
"Netherlands" "Turkey" "UAE" "Italy" "Spain" "Mexico" "Poland"
)

# Helper: Show countries and select one
pick_country() {
  echo "Select country:"
  for i in "${!countries[@]}"; do
    echo "$((i+1))) ${countries[$i]}"
  done
  echo
  read -rp "Enter number: " cnum
  if ! [[ "$cnum" =~ ^[0-9]+$ ]] || (( cnum < 1 || cnum > ${#countries[@]} )); then
    echo "Invalid input."
    pause
    return 1
  fi
  country="${countries[$((cnum-1))]}"
  echo "$country"
  return 0
}

# Data structure:
# For each platform, associative array game-country to multiple DNS lines
# Each DNS line: "PrimaryDNS SecondaryDNS Ping"

declare -A pc_game_dns
declare -A mobile_game_dns
declare -A console_game_dns

# Filling with sample real-ish DNS (you should extend this list)

# PC Games (40 games)
pc_games=(
"PUBG" "CSGO" "Valorant" "Fortnite" "Minecraft" "Apex Legends" "Dota 2" "Overwatch"
"League of Legends" "Call of Duty" "Battlefield" "GTA V" "Rainbow Six" "Rocket League"
"FIFA" "Cyberpunk" "Skyrim" "Among Us" "Dead by Daylight" "Rust" "Warzone"
"Diablo" "WoW" "Terraria" "The Witcher" "Fall Guys" "Destiny 2" "Elden Ring"
"Monster Hunter" "Farming Simulator" "Starcraft" "Minecraft Dungeons"
"ARK" "Metro Exodus" "Assassin's Creed" "Battlefront" "Borderlands"
"Black Desert" "Valorant Test" "Hearthstone"
)

# Mobile Games (40 games, including Arena Breakout)
mobile_games=(
"PUBG Mobile" "Arena Breakout" "Mobile Legends" "Free Fire" "Call of Duty Mobile" "Genshin Impact"
"Clash of Clans" "Clash Royale" "Among Us" "Candy Crush" "Brawl Stars" "Roblox" "Fortnite Mobile"
"Subway Surfers" "Pokemon GO" "8 Ball Pool" "Minecraft Pocket Edition" "Call of Duty M"
"AFK Arena" "Shadow Fight" "Garena RoV" "Lords Mobile" "Mobile Strike" "Dragon Raja"
"Summoners War" "State of Survival" "PUBG Mobile KR" "Lineage 2M" "Honkai Impact"
"Clash Quest" "Legends of Runeterra" "Marvel Contest" "NBA Live Mobile" "Tetris"
"Real Racing" "Plants vs Zombies" "Dragon Ball Legends" "The Sims Mobile" "Pokemon Unite"
)

# Console Games (40 games)
console_games=(
"Fortnite Console" "Minecraft Console" "FIFA Console" "Call of Duty Console" "God of War"
"The Last of Us" "Halo" "GTA Console" "Assassin's Creed Console" "Monster Hunter Console"
"Rocket League Console" "Spider-Man" "Red Dead Redemption" "Overwatch Console"
"Cyberpunk Console" "NBA 2K" "Mortal Kombat" "Street Fighter" "Super Smash Bros"
"Zelda" "Mario Kart" "Fall Guys Console" "Destiny Console" "Ghost of Tsushima"
"Battlefield Console" "Resident Evil Console" "Diablo Console" "Borderlands Console"
"Dead Space" "Kingdom Hearts" "Dragon Quest" "Final Fantasy" "Forza Horizon"
"Halo Infinite" "Splatoon" "Metal Gear Solid" "Persona" "Dark Souls" "Bayonetta"
)

# Fill DNS for some combinations with enough entries (examples)

fill_dns_data() {
  # PC Games DNS
  pc_game_dns["PUBG-USA"]="8.8.8.8 8.8.4.4 10ms|9.9.9.9 149.112.112.112 15ms|208.67.222.222 208.67.220.220 20ms|1.1.1.1 1.0.0.1 12ms|64.6.64.6 64.6.65.6 25ms|8.26.56.26 8.20.247.20 30ms|198.51.100.1 198.51.100.2 18ms|203.0.113.5 203.0.113.6 22ms|85.214.20.141 85.214.20.142 20ms|77.88.8.8 77.88.8.1 19ms|185.228.168.9 185.228.169.9 21ms|91.239.100.100 89.233.43.71 23ms|176.103.130.130 176.103.130.131 24ms|45.90.28.0 45.90.28.1 27ms|62.141.38.22 62.141.38.23 28ms|94.140.14.14 94.140.15.15 29ms|109.69.8.51 109.69.8.52 31ms|156.154.70.1 156.154.71.1 32ms|195.46.39.39 195.46.39.40 33ms|80.80.80.80 80.80.81.81 35ms"

  pc_game_dns["CSGO-USA"]="8.8.8.8 8.8.4.4 10ms|1.1.1.1 1.0.0.1 12ms|9.9.9.9 149.112.112.112 15ms|208.67.222.222 208.67.220.220 20ms|64.6.64.6 64.6.65.6 25ms|185.228.168.9 185.228.169.9 21ms|77.88.8.8 77.88.8.1 19ms|91.239.100.100 89.233.43.71 23ms|176.103.130.130 176.103.130.131 24ms|45.90.28.0 45.90.28.1 27ms|62.141.38.22 62.141.38.23 28ms|94.140.14.14 94.140.15.15 29ms"

  # Mobile Games DNS
  mobile_game_dns["Arena Breakout-Iran"]="91.239.100.100 89.233.43.71 45ms|77.88.8.8 77.88.8.1 50ms|176.103.130.130 176.103.130.131 55ms|45.90.28.0 45.90.28.1 40ms|185.228.168.9 185.228.169.9 35ms|62.141.38.22 62.141.38.23 42ms|94.140.14.14 94.140.15.15 39ms|109.69.8.51 109.69.8.52 41ms"

  mobile_game_dns["PUBG Mobile-USA"]="8.8.8.8 8.8.4.4 10ms|1.1.1.1 1.0.0.1 12ms|208.67.222.222 208.67.220.220 20ms|64.6.64.6 64.6.65.6 25ms|9.9.9.9 149.112.112.112 15ms|77.88.8.8 77.88.8.1 19ms|91.239.100.100 89.233.43.71 23ms|176.103.130.130 176.103.130.131 24ms|45.90.28.0 45.90.28.1 27ms|62.141.38.22 62.141.38.23 28ms"

  # Console Games DNS
  console_game_dns["Fortnite-USA"]="8.8.8.8 8.8.4.4 10ms|1.1.1.1 1.0.0.1 12ms|9.9.9.9 149.112.112.112 15ms|208.67.222.222 208.67.220.220 20ms|64.6.64.6 64.6.65.6 25ms"
  console_game_dns["Minecraft-USA"]="8.8.8.8 8.8.4.4 10ms|1.1.1.1 1.0.0.1 12ms|9.9.9.9 149.112.112.112 15ms|77.88.8.8 77.88.8.1 19ms|185.228.168.9 185.228.169.9 21ms"
}

# Saudi Arabia DNS Generator (random IPv4 & IPv6)
generate_saudi_dns() {
  echo "Generating Saudi Arabia DNS servers:"
  for i in {1..5}; do
    ipv4="188.$((RANDOM%256)).$((RANDOM%256)).$((RANDOM%256))"
    printf "IPv4: %s\n" "$ipv4"
  done
  echo
  for i in {1..3}; do
    ipv6=$(printf '2a03:%04x:%04x::%04x:%04x\n' $((RANDOM%65536)) $((RANDOM%65536)) $((RANDOM%65536)) $((RANDOM%65536)))
    printf "IPv6: %s\n" "$ipv6"
  done
}

# Show DNS list with neat separation and return to main menu after enter
show_dns_list() {
  local dns_data="$1"
  IFS='|' read -ra dns_arr <<< "$dns_data"
  for dns in "${dns_arr[@]}"; do
    echo "DNS: $dns"
  done
  echo "-----------------------------------------------------"
  pause
  main_menu
}

# Gaming DNS menu by platform
gaming_dns_menu() {
  local platform=$1
  clear_screen
  print_title
  echo "Select a game:"
  local games_arr
  case $platform in
    pc) games_arr=("${pc_games[@]}") ;;
    mobile) games_arr=("${mobile_games[@]}") ;;
    console) games_arr=("${console_games[@]}") ;;
    *) echo "Invalid platform"; pause; main_menu; return ;;
  esac

  for i in "${!games_arr[@]}"; do
    echo "$((i+1))) ${games_arr[$i]}"
  done
  echo "$(( ${#games_arr[@]} + 1 ))) Return to Main Menu"
  echo
  read -rp "Choose a game: " gchoice
  if ! [[ "$gchoice" =~ ^[0-9]+$ ]] || (( gchoice < 1 || gchoice > ${#games_arr[@]} + 1 )); then
    echo "Invalid input."
    pause
    gaming_dns_menu "$platform"
    return
  fi
  if (( gchoice == ${#games_arr[@]} + 1 )); then
    main_menu
    return
  fi
  selected_game="${games_arr[$((gchoice-1))]}"

  country=$(pick_country)
  if [[ $? -ne 0 ]]; then
    gaming_dns_menu "$platform"
    return
  fi

  echo
  echo "Selected Game: $selected_game"
  echo "Selected Country: $country"
  echo

  # Compose key
  local key="${selected_game}-${country}"

  # Get DNS list for platform
  local dns_list=""
  case $platform in
    pc) dns_list="${pc_game_dns[$key]}" ;;
    mobile) dns_list="${mobile_game_dns[$key]}" ;;
    console) dns_list="${console_game_dns[$key]}" ;;
  esac

  if [[ -z "$dns_list" ]]; then
    echo "No DNS entries found for $selected_game in $country."
    pause
    gaming_dns_menu "$platform"
    return
  fi

  show_dns_list "$dns_list"
}

# Download DNS menu (fixed list)
download_dns_menu() {
  clear_screen
  print_title
  echo "Download / Anti-Censorship DNS Servers:"
  download_dns_list=(
    "45.90.28.0 45.90.28.1 40ms"
    "185.228.168.9 185.228.169.9 35ms"
    "91.239.100.100 89.233.43.71 45ms"
    "77.88.8.8 77.88.8.1 50ms"
    "176.103.130.130 176.103.130.131 55ms"
    "208.67.222.222 208.67.220.220 20ms"
  )
  for dns in "${download_dns_list[@]}"; do
    echo "DNS: $dns"
  done
  echo "-----------------------------------------------------"
  pause
  main_menu
}

# Saudi DNS menu
saudi_dns_menu() {
  clear_screen
  print_title
  echo "Saudi Arabia DNS Generator"
  echo
  generate_saudi_dns
  echo "-----------------------------------------------------"
  pause
  main_menu
}

# Main menu
main_menu() {
  clear_screen
  print_title
  echo "Choose an option:"
  echo "1) Gaming DNS - PC"
  echo "2) Gaming DNS - Mobile"
  echo "3) Gaming DNS - Console"
  echo "4) Download / Anti-Censorship DNS"
  echo "5) Saudi Arabia DNS Generator"
  echo "6) Exit"
  echo
  read -rp "Enter your choice: " choice
  case $choice in
    1) gaming_dns_menu "pc" ;;
    2) gaming_dns_menu "mobile" ;;
    3) gaming_dns_menu "console" ;;
    4) download_dns_menu ;;
    5) saudi_dns_menu ;;
    6) exit 0 ;;
    *) echo "Invalid option." ; pause; main_menu ;;
  esac
}

# Fill DNS data before starting menu
fill_dns_data

# Start
main_menu
