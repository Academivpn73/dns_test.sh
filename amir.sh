#!/bin/bash

# Version 2.1 | Telegram: @Academi_vpn | Admin: @MahdiAGM0

# Colors
reset="\e[0m"
green="\e[1;32m"
blue="\e[1;34m"
cyan="\e[1;36m"
red="\e[1;31m"
orange="\e[38;5;208m"

# Typing animation from top to bottom line by line
print_animated_lines() {
  lines=("$@")
  for line in "${lines[@]}"; do
    for ((i=0; i<${#line}; i++)); do
      echo -ne "${line:$i:1}"
      sleep 0.002
    done
    echo
  done
}

# Title screen
show_title() {
  clear
  lines=(
    "${cyan}╔══════════════════════════════════════╗"
    "║         DNS MANAGEMENT TOOL         ║"
    "╠══════════════════════════════════════╣"
    "║  Version: 2.1                      ║"
    "║  Telegram: @Academi_vpn             ║"
    "║  Admin: @MahdiAGM0                  ║"
    "╚══════════════════════════════════════╝${reset}"
  )
  print_animated_lines "${lines[@]}"
}

# Countries
countries=("Iran" "Iraq" "UAE" "Turkey" "Qatar" "Saudi Arabia" "Jordan")

# PC Games (40)
pc_games=(
  "Valorant" "Fortnite" "CS:GO" "Dota 2" "League of Legends" "Overwatch 2" "Minecraft" "PUBG" "Warzone" "Apex Legends"
  "Rust" "Rocket League" "Paladins" "Genshin Impact" "Destiny 2" "Smite" "ARK" "Cyberpunk 2077" "Fall Guys" "Battlefield 2042"
  "Call of Duty MW3" "Rainbow Six Siege" "FIFA 24" "Elden Ring" "Starfield" "World of Warcraft" "Lost Ark" "Path of Exile" "Team Fortress 2" "Halo Infinite"
  "Escape from Tarkov" "Sea of Thieves" "Diablo IV" "Roblox" "Guild Wars 2" "New World" "Crossfire" "Hunt Showdown" "Final Fantasy XIV" "Valorant Test"
)

# Console Games (40)
console_games=(
  "Fortnite" "FIFA 24" "Call of Duty" "Apex Legends" "Warzone" "Minecraft" "Rocket League" "Roblox" "Battlefield V" "Overwatch 2"
  "Rainbow Six Siege" "Destiny 2" "Diablo IV" "PUBG" "Smite" "Fall Guys" "Halo Infinite" "Street Fighter 6" "Gran Turismo 7" "NBA 2K24"
  "MLB The Show 24" "Madden NFL 24" "Tekken 8" "GTA Online" "Cyberpunk 2077" "Elden Ring" "ARK" "ESO" "Sea of Thieves" "Paladins"
  "League of Legends" "Splatoon 3" "Monster Hunter" "Warframe" "Borderlands 3" "Naraka Bladepoint" "NFS Heat" "Dota 2" "Hunt Showdown" "Cyber Console Test"
)

# Mobile Games (40 + Arena Breakout)
mobile_games=(
  "PUBG Mobile" "Call of Duty Mobile" "Free Fire" "Arena of Valor" "Clash of Clans" "Clash Royale" "Brawl Stars" "Mobile Legends" "Asphalt 9" "Arena Breakout"
  "Wild Rift" "Standoff 2" "Diablo Immortal" "FIFA Mobile" "Genshin Impact" "8 Ball Pool" "Among Us" "Pokemon Unite" "Modern Combat 5" "World War Heroes"
  "Shadowgun Legends" "Dragon Raja" "Sky: Children of Light" "War Robots" "Real Racing 3" "Into the Dead 2" "Dead Trigger 2" "Sniper 3D" "Critical Ops" "Crossfire: Legends"
  "NOVA Legacy" "Pixel Gun 3D" "Modern Strike Online" "Bullet Force" "Zombie Frontier 4" "Zula Mobile" "Tacticool" "Infinity Ops" "Cyber Hunter" "Mobile Test"
)

# DNS Pools with 100+ entries (examples repeated for brevity, replace with real ones)
dns_pool_game=(
  "1.1.1.1 1.0.0.1" "8.8.8.8 8.8.4.4" "9.9.9.9 149.112.112.112" "94.140.14.14 94.140.15.15" "208.67.222.222 208.67.220.220"
  "64.6.64.6 64.6.65.6" "156.154.70.2 156.154.71.2" "159.250.35.250 159.250.35.251" "208.67.222.222 208.67.220.220" "1.1.1.1 1.0.0.1"
  # (repeat to reach 100+)
)
for i in {1..95}; do dns_pool_game+=("8.8.4.4 8.8.8.8"); done

dns_pool_console=(
  "10.202.10.10 10.202.10.11" "185.55.225.25 185.55.226.26" "78.157.42.101 78.157.42.100" "178.22.122.100 185.51.200.2" "109.169.6.2 109.169.6.3"
  # (repeat to reach 100+)
)
for i in {1..95}; do dns_pool_console+=("185.55.226.26 185.55.225.25"); done

dns_pool_mobile=(
  "1.1.1.1 1.0.0.1" "8.8.8.8 8.8.4.4" "9.9.9.9 149.112.112.112" "94.140.14.14 94.140.15.15" "208.67.222.222 208.67.220.220"
  # (repeat to reach 100+)
)
for i in {1..95}; do dns_pool_mobile+=("8.8.8.8 8.8.4.4"); done

dns_pool_download=(
  "185.51.200.2 178.22.122.100" "91.239.100.100 89.223.43.71" "208.67.222.222 208.67.220.220" "176.103.130.130 176.103.130.131"
  # (repeat to reach 100+)
)
for i in {1..95}; do dns_pool_download+=("91.239.100.100 89.223.43.71"); done

# Ping checker
check_ping() {
  ip="$1"
  result=$(ping -c 1 -W 1 "$ip" 2>/dev/null | grep 'time=' | awk -F'time=' '{print $2}' | cut -d' ' -f1)
  [[ -z "$result" ]] && echo "Timeout" || echo "$result ms"
}

# Format output
print_dns_format() {
  local game="$1"
  local country="$2"
  local dns1="$3"
  local dns2="$4"
  local ping1=$(check_ping $dns1)
  local ping2=$(check_ping $dns2)

  echo -e "\n${green}Game:${reset} $game"
  echo -e "${green}Country:${reset} $country"
  echo -e "\n${cyan}DNS Set 1:${reset}"
  echo -e "  Primary: $dns1"
  echo -e "  Secondary: $dns2"
  echo -e "${blue}Ping DNS:${reset}"
  echo -e "  Primary: $ping1"
  echo -e "  Secondary: $ping2"
}

# Selection menu for games, countries, and DNS
select_dns_for_type() {
  local type="$1"
  case $type in
    "pc") games=("${pc_games[@]}"); dns_pool=("${dns_pool_game[@]}");;
    "console") games=("${console_games[@]}"); dns_pool=("${dns_pool_console[@]}");;
    "mobile") games=("${mobile_games[@]}"); dns_pool=("${dns_pool_mobile[@]}");;
    *) return;;
  esac

  clear
  echo -e "${green}Select your game:${reset}"
  for i in "${!games[@]}"; do
    printf "${blue}[%2d]${reset} %s\n" $((i+1)) "${games[$i]}"
  done
  read -p $'\nChoose number: ' gopt
  while [[ ! "$gopt" =~ ^[0-9]+$ ]] || ((gopt < 1 || gopt > ${#games[@]})); do
    echo -e "${red}Invalid choice. Try again.${reset}"
    read -p "Choose number: " gopt
  done
  game="${games[$((gopt-1))]}"

  echo -e "\n${green}Select your country:${reset}"
  for i in "${!countries[@]}"; do
    printf "${blue}[%2d]${reset} %s\n" $((i+1)) "${countries[$i]}"
  done
  read -p $'\nChoose country: ' copt
  while [[ ! "$copt" =~ ^[0-9]+$ ]] || ((copt < 1 || copt > ${#countries[@]})); do
    echo -e "${red}Invalid choice. Try again.${reset}"
    read -p "Choose country: " copt
  done
  country="${countries[$((copt-1))]}"

  pick="${dns_pool[$RANDOM % ${#dns_pool[@]}]}"
  dns1=$(echo "$pick" | awk '{print $1}')
  dns2=$(echo "$pick" | awk '{print $2}')
  print_dns_format "$game" "$country" "$dns1" "$dns2"
  read -p $'\nPress Enter to return...'
}

main_menu() {
  while true; do
    show_title
    echo -e "${blue}[1]${reset} PC Games DNS 🎮"
    echo -e "${blue}[2]${reset} Console Games DNS 🕹️"
    echo -e "${blue}[3]${reset} Mobile Games DNS 📱"
    echo -e "${blue}[4]${reset} Download / Anti-Censorship DNS ⬇️"
    echo -e "${blue}[0]${reset} Exit ❌"
    echo -ne "\n${green}Choose an option: ${reset}"
    read opt
    case $opt in
      1) select_dns_for_type "pc";;
      2) select_dns_for_type "console";;
      3) select_dns_for_type "mobile";;
      4)
        clear
        echo -e "${green}Download / Anti-Censorship DNS List:${reset}"
        for i in "${!dns_pool_download[@]}"; do
          dns1=$(echo "${dns_pool_download[$i]}" | awk '{print $1}')
          dns2=$(echo "${dns_pool_download[$i]}" | awk '{print $2}')
          printf "${blue}[%2d]${reset}\n" $((i+1))
          print_dns_format "Downloader" "Iran" "$dns1" "$dns2"
          echo
        done
        read -p "Press Enter to return..."
        ;;
      0) echo -e "${green}Goodbye 🙏🏻${reset}"; exit ;;
      *) echo -e "${red}Invalid input!${reset}"; sleep 1 ;;
    esac
  done
}

main_menu
