#!/bin/bash

# Version 1.5.0 | Telegram: @Academi_vpn | Admin: @MahdiAGM0

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

# Random colored title
show_title() {
    colors=("\e[1;31m" "\e[1;32m" "\e[1;34m" "\e[1;35m" "\e[1;36m")
    rand_color=${colors[$RANDOM % ${#colors[@]}]}
    clear
    echo -e "${rand_color}"
    type_text "╔══════════════════════════════════════╗" 0.0004
    type_text "║         DNS MANAGEMENT TOOL         ║" 0.0004
    type_text "╠══════════════════════════════════════╣" 0.0004
    type_text "║  Version: 1.5.0                      ║" 0.0004
    type_text "║  Telegram: @Academi_vpn             ║" 0.0004
    type_text "║  Admin: @MahdiAGM0                  ║" 0.0004
    type_text "╚══════════════════════════════════════╝" 0.0004
    echo -e "${reset}"
}

# Game Lists
pc_games=("Call of Duty" "PUBG" "Fortnite" "Valorant" "League of Legends" "Dota 2" "CS:GO" "Overwatch" "Rainbow Six Siege" "Apex Legends" "Rocket League" "Minecraft" "Genshin Impact" "Battlefield V" "Roblox" "FIFA 24" "Warzone" "Escape from Tarkov" "War Thunder" "Destiny 2" "Smite" "Halo Infinite" "Fall Guys" "Paladins" "World of Warcraft" "Elden Ring" "Cyberpunk 2077" "ARK" "Sea of Thieves" "Diablo IV" "Arena Breakout (New)")

console_games=("Call of Duty" "Fortnite" "FIFA 24" "Apex Legends" "NBA 2K24" "Rocket League" "Madden NFL" "Gran Turismo 7" "Destiny 2" "GTA V" "Battlefield V" "Warzone" "Minecraft" "PUBG" "Overwatch" "Valorant" "Halo Infinite" "Cyberpunk 2077" "The Last of Us" "Spider-Man 2" "Hogwarts Legacy" "God of War Ragnarok" "Ghost of Tsushima" "Elden Ring" "Red Dead Redemption 2" "Street Fighter 6" "Palworld" "Diablo IV" "ARK" "Star Wars Jedi Survivor" "Final Fantasy XVI" "Assassin's Creed Mirage" "Arena Breakout (New)")

countries=("Iran" "Iraq" "UAE" "Turkey" "Qatar" "Saudi Arabia" "Jordan")

dns_pool_game=("8.8.8.8 8.8.4.4" "1.1.1.1 1.0.0.1" "9.9.9.9 149.112.112.112" "185.51.200.2 185.51.200.3" "10.202.10.10 10.202.10.202")
dns_pool_download=("178.22.122.100 185.51.200.2" "185.51.200.4 178.22.122.100")
dns_pool_region_IR=("185.51.200.2 185.51.200.3" "178.22.122.100 185.51.200.2" "10.202.10.10 10.202.10.202")

check_ping() {
  ip="$1"
  result=$(ping -c 1 -W 1 "$ip" 2>/dev/null | grep 'time=' | awk -F'time=' '{print $2}' | cut -d' ' -f1)
  [[ -z "$result" ]] && echo "Timeout" || echo "${result} ms"
}

auto_mode_console() {
  clear
  echo -ne "${cyan}Enter your console and game (e.g., PS4 Fortnite): ${reset}"; read input
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
  echo -e "\n${green}Best DNS for $input:${reset}"
  echo -e "Primary DNS: $dns1 (Ping: $(check_ping $dns1))"
  echo -e "Secondary DNS: $dns2 (Ping: $(check_ping $dns2))"
  read -p "Press Enter to return..."
}

search_game_mobile() {
  clear
  echo -ne "${cyan}Enter mobile game name: ${reset}"; read gname
  echo -e "\n${green}Select your country:${reset}"
  for i in "${!countries[@]}"; do
    printf "${blue}[%2d]${reset} %s\n" $((i+1)) "${countries[$i]}"
  done
  echo -ne "\n${green}Choose country: ${reset}"; read copt
  [[ "$copt" == "0" ]] && return
  pick=${dns_pool_game[$RANDOM % ${#dns_pool_game[@]}]}
  dns1=$(echo "$pick" | awk '{print $1}')
  dns2=$(echo "$pick" | awk '{print $2}')
  echo -e "\n${cyan}Primary DNS:${reset} $dns1 (Ping: $(check_ping $dns1))"
  echo -e "${cyan}Secondary DNS:${reset} $dns2 (Ping: $(check_ping $dns2))"
  read -p "Press Enter to return..."
}

benchmark_dns() {
  clear
  printf "${bold}%-25s %-10s\n${reset}" "DNS Address" "Ping"
  echo "----------------------------------------"
  for pair in "${dns_pool_game[@]}"; do
    ip1=$(echo $pair | awk '{print $1}')
    ping1=$(check_ping $ip1)
    printf "%-25s %-10s\n" "$ip1" "$ping1"
  done
  read -p "\nPress Enter to return..."
}

gaming_dns_menu() {
  clear
  echo -e "${green}Gaming DNS List with Ping:${reset}"
  for pair in "${dns_pool_game[@]}"; do
    dns1=$(echo "$pair" | awk '{print $1}')
    dns2=$(echo "$pair" | awk '{print $2}')
    echo -e "- Primary: $dns1 (Ping: $(check_ping $dns1))"
    echo -e "  Secondary: $dns2 (Ping: $(check_ping $dns2))"
  done
  read -p "\nPress Enter to return..."
}

console_dns_menu() {
  clear
  echo -e "${green}Console Game List:${reset}"
  for game in "${console_games[@]}"; do
    if [[ "$game" == *"(New)"* ]]; then
      echo -e "${orange}- $game${reset}"
    else
      echo "- $game"
    fi
  done
  read -p "\nPress Enter to return..."
}

bypass_dns_menu() {
  clear
  echo -e "${green}Download / Anti-Censorship DNS:${reset}"
  for pair in "${dns_pool_download[@]}"; do
    dns1=$(echo "$pair" | awk '{print $1}')
    dns2=$(echo "$pair" | awk '{print $2}')
    echo -e "- Primary: $dns1 (Ping: $(check_ping $dns1))"
    echo -e "  Secondary: $dns2 (Ping: $(check_ping $dns2))"
  done
  read -p "\nPress Enter to return..."
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
