#!/bin/bash

# Version 1.4.0 | Telegram: @Academi_vpn | Admin: @MahdiAGM0

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
    type_text "║  Version: 1.4.0                      ║" 0.0004
    type_text "║  Telegram: @Academi_vpn             ║" 0.0004
    type_text "║  Admin: @MahdiAGM0                  ║" 0.0004
    type_text "╚══════════════════════════════════════╝" 0.0004
    echo -e "${reset}"
}

# Games
pc_games=(
  "Call of Duty" "PUBG" "Fortnite" "Valorant" "League of Legends"
  "Dota 2" "CS:GO" "Overwatch" "Rainbow Six Siege" "Apex Legends"
  "Rocket League" "Minecraft" "Genshin Impact" "Battlefield V" "Roblox"
  "FIFA 24" "Warzone" "Escape from Tarkov" "War Thunder" "Destiny 2"
  "Smite" "Halo Infinite" "Fall Guys" "Paladins" "World of Warcraft"
  "Elden Ring" "Cyberpunk 2077" "ARK" "Sea of Thieves" "Diablo IV"
  "Arena Breakout"
)

console_games=(
  "Fortnite (Console)" "Warzone (Console)" "FIFA 24 (Console)" "Rocket League (Console)"
  "Call of Duty (Console)" "Overwatch (Console)" "Apex Legends (Console)" "PUBG (Console)"
  "Minecraft (Console)" "Fall Guys (Console)" "Genshin Impact (Console)" "Roblox (Console)"
  "Smite (Console)" "Destiny 2 (Console)" "Paladins (Console)" "Halo Infinite (Console)"
  "League of Legends (Console)" "Battlefield V (Console)" "Cyberpunk 2077 (Console)"
  "ARK (Console)" "Sea of Thieves (Console)" "War Thunder (Console)" "CS:GO (Console)"
  "Diablo IV (Console)" "Elden Ring (Console)" "Arena Breakout (Console)" "NBA 2K24 (Console)"
  "PES 2024 (Console)" "Rainbow Six Siege (Console)"
)

countries=("Iran" "Iraq" "UAE" "Turkey" "Qatar" "Saudi Arabia" "Jordan")

# DNS Pools (game, download, region-based)
dns_pool_game=(
  "10.202.10.10 10.202.10.11" "78.157.42.101 78.157.42.100" "185.51.200.2 178.22.122.100"
  "185.55.225.25 185.55.226.26" "9.9.9.9 149.112.112.112" "64.6.64.6 64.6.65.6"
  "156.154.70.2 156.154.71.2" "159.250.35.250 159.250.35.251" "208.67.222.222 208.67.220.220"
  "1.1.1.1 1.0.0.1" "8.8.8.8 8.8.4.4"
)

dns_pool_download=(
  "1.1.1.1 1.0.0.1" "8.8.8.8 8.8.4.4" "64.6.64.6 64.6.65.6" "156.154.70.2 156.154.71.2"
  "159.250.35.250 159.250.35.251" "208.67.222.222 208.67.220.220"
  "185.51.200.2 178.22.122.100" "9.9.9.9 149.112.112.112" "78.157.42.101 78.157.42.100"
  "185.55.225.25 185.55.226.26" "91.239.100.100 89.223.43.71" "185.228.168.9 185.228.169.9"
  "94.140.14.14 94.140.15.15"
)

dns_pool_region_IR=("185.51.200.2 178.22.122.100" "185.55.225.25 185.55.226.26" "78.157.42.101 78.157.42.100")

# Ping Test Function
check_ping() {
    ip="$1"
    result=$(ping -c 1 -W 1 "$ip" 2>/dev/null | grep 'time=' | awk -F'time=' '{print $2}' | cut -d' ' -f1)
    [[ -z "$result" ]] && echo "Timeout" || echo "${result} ms"
}

# Placeholder: new features to be inserted

# Main Menu
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
      4) echo "[TODO] Auto Mode (Console)"; sleep 2 ;;
      5) echo "[TODO] Search Game (Mobile)"; sleep 2 ;;
      6) echo "[TODO] Auto DNS Benchmark"; sleep 2 ;;
      7) echo -ne "${cyan}Enter DNS IP: ${reset}"; read ip; echo -e "Ping: $(check_ping $ip)"; read -p "Press Enter to return...";;
      0) echo -e "${green}Goodbye 🙏🏻${reset}"; exit ;;
      *) echo -e "${red}Invalid input!${reset}"; sleep 1 ;;
    esac
  done
}

main_menu
