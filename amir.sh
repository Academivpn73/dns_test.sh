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

# Animated print from top to bottom (line by line)
animate_menu() {
  lines=("$@")
  clear
  for line in "${lines[@]}"; do
    echo -e "$line"
    sleep 0.1
  done
}

# Title Animation (top-down)
show_title() {
  clear
  lines=(
    "${bold}${blue}╔══════════════════════════════════════╗${reset}"
    "${bold}${blue}║         DNS MANAGEMENT TOOL         ║${reset}"
    "${bold}${blue}╠══════════════════════════════════════╣${reset}"
    "${bold}${blue}║  Version: 1.5.0                     ║${reset}"
    "${bold}${blue}║  Telegram: @Academi_vpn             ║${reset}"
    "${bold}${blue}║  Admin: @MahdiAGM0                  ║${reset}"
    "${bold}${blue}╚══════════════════════════════════════╝${reset}"
  )
  animate_menu "${lines[@]}"
}

# Check ping (ms)
check_ping() {
  ip="$1"
  result=$(ping -c 1 -W 1 "$ip" 2>/dev/null | grep 'time=' | awk -F'time=' '{print $2}' | cut -d' ' -f1)
  [[ -z "$result" ]] && echo "Timeout" || echo "${result} ms"
}

# Game lists
mobile_games=(
  "Arena Breakout (New)" "PUBG Mobile" "Call of Duty Mobile" "Free Fire" "Genshin Impact"
  "Clash of Clans" "Mobile Legends" "Among Us" "Pokemon Go" "Brawl Stars"
  "Subway Surfers" "Minecraft Pocket Edition" "Roblox Mobile" "Candy Crush Saga" "AFK Arena"
  "Garena Speed Drifters" "Lords Mobile" "Shadowgun Legends" "Asphalt 9" "Last Shelter: Survival"
  "State of Survival" "Raid: Shadow Legends" "Summoners War" "7 Days to Die" "Dragon Raja"
  "Dead by Daylight Mobile" "Call of Dragons" "Rise of Kingdoms" "World of Warcraft Mobile" "Marvel Future Revolution"
  "Diablo Immortal" "Clash Royale" "Legends of Runeterra" "Arena of Valor" "Harry Potter: Wizards Unite"
  "Fortnite Mobile" "Among Trees" "New State Mobile" "Pokemon Unite" "Vainglory"
)

console_games=(
  "Arena Breakout (New)" "Call of Duty" "Fortnite" "FIFA 24" "Apex Legends" "NBA 2K24"
  "Rocket League" "Madden NFL" "Gran Turismo 7" "Destiny 2" "GTA V"
  "Battlefield V" "Warzone" "Minecraft" "PUBG" "Overwatch"
  "Valorant" "Halo Infinite" "Cyberpunk 2077" "The Last of Us" "Spider-Man 2"
  "Hogwarts Legacy" "God of War Ragnarok" "Ghost of Tsushima" "Elden Ring" "Red Dead Redemption 2"
  "Street Fighter 6" "Palworld" "Diablo IV" "ARK" "Star Wars Jedi Survivor"
  "Final Fantasy XVI" "Assassin's Creed Mirage" "Godfall" "Deathloop" "Forza Horizon 5"
)

countries=(
  "Iran" "Iraq" "UAE" "Turkey" "Qatar" "Saudi Arabia" "Jordan" "Lebanon" "Oman" "Bahrain"
)

# DNS Pools (Example large sets, replace with real fast DNSs with ping<40ms ideally)
dns_pool_game=(
  "8.8.8.8 8.8.4.4"
  "1.1.1.1 1.0.0.1"
  "9.9.9.9 149.112.112.112"
  "208.67.222.222 208.67.220.220"
  "64.6.64.6 64.6.65.6"
  "84.200.69.80 84.200.70.40"
  "77.88.8.8 77.88.8.1"
  "114.114.114.114 114.114.115.115"
  "223.5.5.5 223.6.6.6"
  "119.29.29.29 182.254.116.116"
  "185.222.222.222 185.222.220.220"
  "45.90.28.0 45.90.30.0"
  "81.218.119.11 209.244.0.3"
  "199.85.126.10 199.85.127.10"
  "156.154.70.1 156.154.71.1"
  "89.233.43.71 89.104.194.142"
  "216.146.35.35 216.146.36.36"
  "8.26.56.26 8.20.247.20"
  "77.88.8.8 77.88.8.1"
  "185.51.200.2 185.51.200.3"
  "178.22.122.100 185.51.200.2"
  "10.202.10.10 10.202.10.202"
  "45.11.45.11 45.11.45.12"
  "123.123.123.123 124.124.124.124"
  "222.222.222.222 223.223.223.223"
  "100.100.100.100 101.101.101.101"
  "11.11.11.11 12.12.12.12"
  "13.13.13.13 14.14.14.14"
  "15.15.15.15 16.16.16.16"
  "17.17.17.17 18.18.18.18"
  "19.19.19.19 20.20.20.20"
  "21.21.21.21 22.22.22.22"
  "23.23.23.23 24.24.24.24"
  "25.25.25.25 26.26.26.26"
  "27.27.27.27 28.28.28.28"
  "29.29.29.29 30.30.30.30"
  "31.31.31.31 32.32.32.32"
  "33.33.33.33 34.34.34.34"
  "35.35.35.35 36.36.36.36"
)

