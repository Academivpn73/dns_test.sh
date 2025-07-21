#!/bin/bash

reset="\e[0m"
green="\e[1;32m"
blue="\e[1;34m"
cyan="\e[1;36m"
red="\e[1;31m"
yellow="\e[1;33m"
purple="\e[1;35m"

# رنگ‌های مختلف برای عنوان
colors=("$cyan" "$green" "$blue" "$purple" "$yellow")

# انیمیشن تایپ خط به خط
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

# نمایش عنوان با انیمیشن و تغییر رنگ تصادفی
show_title() {
  rand=$((RANDOM % ${#colors[@]}))
  color=${colors[$rand]}
  lines=(
    "${color}╔════════════════════════════════════════════════════╗"
    "║        Gaming DNS Management Tool                ║"
    "║        Version 2.1 | @Academi_vpn                ║"
    "╚════════════════════════════════════════════════════╝${reset}"
  )
  print_animated_lines "${lines[@]}"
}

# لیست کشورها
countries=("Iran" "Iraq" "UAE" "Turkey" "Qatar" "Saudi Arabia" "Jordan" "Kuwait" "Oman" "Bahrain")

# لیست کامل 40تایی بازی برای هر پلتفرم
pc_games=("Valorant" "Fortnite" "CS:GO" "Dota 2" "League of Legends" "Overwatch 2" "Apex Legends" "Warframe" "Rust" "Team Fortress 2" "Minecraft" "War Thunder" "World of Tanks" "Lost Ark" "Genshin Impact" "Path of Exile" "PUBG PC" "Battlefield V" "ARMA 3" "DayZ" "Escape From Tarkov" "Destiny 2" "Halo Infinite" "Rainbow Six Siege" "Call of Duty Warzone" "Fall Guys" "Sea of Thieves" "Left 4 Dead 2" "Dead by Daylight" "Elden Ring" "Cyberpunk 2077" "Paladins" "Smite" "Phasmophobia" "Rocket League" "Splitgate" "World War 3" "Tarkov Arena" "Stalker 2")
console_games=("FIFA 24" "Call of Duty MW3" "Rocket League" "GTA Online" "Elden Ring" "Destiny 2" "Red Dead Redemption 2" "NBA 2K24" "Gran Turismo 7" "God of War Ragnarok" "Hogwarts Legacy" "Spider-Man 2" "The Last of Us" "Cyberpunk 2077" "Fallout 4" "Battlefield 2042" "Minecraft Console" "Halo Infinite" "Street Fighter 6" "Diablo IV" "Forza Horizon 5" "Apex Legends" "Overwatch 2" "PUBG Console" "ARK Survival" "Rainbow Six Siege" "Ghost of Tsushima" "Callisto Protocol" "Assassin's Creed Mirage" "Skull and Bones" "Resident Evil 4 Remake" "Death Stranding" "Watch Dogs Legion" "Days Gone" "Mortal Kombat 11" "NHL 24" "Granblue Fantasy" "Silent Hill 2 Remake" "Baldur's Gate 3")
mobile_games=("PUBG Mobile" "Call of Duty Mobile" "Arena Breakout ${yellow}(جدید)${reset}" "Free Fire" "Wild Rift" "Mobile Legends" "Clash of Clans" "Clash Royale" "Brawl Stars" "League of Legends Mobile" "Genshin Impact" "Among Us" "Roblox" "8 Ball Pool" "Candy Crush Saga" "Subway Surfers" "Standoff 2" "Modern Combat 5" "Shadowgun Legends" "Farlight 84" "Sky Children of Light" "World War Heroes" "Sniper 3D" "Zooba" "Crossfire: Legends" "Zula Mobile" "MadOut2" "Battle Prime" "CarX Drift Racing 2" "Tacticool" "Bullet Echo" "Warface GO" "Dead Trigger 2" "Infinity Ops" "Cover Fire" "Arena of Valor" "Boom Beach" "Mobile Royale" "Top Eleven" "eFootball Mobile")

# تولید بیش از 100 DNS جعلی برای هر نوع
make_fake_dns_list() {
  list=()
  for ((i=1; i<=120; i++)); do
    a=$((RANDOM % 255))
    b=$((RANDOM % 255))
    c=$((RANDOM % 255))
    d=$((RANDOM % 255))
    e=$((RANDOM % 255))
    f=$((RANDOM % 255))
    list+=("$a.$b.$c.$d $e.$f.$b.$a")
  done
  echo "${list[@]}"
}

dns_pool_game=( $(make_fake_dns_list) )
dns_pool_console=( $(make_fake_dns_list) )
dns_pool_download=( $(make_fake_dns_list) )

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
    echo -e "${blue}[5]${reset} Auto Mod 🛠️"
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
      5) echo "(Auto Mod functionality not implemented yet)"; read -p "Press Enter..." ;;
      0) echo -e "${green}Goodbye 🙏🏻${reset}"; exit ;;
      *) echo -e "${red}Invalid input!${reset}"; sleep 1 ;;
    esac
  done
}

main_menu
