#!/bin/bash

# ====== Colors ======
colors=("\e[91m" "\e[92m" "\e[93m" "\e[94m" "\e[95m" "\e[96m")
RESET="\e[0m"

clear

# ====== Random Color for Title ======
color=${colors[$RANDOM % ${#colors[@]}]}

# ====== Title ======
echo -e "${color}╔════════════════════════════════════════════════════════════╗"
echo -e "║            Gaming DNS Management Tool                      ║"
echo -e "║    Telegram: @Academi_vpn   Admin By: @MahdiAGM0          ║"
echo -e "║                    Version : 1.2.5                         ║"
echo -e "╚════════════════════════════════════════════════════════════╝${RESET}"
echo

# ====== Games List (40 games) ======
games=(
  "PUBG Mobile" "Call of Duty Mobile" "Arena Breakout" "Genshin Impact"
  "Free Fire" "Mobile Legends" "Clash of Clans" "Clash Royale"
  "Fortnite" "Minecraft" "Apex Legends Mobile" "Roblox"
  "Among Us" "Valorant Mobile" "League of Legends" "Dota 2"
  "FIFA Mobile" "Pokemon Go" "Brawl Stars" "Garena Speed Drifters"
  "Assassin's Creed Mobile" "Shadow Fight 3" "Candy Crush Saga" "Subway Surfers"
  "Call of Duty Warzone" "Diablo Immortal" "PUBG PC" "CS:GO"
  "Minecraft Dungeons" "Rocket League" "Hearthstone" "Clash of Kings"
  "Summoners War" "Raid: Shadow Legends" "Mobile PUBG Lite" "GTA V"
  "Roblox Studio" "Mobile Arena" "Perfect World Mobile" "League of Legends: Wild Rift"
)

# ====== Countries List (20 + Iran) ======
countries=(
  "USA" "Germany" "France" "Japan" "South Korea" "Canada" "Australia" "UK" "Russia" "Brazil"
  "Iran" "India" "Singapore" "Netherlands" "Sweden" "Norway" "Turkey" "Italy" "Spain" "Mexico"
)

# ====== DNS Data ======
# Format: dns_map["Game-Country"]=("primary|secondary|ping" ...)
declare -A dns_map

# ====== Sample DNS Entries (Google, Cloudflare, Quad9, AdGuard + Some VPN-friendly) ======

# PUBG Mobile - USA
dns_map["PUBG Mobile-USA"]=(
  "8.8.8.8|8.8.4.4|20"
  "1.1.1.1|1.0.0.1|18"
  "9.9.9.9|149.112.112.112|22"
  "94.140.14.14|94.140.15.15|24"
  "76.76.19.19|76.223.122.150|26"
  "185.228.168.9|185.228.169.9|30"
  "198.101.242.72|23.253.163.53|28"
  "84.200.69.80|84.200.70.40|32"
  "77.88.8.8|77.88.8.1|25"
  "208.67.222.222|208.67.220.220|21"
  "64.6.64.6|64.6.65.6|23"
  "8.26.56.26|8.20.247.20|27"
  "176.103.130.130|176.103.130.131|29"
  "37.235.1.174|37.235.1.177|31"
  "156.154.70.1|156.154.71.1|33"
  "185.75.190.190|185.75.190.191|34"
  "45.90.28.0|45.90.28.1|35"
  "45.77.165.194|45.77.165.195|36"
  "176.103.130.134|176.103.130.135|37"
  "23.253.163.53|198.101.242.72|38"
)

# Arena Breakout - Iran (VPN-friendly DNS)
dns_map["Arena Breakout-Iran"]=(
  "185.51.200.2|185.51.200.38|40"
  "178.22.122.100|178.22.122.101|45"
  "185.55.77.77|185.55.77.78|43"
  "209.222.18.222|209.222.18.218|42"
  "185.121.177.177|185.121.177.178|41"
  "80.82.77.21|80.82.77.22|44"
  "193.183.98.154|193.183.98.155|46"
  "185.70.100.100|185.70.100.101|47"
  "176.103.130.130|176.103.130.131|39"
  "195.46.39.39|195.46.39.40|38"
  "208.67.222.222|208.67.220.220|41"
  "1.1.1.1|1.0.0.1|37"
  "8.8.8.8|8.8.4.4|35"
  "94.140.14.14|94.140.15.15|36"
  "9.9.9.9|149.112.112.112|34"
  "45.90.28.0|45.90.28.1|33"
  "77.88.8.8|77.88.8.1|32"
  "64.6.64.6|64.6.65.6|31"
  "185.228.168.9|185.228.169.9|30"
  "208.67.222.220|208.67.220.222|29"
)

# Add more dns entries similarly for other games and countries here...

# ====== Helper Functions ======

print_list() {
  local arr=("${!1}")
  for i in "${!arr[@]}"; do
    echo "$((i+1)). ${arr[i]}"
  done
}

select_option() {
  local arr=("${!1}")
  local prompt="$2"
  local choice
  while true; do
    echo -e "$prompt"
    print_list arr[@]
    read -rp "Select number: " choice
    if [[ "$choice" =~ ^[0-9]+$ ]] && ((choice >= 1 && choice <= ${#arr[@]})); then
      echo "${arr[choice-1]}"
      break
    else
      echo "Invalid input, try again."
    fi
  done
}

loading_animation() {
  local duration=$1
  local chars="/-\|"
  for ((i=0; i<duration*10; i++)); do
    printf "\rLoading... %s" "${chars:i%4:1}"
    sleep 0.1
  done
  echo -e "\r               \r"
}

print_dns() {
  local game="$1"
  local country="$2"
  local dns_list=("${!3}")

  # Pick one random dns from list
  local selected_dns="${dns_list[$RANDOM % ${#dns_list[@]}]}"
  IFS="|" read -r primary secondary ping <<< "$selected_dns"

  # Output format based on if game or not
  if [[ " ${games[*]} " == *"$game"* ]]; then
    echo -e "\nGame:"
    echo -e "$game"
    echo -e "Country:"
    echo -e "$country"
    echo -e "1. Primary: $primary | Secondary: $secondary"
    echo -e "2. Ping: $ping ms"
  else
    echo -e "\nCountry:"
    echo -e "$country"
    echo -e "1. Primary: $primary | Secondary: $secondary"
    echo -e "2. Ping: $ping ms"
  fi
}

# ====== Auto Mode ======

auto_mode() {
  clear
  echo -e "${color}Starting Auto Mode. Press CTRL+C to exit.${RESET}\n"
  while true; do
    game=$(select_option games[@] "Select a game:")
    country=$(select_option countries[@] "Select a country:")
    key="$game-$country"
    dns_list=("${dns_map[$key][@]}")

    # Check if we have DNS entries
    if [ -z "${dns_map[$key]+x}" ]; then
      echo "No DNS entries found for $game in $country."
    else
      print_dns "$game" "$country" dns_map["$key"][@]
    fi
    echo -e "\nWaiting 30 seconds for next DNS...\n"
    sleep 30
  done
}

# ====== Main Program ======

while true; do
  echo -e "\nSelect Mode:"
  echo "1) Normal Mode (Choose game and country, get 1 DNS)"
  echo "2) Auto Mode (Continuous updates every 30 seconds)"
  echo "3) Exit"
  read -rp "Choose option: " mode

  case $mode in
    1)
      clear
      game=$(select_option games[@] "Select a game:")
      clear
      country=$(select_option countries[@] "Select a country:")
      clear
      key="$game-$country"

      if [ -z "${dns_map[$key]+x}" ]; then
        echo "No DNS entries found for $game in $country."
        continue
      fi

      loading_animation 3
      print_dns "$game" "$country" dns_map["$key"][@]
      ;;

    2)
      auto_mode
      ;;

    3)
      echo "Goodbye!"
      exit 0
      ;;

    *)
      echo "Invalid option. Try again."
      ;;
  esac
done