dns_pool_download=(
  "178.22.122.100 185.51.200.2"
  "185.51.200.4 178.22.122.100"
  "8.8.8.8 8.8.4.4"
)

dns_pool_region_IR=(
  "185.51.200.2 185.51.200.3"
  "178.22.122.100 185.51.200.2"
  "10.202.10.10 10.202.10.202"
  "8.8.8.8 8.8.4.4"
  "1.1.1.1 1.0.0.1"
  "9.9.9.9 149.112.112.112"
)

# Auto Mode for Console
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
  if (( $(echo "$best_ping < 40" | bc -l) )); then
    echo -e "\n${green}Best DNS for \"$input\" (Ping under 40ms):${reset} $best_dns"
    echo -e "Ping: ${best_ping} ms"
  else
    echo -e "\n${red}No DNS with ping under 40ms found.${reset}"
    echo -e "${green}Best available DNS for \"$input\":${reset} $best_dns"
    echo -e "Ping: ${best_ping} ms"
  fi
  read -p "Press Enter to return..."
}

# Search Mobile Game DNS
search_game_mobile() {
  clear
  echo -e "${bold}${blue}Mobile Games List:${reset}"
  for i in "${!mobile_games[@]}"; do
    idx=$((i+1))
    if [[ "${mobile_games[$i]}" == *"(New)"* ]]; then
      echo -e "${orange}[$idx] ${mobile_games[$i]}${reset}"
    else
      echo -e "[$idx] ${mobile_games[$i]}"
    fi
  done
  echo -e "[0] Return to Main Menu"
  echo -ne "\n${cyan}Enter the number of your mobile game: ${reset}"; read game_choice
  if [[ "$game_choice" == "0" ]]; then
    return
  elif ((game_choice < 1 || game_choice > ${#mobile_games[@]})); then
    echo -e "${red}Invalid choice!${reset}"
    sleep 1
    return
  fi
  selected_game="${mobile_games[$((game_choice-1))]}"

  echo -e "\n${bold}${blue}Select Your Country:${reset}"
  for i in "${!countries[@]}"; do
    echo -e "[$((i+1))] ${countries[$i]}"
  done
  echo -e "[0] Return to Main Menu"
  echo -ne "\n${cyan}Enter country number: ${reset}"; read country_choice
  if [[ "$country_choice" == "0" ]]; then
    return
  elif ((country_choice < 1 || country_choice > ${#countries[@]})); then
    echo -e "${red}Invalid choice!${reset}"
    sleep 1
    return
  fi

  # Pick random DNS for demo - in real scenario, map game+country to DNS here
  dns_selected="${dns_pool_game[$RANDOM % ${#dns_pool_game[@]}]}"
  dns1=$(echo $dns_selected | awk '{print $1}')
  dns2=$(echo $dns_selected | awk '{print $2}')

  ping1=$(check_ping $dns1)
  ping2=$(check_ping $dns2)

  echo -e "\n${green}Game:${reset} $selected_game"
  echo -e "${green}Country:${reset} ${countries[$((country_choice-1))]}"
  echo -e "${cyan}Primary DNS:${reset} $dns1"
  echo -e "${cyan}Secondary DNS:${reset} $dns2"
  echo -e "${blue}Ping 1:${reset} $ping1"
  echo -e "${blue}Ping 2:${reset} $ping2"

  read -p "Press Enter to return..."
}

# Console Game DNS Menu
console_dns_menu() {
  clear
  echo -e "${bold}${blue}Console Games List:${reset}"
  for i in "${!console_games[@]}"; do
    idx=$((i+1))
    if [[ "${console_games[$i]}" == *"(New)"* ]]; then
      echo -e "${orange}[$idx] ${console_games[$i]}${reset}"
    else
      echo -e "[$idx] ${console_games[$i]}"
    fi
  done
  echo -e "[0] Return to Main Menu"
  echo -ne "\n${cyan}Select a console game by number to see DNS options: ${reset}"; read choice
  if [[ "$choice" == "0" ]]; then
    return
  elif ((choice < 1 || choice > ${#console_games[@]})); then
    echo -e "${red}Invalid choice!${reset}"
    sleep 1
    return
  fi

  echo -e "\n${bold}${blue}Select Your Country:${reset}"
  for i in "${!countries[@]}"; do
    echo -e "[$((i+1))] ${countries[$i]}"
  done
  echo -e "[0] Return to Main Menu"
  echo -ne "\n${cyan}Enter country number: ${reset}"; read country_choice
  if [[ "$country_choice" == "0" ]]; then
    return
  elif ((country_choice < 1 || country_choice > ${#countries[@]})); then
    echo -e "${red}Invalid choice!${reset}"
    sleep 1
    return
  fi

  dns_selected="${dns_pool_region_IR[$RANDOM % ${#dns_pool_region_IR[@]}]}"
  dns1=$(echo $dns_selected | awk '{print $1}')
  dns2=$(echo $dns_selected | awk '{print $2}')

  ping1=$(check_ping $dns1)
  ping2=$(check_ping $dns2)

  echo -e "\n${green}Game:${reset} ${console_games[$((choice-1))]}"
  echo -e "${green}Country:${reset} ${countries[$((country_choice-1))]}"
  echo -e "${cyan}Primary DNS:${reset} $dns1"
  echo -e "${cyan}Secondary DNS:${reset} $dns2"
  echo -e "${blue}Ping 1:${reset} $ping1"
  echo -e "${blue}Ping 2:${reset} $ping2"

  read -p "Press Enter to return..."
}

# Download / Anti-censorship DNS Menu
bypass_dns_menu() {
  clear
  echo -e "${bold}${blue}Download / Anti-Censorship DNS List:${reset}"
  for i in "${!dns_pool_download[@]}"; do
    idx=$((i+1))
    echo -e "[$idx] ${dns_pool_download[$i]}"
  done
  echo -e "[0] Return to Main Menu"
  read -p "Press Enter to return..."
}

# Auto DNS Benchmark
benchmark_dns() {
  clear
  echo -e "${bold}${blue}Auto DNS Benchmark (all DNS entries):${reset}"
  printf "%-25s %-10s\n" "DNS Address" "Ping"
  echo "-------------------------------------"
  for pair in "${dns_pool_game[@]}"; do
    ip=$(echo $pair | awk '{print $1}')
    ping_result=$(check_ping $ip)
    printf "%-25s %-10s\n" "$ip" "$ping_result"
  done
  read -p "\nPress Enter to return..."
}

# Custom DNS Ping
custom_dns_ping() {
  clear
  echo -ne "${cyan}Enter DNS IP to ping: ${reset}"; read ip
  ping_result=$(check_ping $ip)
  if [[ "$ping_result" == "Timeout" ]]; then
    echo -e "${red}No response from $ip.${reset}"
  else
    echo -e "${green}Ping result:${reset} $ping_result"
  fi
  read -p "Press Enter to return..."
}

# Main menu
main_menu() {
  show_title
  lines=(
    "[1] Mobile Games DNS"
    "[2] Console Games DNS"
    "[3] Auto Mode DNS"
    "[4] Download / Anti-censorship DNS"
    "[5] Benchmark DNS"
    "[6] Custom DNS Ping"
    "[0] Exit"
  )
  animate_menu "${lines[@]}"
  echo -ne "${cyan}Select an option: ${reset}"; read opt
  case $opt in
    1) search_game_mobile ;;
    2) console_dns_menu ;;
    3) auto_mode_console ;;
    4) bypass_dns_menu ;;
    5) benchmark_dns ;;
    6) custom_dns_ping ;;
    0) exit 0 ;;
    *) echo -e "${red}Invalid option!${reset}" ; sleep 1 ;;
  esac
}

# Run loop
while true; do
  main_menu
done
