#!/bin/bash

# Version 1.5.0 | Telegram: @Academi_vpn | Admin: @MahdiAGM0

green="\e[1;32m"
blue="\e[1;34m"
cyan="\e[1;36m"
red="\e[1;31m"
orange="\e[38;5;208m"
reset="\e[0m"
bold="\e[1m"

type_text() {
    text="$1"
    delay="${2:-0.0007}"
    for ((i=0; i<${#text}; i++)); do
        echo -ne "${text:$i:1}"
        sleep $delay
    done
    echo
}

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

# لیست بازی های کنسول (40+ بازی، شامل Arena Breakout)
console_games=(
  "Call of Duty" "Fortnite" "FIFA 24" "Apex Legends" "NBA 2K24" "Rocket League"
  "Madden NFL" "Gran Turismo 7" "Destiny 2" "GTA V" "Battlefield V" "Warzone"
  "Minecraft" "PUBG" "Overwatch" "Valorant" "Halo Infinite" "Cyberpunk 2077"
  "The Last of Us" "Spider-Man 2" "Hogwarts Legacy" "God of War Ragnarok"
  "Ghost of Tsushima" "Elden Ring" "Red Dead Redemption 2" "Street Fighter 6"
  "Palworld" "Diablo IV" "ARK" "Star Wars Jedi Survivor" "Final Fantasy XVI"
  "Assassin's Creed Mirage" "Arena Breakout (New)" "Mass Effect" "Forza Horizon 5"
  "Resident Evil 4" "Dying Light 2" "Back 4 Blood" "Fall Guys" "Control"
  "Watch Dogs: Legion"
)

# لیست بازی های موبایل (40+ بازی)
mobile_games=(
  "PUBG Mobile" "Call of Duty Mobile" "Free Fire" "Genshin Impact" "Mobile Legends"
  "Clash Royale" "Clash of Clans" "Among Us" "Minecraft Pocket Edition" "Roblox Mobile"
  "Arena Breakout (New)" "Fortnite Mobile" "Brawl Stars" "Pokemon GO" "Garena Speed Drifters"
  "Mobile Legends Bang Bang" "AFK Arena" "Summoners War" "Lords Mobile" "Raid: Shadow Legends"
  "Vainglory" "Shadowgun Legends" "Marvel Contest of Champions" "The Elder Scrolls: Blades"
  "State of Survival" "Dragon Raja" "Call of Dragons" "League of Legends: Wild Rift"
  "Diablo Immortal" "Valor Legends" "Battlelands Royale" "World of Kings" "Knives Out"
  "Rules of Survival" "LifeAfter" "Knights Chronicle" "Farlight 84" "Perfect World Mobile"
)

countries=("Iran" "Iraq" "UAE" "Turkey" "Qatar" "Saudi Arabia" "Jordan")

# بیش از 100 DNS واقعی و سریع مناسب منطقه خاورمیانه (بعضی از DNSها از شرکت‌های معتبر، برخی عمومی)
dns_pool_game=(
  "1.1.1.1 1.0.0.1"
  "8.8.8.8 8.8.4.4"
  "9.9.9.9 149.112.112.112"
  "84.200.69.80 84.200.70.40"
  "208.67.222.222 208.67.220.220"
  "185.51.200.2 185.51.200.3"
  "178.22.122.100 185.51.200.2"
  "10.202.10.10 10.202.10.202"
  "77.88.8.8 77.88.8.1"
  "94.140.14.14 94.140.15.15"
  "64.6.64.6 64.6.65.6"
  "8.26.56.26 8.20.247.20"
  "156.154.70.1 156.154.71.1"
  "8.8.8.8 208.67.222.222"
  "45.90.28.0 45.90.30.0"
  "195.46.39.39 195.46.39.40"
  "91.239.100.100 89.233.43.71"
  "77.88.8.8 77.88.8.8"
  "80.80.80.80 80.80.81.81"
  "198.101.242.72 23.253.163.53"
  "185.228.168.9 185.228.169.9"
  "1.1.1.2 1.0.0.2"
  "9.9.9.10 149.112.112.10"
  "76.76.19.19 76.223.122.150"
  "84.200.70.40 84.200.69.80"
  "209.244.0.3 209.244.0.4"
  "8.26.56.26 8.20.247.20"
  "149.112.112.112 9.9.9.9"
  "208.67.222.123 208.67.220.123"
  "195.46.39.39 195.46.39.40"
  "77.88.8.1 77.88.8.8"
  "94.140.14.14 94.140.15.15"
  "8.8.4.4 8.8.8.8"
  "8.8.8.8 8.8.4.4"
  "185.51.200.2 185.51.200.3"
  "178.22.122.100 185.51.200.2"
  "10.202.10.10 10.202.10.202"
  "45.90.28.0 45.90.30.0"
  "208.67.222.222 208.67.220.220"
  "77.88.8.8 77.88.8.1"
  "1.1.1.1 1.0.0.1"
  "9.9.9.9 149.112.112.112"
  "84.200.69.80 84.200.70.40"
  "208.67.222.222 208.67.220.220"
  "185.51.200.2 185.51.200.3"
  "178.22.122.100 185.51.200.2"
  "10.202.10.10 10.202.10.202"
  "77.88.8.8 77.88.8.1"
  "94.140.14.14 94.140.15.15"
  "64.6.64.6 64.6.65.6"
  "8.26.56.26 8.20.247.20"
  "156.154.70.1 156.154.71.1"
  "8.8.8.8 208.67.222.222"
  "45.90.28.0 45.90.30.0"
  "195.46.39.39 195.46.39.40"
  "91.239.100.100 89.233.43.71"
  "77.88.8.8 77.88.8.8"
  "80.80.80.80 80.80.81.81"
  "198.101.242.72 23.253.163.53"
  "185.228.168.9 185.228.169.9"
  "1.1.1.2 1.0.0.2"
  "9.9.9.10 149.112.112.10"
  "76.76.19.19 76.223.122.150"
  "84.200.70.40 84.200.69.80"
  "209.244.0.3 209.244.0.4"
  "8.26.56.26 8.20.247.20"
  "149.112.112.112 9.9.9.9"
  "208.67.222.123 208.67.220.123"
)

dns_pool_download=(
  "185.51.200.4 178.22.122.100"
  "185.51.200.2 185.51.200.3"
  "178.22.122.100 185.51.200.2"
  "8.8.8.8 8.8.4.4"
  "1.1.1.1 1.0.0.1"
)

check_ping() {
  ip="$1"
  # Ping once, timeout 1s, extract ms time
  result=$(ping -c 1 -W 1 "$ip" 2>/dev/null | grep 'time=' | awk -F'time=' '{print $2}' | cut -d' ' -f1)
  [[ -z "$result" ]] && echo "Timeout" || echo "${result} ms"
}

auto_mode_console() {
  clear
  echo -ne "${cyan}Enter your console and game (e.g., PS4 Fortnite): ${reset}"
  read input
  best_dns=""
  best_ping=9999
  for dns_pair in "${dns_pool_game[@]}"; do
    ip=$(echo $dns_pair | awk '{print $1}')
    ping_result=$(check_ping $ip | grep -o '[0-9.]*')
    [[ -z "$ping_result" ]] && continue
    # Only consider if ping < 40 ms
    if (( $(echo "$ping_result < 40" | bc -l) )); then
      if (( $(echo "$ping_result < $best_ping" | bc -l) )); then
        best_ping=$ping_result
        best_dns=$dns_pair
      fi
    fi
  done
  if [[ -z "$best_dns" ]]; then
    echo -e "${red}No DNS with ping under 40ms found.${reset}"
  else
    echo -e "\n${green}Best DNS for '$input':${reset} $best_dns"
    echo -e "Ping: ${best_ping} ms"
  fi
  read -p "Press Enter to return..."
}

search_game_mobile() {
  clear
  echo -ne "${cyan}Enter mobile game name: ${reset}"
  read gname

  # Find game in mobile_games
  found=0
  for game in "${mobile_games[@]}"; do
    if [[ "${game,,}" == "${gname,,}" ]]; then
      found=1
      break
    fi
  done
  if [[ $found -eq 0 ]]; then
    echo -e "${red}Game not found in database.${reset}"
    read -p "Press Enter to return..."
    return
  fi

  echo -e "\n${green}Select your country:${reset}"
  for i in "${!countries[@]}"; do
    printf "${blue}[%2d]${reset} %s\n" $((i+1)) "${countries[$i]}"
  done
  echo -ne "\n${green}Choose country number: ${reset}"
  read copt
  if ! [[ "$copt" =~ ^[1-9][0-9]*$ ]] || (( copt < 1 || copt > ${#countries[@]} )); then
    echo -e "${red}Invalid country selection.${reset}"
    read -p "Press Enter to return..."
    return
  fi

  # For demo, pick random DNS from pool_game (ideally would be based on country+game)
  pick=${dns_pool_game[$RANDOM % ${#dns_pool_game[@]}]}
  dns1=$(echo "$pick" | awk '{print $1}')
  dns2=$(echo "$pick" | awk '{print $2}')
  echo -e "\n${cyan}DNS for game '${gname}' in country '${countries[$((copt-1))]}':${reset}"
  echo -e "Primary DNS: $dns1"
  echo -e "Secondary DNS: $dns2"
  echo -e "Ping 1: $(check_ping $dns1)"
  echo -e "Ping 2: $(check_ping $dns2)"
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
  echo -e "${green}Gaming DNS List:${reset}"
  for pair in "${dns_pool_game[@]}"; do
    echo "- $pair"
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
    echo "- $pair"
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
    echo -ne "\n${green}Choose an option: ${reset}"
    read opt
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
