#!/bin/bash

# رنگ‌ها
reset="\e[0m"
red="\e[1;31m"
green="\e[1;32m"
yellow="\e[1;33m"
blue="\e[1;34m"
cyan="\e[1;36m"
purple="\e[1;35m"

title_colors=("$cyan" "$green" "$yellow" "$purple" "$blue")

print_animated_lines() {
  lines=("$@")
  clear
  for line in "${lines[@]}"; do
    for ((i=0; i<${#line}; i++)); do
      echo -ne "${line:$i:1}"
      sleep 0.002
    done
    echo
  done
}

show_title() {
  clear
  local color=${title_colors[$RANDOM % ${#title_colors[@]}]}
  lines=(
    "${color}╔════════════════════════════════════════════════════╗"
    "║              Telegram: @Academi_vpn               ║"
    "║              Admin By: @MahdiAGM0                  ║"
    "║              Version : 1.2.5                        ║"
    "╚════════════════════════════════════════════════════╝${reset}"
  )
  print_animated_lines "${lines[@]}"
}

countries=("Iran" "Iraq" "UAE" "Turkey" "Qatar" "Saudi Arabia" "Jordan" "Kuwait" "Oman" "Bahrain")

# لیست بازی‌ها و DNS ها
pc_games=(
"Valorant" "Fortnite" "CS:GO" "Dota 2" "League of Legends" "Overwatch 2" "Apex Legends" "Warframe"
"Rust" "Team Fortress 2" "Minecraft" "War Thunder" "World of Tanks" "Lost Ark" "Genshin Impact"
"Path of Exile" "PUBG PC" "Battlefield V" "ARMA 3" "DayZ" "Escape From Tarkov" "Destiny 2" "Halo Infinite"
"Rainbow Six Siege" "Call of Duty Warzone" "Fall Guys" "Sea of Thieves" "Left 4 Dead 2" "Dead by Daylight"
"Elden Ring" "Cyberpunk 2077" "Paladins" "Smite" "Phasmophobia" "Rocket League" "Splitgate" "World War 3"
"Tarkov Arena" "Stalker 2"
)

console_games=(
"FIFA 24" "Call of Duty MW3" "Rocket League" "GTA Online" "Elden Ring" "Destiny 2" "Red Dead Redemption 2"
"NBA 2K24" "Gran Turismo 7" "God of War Ragnarok" "Hogwarts Legacy" "Spider-Man 2" "The Last of Us"
"Cyberpunk 2077" "Fallout 4" "Battlefield 2042" "Minecraft Console" "Halo Infinite" "Street Fighter 6"
"Diablo IV" "Forza Horizon 5" "Apex Legends" "Overwatch 2" "PUBG Console" "ARK Survival" "Rainbow Six Siege"
"Ghost of Tsushima" "Callisto Protocol" "Assassin's Creed Mirage" "Skull and Bones" "Resident Evil 4 Remake"
"Death Stranding" "Watch Dogs Legion" "Days Gone" "Mortal Kombat 11" "NHL 24" "Granblue Fantasy"
"Silent Hill 2 Remake" "Baldur's Gate 3"
)

orange="\e[0;33m"
reset_color="\e[0m"
mobile_games=(
"PUBG Mobile" "Call of Duty Mobile" "${orange}Arena Breakout (New)${reset_color}" "Free Fire" "Wild Rift" "Mobile Legends"
"Clash of Clans" "Clash Royale" "Brawl Stars" "League of Legends Mobile" "Genshin Impact" "Among Us" "Roblox" "8 Ball Pool"
"Candy Crush Saga" "Subway Surfers" "Standoff 2" "Modern Combat 5" "Shadowgun Legends" "Farlight 84" "Sky Children of Light"
"World War Heroes" "Sniper 3D" "Zooba" "Crossfire: Legends" "Zula Mobile" "MadOut2" "Battle Prime" "CarX Drift Racing 2"
"Tacticool" "Bullet Echo" "Warface GO" "Dead Trigger 2" "Infinity Ops" "Cover Fire" "Arena of Valor" "Boom Beach"
"Mobile Royale" "Top Eleven" "eFootball Mobile"
)

pc_dns=(
"1.1.1.1 1.0.0.1" "8.8.8.8 8.8.4.4" "9.9.9.9 149.112.112.112" "208.67.222.222 208.67.220.220"
"84.200.69.80 84.200.70.40" "77.88.8.8 77.88.8.1" "114.114.114.114 114.114.115.115" "119.29.29.29 182.254.116.116"
"223.5.5.5 223.6.6.6" "8.26.56.26 8.20.247.20" "156.154.70.1 156.154.71.1" "91.239.100.100 89.233.43.71"
"195.46.39.39 195.46.39.40" "208.76.50.50 208.76.51.51" "64.6.64.6 64.6.65.6" "84.200.69.80 84.200.70.40"
"4.2.2.1 4.2.2.2" "37.235.1.174 37.235.1.177" "77.88.8.8 77.88.8.1" "1.0.0.1 1.1.1.1"
)

console_dns=(
"1.1.1.1 1.0.0.1" "8.8.8.8 8.8.4.4" "9.9.9.9 149.112.112.112" "208.67.222.222 208.67.220.220"
"77.88.8.8 77.88.8.1" "114.114.114.114 114.114.115.115" "223.5.5.5 223.6.6.6" "8.26.56.26 8.20.247.20"
"156.154.70.1 156.154.71.1" "91.239.100.100 89.233.43.71" "195.46.39.39 195.46.39.40" "208.76.50.50 208.76.51.51"
"64.6.64.6 64.6.65.6" "84.200.69.80 84.200.70.40" "4.2.2.1 4.2.2.2" "37.235.1.174 37.235.1.177"
)

mobile_dns=(
"1.1.1.1 1.0.0.1" "8.8.8.8 8.8.4.4" "9.9.9.9 149.112.112.112" "208.67.222.222 208.67.220.220"
"77.88.8.8 77.88.8.1" "114.114.114.114 114.114.115.115" "223.5.5.5 223.6.6.6" "8.26.56.26 8.20.247.20"
"156.154.70.1 156.154.71.1" "91.239.100.100 89.233.43.71" "195.46.39.39 195.46.39.40" "208.76.50.50 208.76.51.51"
"64.6.64.6 64.6.65.6" "84.200.69.80 84.200.70.40" "4.2.2.1 4.2.2.2" "37.235.1.174 37.235.1.177"
)

download_dns=(
"1.1.1.1 1.0.0.1" "8.8.8.8 8.8.4.4" "9.9.9.9 149.112.112.112" "208.67.222.222 208.67.220.220"
"77.88.8.8 77.88.8.1" "114.114.114.114 114.114.115.115" "223.5.5.5 223.6.6.6" "8.26.56.26 8.20.247.20"
"156.154.70.1 156.154.71.1" "91.239.100.100 89.233.43.71"
)

check_ping() {
  ip=$1
  ping -c 1 -W 1 "$ip" >/dev/null 2>&1
  if [ $? -eq 0 ]; then
    ping -c 1 -W 1 "$ip" | grep 'time=' | awk -F'time=' '{print $2}' | cut -d' ' -f1
  else
    echo "Timeout"
  fi
}

print_dns() {
  local game="$1"
  local country="$2"
  local dns1="$3"
  local dns2="$4"
  local ping1=$(check_ping "$dns1")
  local ping2=$(check_ping "$dns2")

  echo -e "${green}Game:${reset} $game"
  if [[ -n "$country" ]]; then
    echo -e "${green}Country:${reset} $country"
  fi
  echo -e "${cyan}DNS Set 1:${reset}"
  echo -e "  Primary: $dns1"
  echo -e "  Secondary: $dns2"
  echo -e "${blue}Ping DNS:${reset}"
  echo -e "  Primary: $ping1 ms"
  echo -e "  Secondary: $ping2 ms"
  echo
  read -p "Press Enter to return to main menu..."
}

select_dns() {
  local type=$1
  local games dns_list

  if [[ "$type" == "pc" ]]; then
    games=("${pc_games[@]}")
    dns_list=("${pc_dns[@]}")
  elif [[ "$type" == "console" ]]; then
    games=("${console_games[@]}")
    dns_list=("${console_dns[@]}")
  elif [[ "$type" == "mobile" ]]; then
    games=("${mobile_games[@]}")
    dns_list=("${mobile_dns[@]}")
  elif [[ "$type" == "download" ]]; then
    games=("Download & Anti-Geo Block DNS")
    dns_list=("${download_dns[@]}")
  else
    echo "Unknown type"
    return
  fi

  clear
  echo -e "${yellow}Select a game:${reset}"
  for i in "${!games[@]}"; do
    printf "${blue}[%d]${reset} %s\n" $((i+1)) "${games[$i]}"
  done

  read -p "Enter number: " g_choice
  while ! [[ "$g_choice" =~ ^[0-9]+$ ]] || (( g_choice < 1 || g_choice > ${#games[@]} )); do
    echo -e "${red}Invalid input! Try again.${reset}"
    read -p "Enter number: " g_choice
  done
  local game="${games[$((g_choice-1))]}"

  clear
  local country=""
  if [[ "$type" != "download" ]]; then
    echo -e "${yellow}Select your country:${reset}"
    for i in "${!countries[@]}"; do
      printf "${blue}[%d]${reset} %s\n" $((i+1)) "${countries[$i]}"
    done
    read -p "Enter number: " c_choice
    while ! [[ "$c_choice" =~ ^[0-9]+$ ]] || (( c_choice < 1 || c_choice > ${#countries[@]} )); do
      echo -e "${red}Invalid input! Try again.${reset}"
      read -p "Enter number: " c_choice
    done
    country="${countries[$((c_choice-1))]}"
  fi

  clear
  echo -e "${yellow}Select DNS Set:${reset}"
  for i in "${!dns_list[@]}"; do
    dns_pair=${dns_list[$i]}
    printf "${blue}[%d]${reset} %s\n" $((i+1)) "$dns_pair"
  done

  read -p "Enter number: " d_choice
  while ! [[ "$d_choice" =~ ^[0-9]+$ ]] || (( d_choice < 1 || d_choice > ${#dns_list[@]} )); do
    echo -e "${red}Invalid input! Try again.${reset}"
    read -p "Enter number: " d_choice
  done
  dns_set="${dns_list[$((d_choice-1))]}"
  dns1=$(echo $dns_set | awk '{print $1}')
  dns2=$(echo $dns_set | awk '{print $2}')

  clear
  print_dns "$game" "$country" "$dns1" "$dns2"
}

main_menu() {
  while true; do
    show_title
    echo -e "${yellow}Select Platform:${reset}"
    echo -e "${blue}[1]${reset} PC Games"
    echo -e "${blue}[2]${reset} Console Games"
    echo -e "${blue}[3]${reset} Mobile Games"
    echo -e "${blue}[4]${reset} Download & Anti-Geo Block DNS"
    echo -e "${blue}[5]${reset} Exit"
    read -p "Enter your choice: " choice

    case $choice in
      1) select_dns "pc" ;;
      2) select_dns "console" ;;
      3) select_dns "mobile" ;;
      4) select_dns "download" ;;
      5) echo "Goodbye!"; exit 0 ;;
      *) echo -e "${red}Invalid choice! Try again.${reset}"; sleep 1 ;;
    esac
  done
}

# اجرای برنامه
main_menu
