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

# نمایش عنوان با انیمیشن
show_title() {
  lines=(
    "${cyan}╔══════════════════════════════════════════╗"
    "║           Gaming DNS Management Tool     ║"
    "║           Version 3.0 | @Academi_vpn      ║"
    "╚══════════════════════════════════════════╝${reset}"
  )
  print_animated_lines "${lines[@]}"
}

# لیست کشورها
countries=("Iran" "Iraq" "UAE" "Turkey" "Qatar" "Saudi Arabia" "Jordan" "Oman" "Bahrain" "Kuwait" "Lebanon" "Syria" "Palestine" "Yemen")

# لیست بازی‌ها (40 عدد برای هر پلتفرم)
pc_games=("Valorant" "Fortnite" "CS:GO" "Dota 2" "League of Legends" "Overwatch 2" "Apex Legends" "Battlefield 2042" "Escape from Tarkov" "Minecraft" "Roblox" "Rust" "Team Fortress 2" "Diablo IV" "Starfield" "Cyberpunk 2077" "World of Warcraft" "Black Desert" "Elder Scrolls Online" "Guild Wars 2" "DayZ" "ARK" "Halo Infinite" "Lost Ark" "PUBG PC" "Paladins" "Smite" "Destiny 2" "Warframe" "R6 Siege" "Crossfire" "Dead by Daylight" "World War 3" "Genshin Impact" "Sons of the Forest" "Farming Simulator" "Fall Guys" "Tarkov Arena" "SCUM")

console_games=("FIFA 24" "Call of Duty" "Rocket League" "GTA Online" "Elden Ring" "NBA 2K24" "Gran Turismo 7" "Red Dead Online" "The Crew 2" "Forza Horizon 5" "Battlefield V" "Destiny 2" "Fall Guys" "Diablo IV" "Minecraft" "Dead by Daylight" "Brawlhalla" "World of Tanks" "The Division 2" "Halo Infinite" "Apex Legends" "R6 Siege" "Fortnite" "Cyberpunk 2077" "PUBG Console" "Warframe" "Smite" "WWE 2K24" "ARK" "Rust Console" "Path of Exile" "Overwatch 2" "Callisto Protocol" "Sea of Thieves" "Monster Hunter" "Guilty Gear" "Mortal Kombat 1" "Street Fighter 6" "Riders Republic")

mobile_games=("PUBG Mobile" "Call of Duty Mobile" "Arena Breakout" "Free Fire" "Wild Rift" "Clash Royale" "Clash of Clans" "Brawl Stars" "Mobile Legends" "Arena of Valor" "New State Mobile" "Genshin Impact" "Fortnite Mobile" "Farlight 84" "Sky Children" "LifeAfter" "Cyber Hunter" "Bullet Echo" "Hyper Front" "Standoff 2" "Modern Combat 5" "Warface GO" "Pixel Gun 3D" "Zooba" "State of Survival" "Among Us" "Lords Mobile" "Boom Beach" "Mech Arena" "Marvel Super War" "Pokemon Unite" "Honkai Impact" "AFK Arena" "Summoners War" "Magic Rush" "Tacticool" "Shadowgun Legends" "Dead Trigger 2" "Into the Dead 2")

# ساخت DNSهای ساختگی (برای مثال، بیش از 100 DNS به صورت تکراری و نمونه‌ای ساخته می‌شوند)
dns_pool_game=()
dns_pool_console=()
dns_pool_download=()
for i in {1..100}; do
  dns_pool_game+=("1.1.$i.$((i+1)) 1.0.$i.$((i+2))")
  dns_pool_console+=("10.0.$i.$((i+1)) 10.0.$((i+1)).$((i+2))")
  dns_pool_download+=("185.51.${i}.1 178.22.${i}.2")
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
  echo -e "\n${cyan}DNS Set 1:${reset}"
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
