#!/bin/bash

# Version 1.4.2 | Telegram: @Academi_vpn | Admin: @MahdiAGM0

# Colors
green="\e[1;32m"
blue="\e[1;34m"
cyan="\e[1;36m"
red="\e[1;31m"
orange="\e[38;5;208m"
reset="\e[0m"
bold="\e[1m"

# Typing animation
type_text() {
    text="$1"
    delay="${2:-0.0007}"
    for ((i=0; i<${#text}; i++)); do
        echo -ne "${text:$i:1}"
        sleep $delay
    done
    echo
}

# Title
show_title() {
    colors=("\e[1;31m" "\e[1;32m" "\e[1;34m" "\e[1;35m" "\e[1;36m")
    rand_color=${colors[$RANDOM % ${#colors[@]}]}
    clear
    echo -e "${rand_color}"
    type_text "╔══════════════════════════════════════╗" 0.0004
    type_text "║         DNS MANAGEMENT TOOL         ║" 0.0004
    type_text "╠══════════════════════════════════════╣" 0.0004
    type_text "║  Version: 1.4.2                      ║" 0.0004
    type_text "║  Telegram: @Academi_vpn             ║" 0.0004
    type_text "║  Admin: @MahdiAGM0                  ║" 0.0004
    type_text "╚══════════════════════════════════════╝" 0.0004
    echo -e "${reset}"
}

# Sample Lists (To Be Extended Further)
pc_games=("Fortnite" "Valorant" "League of Legends" "Dota 2" "CS:GO" "Overwatch" "Apex Legends" "PUBG" "Warzone" "Rust" "Battlefield 2042" "Minecraft" "Genshin Impact" "Destiny 2" "Smite" "Halo Infinite" "Fall Guys" "Paladins" "World of Warcraft" "Cyberpunk 2077" "ARK" "Sea of Thieves" "Diablo IV" "Escape from Tarkov" "FIFA 24" "Call of Duty MW3" "Roblox" "R6 Siege" "Elden Ring" "Starfield" "Lost Ark" "Path of Exile" "Hunt Showdown" "Team Fortress 2" "Final Fantasy XIV" "Guild Wars 2" "Rocket League" "New World" "Crossfire")

console_games=("Fortnite" "FIFA 24" "Call of Duty" "Apex Legends" "Warzone" "Valorant" "Minecraft" "Rocket League" "Roblox" "Battlefield V" "Overwatch 2" "R6 Siege" "Destiny 2" "Diablo IV" "PUBG" "Smite" "Fall Guys" "Halo Infinite" "Street Fighter 6" "Gran Turismo 7" "NBA 2K24" "MLB The Show 24" "Madden NFL 24" "Tekken 8" "GTA Online" "Cyberpunk 2077" "Elden Ring" "ARK" "ESO" "Sea of Thieves" "Paladins" "Dota 2" "League of Legends" "Splatoon 3" "Monster Hunter" "Warframe" "Borderlands 3" "Naraka Bladepoint" "NFS Heat")

countries=("Iran" "Iraq" "UAE" "Turkey" "Qatar" "Saudi Arabia" "Jordan")

# Sample DNS Pools (Use real-world pools as needed)
dns_pool_game=(
  "1.1.1.1 1.0.0.1" "8.8.8.8 8.8.4.4" "9.9.9.9 149.112.112.112"
)
dns_pool_download=(
  "208.67.222.222 208.67.220.220" "91.239.100.100 89.233.43.71" "185.51.200.2 178.22.122.100"
)
dns_pool_region_IR=(
  "10.202.10.10 10.202.10.11" "185.55.225.25 185.55.226.26" "78.157.42.101 78.157.42.100"
)

check_ping() {
  ip="$1"
  result=$(ping -c 1 -W 1 "$ip" 2>/dev/null | grep 'time=' | awk -F'time=' '{print $2}' | cut -d' ' -f1)
  [[ -z "$result" ]] && echo "Timeout" || echo "${result} ms"
}

print_dns_format() {
  game="$1"
  country="$2"
  dns1="$3"
  dns2="$4"
  ping1=$(check_ping $dns1)
  ping2=$(check_ping $dns2)

  echo -e "\n${green}Game:${reset} $game"
  echo -e "${green}Country:${reset} $country"
  echo -e "\n${cyan}DNS Set 1:${reset}"
  echo -e "  Primary: $dns1"
  echo -e "  Secondary: $dns2"
  echo -e "${blue}Ping DNS:${reset}"
  echo -e "  Primary: $ping1"
  echo -e "  Secondary: $ping2"
}

auto_mode_console() {
  clear
  echo -ne "${cyan}Enter your console and game (e.g., PS5 Fortnite): ${reset}"; read input
  best_dns=""
  best_ping=9999
  for dns_pair in "${dns_pool_region_IR[@]}"; do
    ip=$(echo $dns_pair | awk '{print $1}')
    ping_result=$(check_ping $ip | grep -o '[0-9.]*')
    [[ -z "$ping_result" ]] && continue
    if (( $(echo "$ping_result < $best_ping" | bc -l) )); then
      best_ping=$ping_result
      best_dns=$dns_pair
    fi
  done
  dns1=$(echo "$best_dns" | awk '{print $1}')
  dns2=$(echo "$best_dns" | awk '{print $2}')
  print_dns_format "$input" "Unknown" "$dns1" "$dns2"
  read -p "Press Enter to return..."
}

search_game_mobile() {
  clear
  echo -ne "${cyan}Enter mobile game name: ${reset}"; read gname
  [[ "$gname" == "" ]] && gname="Arena Breakout"
  echo -e "\n${green}Select your country:${reset}"
  for i in "${!countries[@]}"; do
    printf "${blue}[%2d]${reset} %s\n" $((i+1)) "${countries[$i]}"
  done
  echo -ne "\n${green}Choose country: ${reset}"; read copt
  [[ "$copt" == "0" ]] && return
  country="${countries[$((copt-1))]}"
  pick=${dns_pool_game[$RANDOM % ${#dns_pool_game[@]}]}
  dns1=$(echo "$pick" | awk '{print $1}')
  dns2=$(echo "$pick" | awk '{print $2}')
  print_dns_format "$gname" "$country" "$dns1" "$dns2"
  read -p "Press Enter to return..."
}

gaming_dns_menu() {
  clear
  echo -e "${green}Gaming DNS List:${reset}"
  for pair in "${dns_pool_game[@]}"; do
    dns1=$(echo $pair | awk '{print $1}')
    dns2=$(echo $pair | awk '{print $2}')
    print_dns_format "PC/Mobile Game" "Unknown" "$dns1" "$dns2"
    echo
  done
  read -p "Press Enter to return..."
}

console_dns_menu() {
  clear
  echo -e "${green}Console Game DNS:${reset}"
  for game in "${console_games[@]}"; do
    pick=${dns_pool_region_IR[$RANDOM % ${#dns_pool_region_IR[@]}]}
    dns1=$(echo "$pick" | awk '{print $1}')
    dns2=$(echo "$pick" | awk '{print $2}')
    print_dns_format "$game" "Unknown" "$dns1" "$dns2"
    echo
  done
  read -p "Press Enter to return..."
}

bypass_dns_menu() {
  clear
  echo -e "${green}Download / Anti-Censorship DNS:${reset}"
  for pair in "${dns_pool_download[@]}"; do
    dns1=$(echo $pair | awk '{print $1}')
    dns2=$(echo $pair | awk '{print $2}')
    print_dns_format "Downloader" "Iran" "$dns1" "$dns2"
    echo
  done
  read -p "Press Enter to return..."
}

benchmark_dns() {
  clear
  echo -e "${green}DNS Benchmarking:${reset}"
  for pair in "${dns_pool_game[@]}"; do
    dns1=$(echo $pair | awk '{print $1}')
    dns2=$(echo $pair | awk '{print $2}')
    print_dns_format "Benchmark" "Unknown" "$dns1" "$dns2"
    echo
  done
  read -p "Press Enter to return..."
}

main_menu() {
  while true; do
    show_title
    echo -e "${blue}[1]${reset} Gaming DNS (PC / Mobile) 🎮"
    echo -e "${blue}[2]${reset} Console DNS 🕹️"
    echo -e "${blue}[3]${reset} Download / Anti-Censorship DNS ⬇️"
    echo -e "${blue}[4]${reset} Auto Mode (Console) ⚡"
    echo -e "${blue}[5]${reset} Search Game (Mobile) 🔍"
    echo -e "${blue}[6]${reset} Auto DNS Benchmark 📊"
    echo -e "${blue}[7]${reset} Custom DNS Ping 📶"
    echo -e "${blue}[0]${reset} Exit ❌"
    echo -ne "\n${green}Choose an option: ${reset}"; read opt
    case $opt in
      1) gaming_dns_menu ;;
      2) console_dns_menu ;;
      3) bypass_dns_menu ;;
      4) auto_mode_console ;;
      5) search_game_mobile ;;
      6) benchmark_dns ;;
      7) echo -ne "${cyan}Enter DNS IP: ${reset}"; read ip; echo -e "Ping: $(check_ping $ip)"; read -p "Press Enter to return...";;
      0) echo -e "${green}Goodbye 🙏🏻${reset}"; exit ;;
      *) echo -e "${red}Invalid input!${reset}"; sleep 1 ;;
    esac
  done
}

main_menu
