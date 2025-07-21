#!/bin/bash

reset="\e[0m"
green="\e[1;32m"
blue="\e[1;34m"
cyan="\e[1;36m"
red="\e[1;31m"

# انیمیشن تایپ خط به خط
print_animated_lines() {
  lines=("$@")
  clear
  for line in "${lines[@]}"; do
    for ((i=0; i<${#line}; i++)); do
      echo -ne "${line:$i:1}"
      sleep 0.005
    done
    echo
  done
}

# نمایش عنوان با انیمیشن بالا به پایین
show_title() {
  lines=(
    "${cyan}╔════════════════════════════════════════════════════╗",
    "║        Gaming DNS Management Tool                ║",
    "║        Version 2.1 | @Academi_vpn                ║",
    "╚════════════════════════════════════════════════════╝${reset}"
  )
  print_animated_lines "${lines[@]}"
}

# لیست کشورها
countries=("Iran" "Iraq" "UAE" "Turkey" "Qatar" "Saudi Arabia" "Jordan" "Oman" "Kuwait" "Bahrain")

# لیست کامل 40 بازی برای هر پلتفرم
pc_games=("Valorant" "Fortnite" "CS:GO" "Dota 2" "League of Legends" "Overwatch 2" "Apex Legends" "Minecraft" "Rust" "Escape from Tarkov" "Rainbow Six Siege" "Warframe" "Battlefield V" "Cyberpunk 2077" "Genshin Impact" "ARK" "Fall Guys" "Roblox" "Lost Ark" "Elder Scrolls Online" "World of Warcraft" "Diablo IV" "Paladins" "Smite" "Team Fortress 2" "Halo Infinite" "War Thunder" "PUBG PC" "The Finals" "Sea of Thieves" "Dead by Daylight" "Hunt Showdown" "DayZ" "GTA V" "Destiny 2" "Final Fantasy XIV" "Star Citizen" "New World" "Path of Exile")

console_games=("FIFA 24" "Call of Duty" "Rocket League" "GTA Online" "Elden Ring" "Red Dead Redemption 2" "Destiny 2" "Overwatch 2" "NBA 2K24" "Apex Legends" "Fortnite" "The Division 2" "Ghost Recon" "Gran Turismo" "Battlefield 2042" "Cyberpunk 2077" "Minecraft" "The Last of Us" "Uncharted" "God of War" "Spiderman" "Assassin's Creed" "Rainbow Six Siege" "Halo" "Forza Horizon" "Madden NFL" "F1 2024" "Diablo IV" "ARK" "Rust" "Paladins" "Smite" "ESO" "Warframe" "Tekken 8" "Street Fighter 6" "Mortal Kombat" "Gears of War" "PUBG Console")

mobile_games=("PUBG Mobile" "Call of Duty Mobile" "Arena Breakout" "Free Fire" "Wild Rift" "Mobile Legends" "Clash Royale" "Clash of Clans" "Brawl Stars" "Among Us" "Roblox Mobile" "Apex Mobile" "Genshin Impact" "FIFA Mobile" "Diablo Immortal" "League of Legends Mobile" "New State Mobile" "Honor of Kings" "Warzone Mobile" "Subway Surfers" "8 Ball Pool" "Asphalt 9" "Shadow Fight 4" "Dragon Ball Legends" "Fortnite Mobile" "TFT Mobile" "Critical Ops" "Modern Combat" "Bullet Echo" "Zula Mobile" "NBA Live Mobile" "eFootball 2024" "World War Heroes" "World of Tanks Blitz" "Naruto Slugfest" "Summoners War" "Clash Mini" "Honkai Impact" "CrossFire Mobile")

# تولید لیست DNS ساختگی 100تایی برای هر بخش
dns_pool_game=()
dns_pool_console=()
dns_pool_download=()
for i in {1..100}; do
  a=$((RANDOM%255))
  b=$((RANDOM%255))
  dns_pool_game+=("1.${a}.${b}.1 1.${a}.${b}.2")
  dns_pool_console+=("2.${a}.${b}.1 2.${a}.${b}.2")
  dns_pool_download+=("3.${a}.${b}.1 3.${a}.${b}.2")
done

check_ping() {
  ip=$1
  result=$(ping -c 1 -W 1 "$ip" 2>/dev/null | grep 'time=' | awk -F'time=' '{print $2}' | cut -d' ' -f1)
  if [[ -z "$result" ]]; then
    echo "Timeout"
  else
    echo "$result ms"
  fi
}

print_dns_format() {
  local game="$1"
  local country="$2"
  local dns1="$3"
  local dns2="$4"
  local ping1=$(check_ping "$dns1")
  local ping2=$(check_ping "$dns2")

  echo -e "\n${green}Game:${reset} $game"
  echo -e "${green}Country:${reset} $country"
  echo -e "\n${cyan}DNS Set:${reset}"
  echo -e "  Primary: $dns1"
  echo -e "  Secondary: $dns2"
  echo -e "${blue}Ping DNS:${reset}"
  echo -e "  Primary: $ping1"
  echo -e "  Secondary: $ping2"
}

select_dns_for_type() {
  local type="$1"

  if [[ "$type" == "pc" ]]; then
    games=("${pc_games[@]}")
    dns_pool=("${dns_pool_game[@]}")
  elif [[ "$type" == "console" ]]; then
    games=("${console_games[@]}")
    dns_pool=("${dns_pool_console[@]}")
  elif [[ "$type" == "mobile" ]]; then
    games=("${mobile_games[@]}")
    dns_pool=("${dns_pool_game[@]}")
  else
    echo "نوع ناشناخته"
    return
  fi

  clear
  echo -e "${green}Select your game:${reset}"
  for i in "${!games[@]}"; do
    printf "${blue}[%d]${reset} %s\n" $((i+1)) "${games[$i]}"
  done
  read -p "Choose number: " gopt
  while [[ ! "$gopt" =~ ^[0-9]+$ ]] || ((gopt < 1 || gopt > ${#games[@]})); do
    echo -e "${red}Invalid choice. Try again.${reset}"
    read -p "Choose number: " gopt
  done
  game="${games[$((gopt-1))]}"

  echo -e "\n${green}Select your country:${reset}"
  for i in "${!countries[@]}"; do
    printf "${blue}[%d]${reset} %s\n" $((i+1)) "${countries[$i]}"
  done
  read -p "Choose number: " copt
  while [[ ! "$copt" =~ ^[0-9]+$ ]] || ((copt < 1 || copt > ${#countries[@]})); do
    echo -e "${red}Invalid choice. Try again.${reset}"
    read -p "Choose number: " copt
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
    echo -e "${blue}[4]${reset} Download DNS ⬇️"
    echo -e "${blue}[0]${reset} Exit ❌"
    echo -ne "\n${green}Choose an option: ${reset}"
    read opt
    case $opt in
      1) select_dns_for_type "pc" ;;
      2) select_dns_for_type "console" ;;
      3) select_dns_for_type "mobile" ;;
      4)
        clear
        for pair in "${dns_pool_download[@]}"; do
          dns1=$(echo $pair | awk '{print $1}')
          dns2=$(echo $pair | awk '{print $2}')
          print_dns_format "Downloader" "Iran" "$dns1" "$dns2"
        done
        read -p "\nPress Enter to return..."
        ;;
      0) echo -e "${green}Goodbye 🙏🏻${reset}"; exit ;;
      *) echo -e "${red}Invalid input!${reset}"; sleep 1 ;;
    esac
  done
}

main_menu
