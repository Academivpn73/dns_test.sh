#!/bin/bash

RESET="\e[0m"
ORANGE="\e[38;5;208m"
GREEN="\e[1;32m"
CYAN="\e[1;36m"
RED="\e[1;31m"

# Title with rotating colors
TITLE_COLORS=("\e[1;36m" "\e[1;32m" "\e[1;33m" "\e[1;35m" "\e[1;34m")
TITLE_LINES=(
"╔════════════════════════════════════════════════════════════╗"
"║            Gaming DNS Management Tool                      ║"
"║    Telegram: @Academi_vpn   Admin By: @MahdiAGM0          ║"
"║                    Version : 1.2.5                         ║"
"╚════════════════════════════════════════════════════════════╝"
)

COUNTRIES=("Iran" "Iraq" "UAE" "Turkey" "Qatar" "Saudi Arabia" "Jordan" "Kuwait" "Oman" "Bahrain")

# Games with (New) only once, no color code in the name itself, color applied when printing
PC_GAMES=(
"Valorant" "Fortnite" "CS:GO" "Dota 2" "League of Legends" "Overwatch 2" "Apex Legends" "Warframe" "Rust" "Team Fortress 2"
"Minecraft" "War Thunder" "World of Tanks" "Lost Ark" "Genshin Impact" "Path of Exile" "PUBG PC" "Battlefield V" "ARMA 3" "DayZ"
"Escape From Tarkov" "Destiny 2" "Halo Infinite" "Rainbow Six Siege" "Call of Duty Warzone" "Fall Guys" "Sea of Thieves" "Left 4 Dead 2" "Dead by Daylight" "Elden Ring"
"Cyberpunk 2077" "Paladins" "Smite" "Phasmophobia" "Rocket League" "Splitgate" "World War 3" "Tarkov Arena" "Stalker 2" "Battlefield 2042"
"Skyrim" "Fallout 76" "Among Us" "Hades" "Terraria" "Metro Exodus" "CyberConnect2" "Dark Souls 3" "The Witcher 3" "Control"
)

CONSOLE_GAMES=(
"FIFA 24" "Call of Duty MW3" "Rocket League" "GTA Online" "Elden Ring" "Destiny 2" "Red Dead Redemption 2" "NBA 2K24" "Gran Turismo 7" "God of War Ragnarok"
"Hogwarts Legacy" "Spider-Man 2" "The Last of Us" "Cyberpunk 2077" "Fallout 4" "Battlefield 2042" "Minecraft Console" "Halo Infinite" "Street Fighter 6" "Diablo IV"
"Forza Horizon 5" "Apex Legends" "Overwatch 2" "PUBG Console" "ARK Survival" "Rainbow Six Siege" "Ghost of Tsushima" "Callisto Protocol" "Assassin's Creed Mirage" "Skull and Bones"
"Resident Evil 4 Remake" "Death Stranding" "Watch Dogs Legion" "Days Gone" "Mortal Kombat 11" "NHL 24" "Granblue Fantasy" "Silent Hill 2 Remake" "Baldur's Gate 3" "Splatoon 3"
"Halo 3" "God of War 3" "Gears of War 5" "Mass Effect Legendary Edition" "Bayonetta 3" "Monster Hunter Rise" "Ratchet & Clank" "Doom Eternal" "Metal Gear Solid V" "Sea of Thieves"
)

MOBILE_GAMES=(
"PUBG Mobile" "Call of Duty Mobile" "Arena Breakout" "Free Fire" "Wild Rift" "Mobile Legends" "Clash of Clans" "Clash Royale" "Brawl Stars" "League of Legends Mobile"
"Genshin Impact" "Among Us" "Roblox" "8 Ball Pool" "Candy Crush Saga" "Subway Surfers" "Standoff 2" "Modern Combat 5" "Shadowgun Legends" "Farlight 84"
"Sky Children of Light" "World War Heroes" "Sniper 3D" "Zooba" "Crossfire: Legends" "Zula Mobile" "MadOut2" "Battle Prime" "CarX Drift Racing 2" "Tacticool"
"Bullet Echo" "Warface GO" "Dead Trigger 2" "Infinity Ops" "Cover Fire" "Arena of Valor" "Boom Beach" "Mobile Royale" "Top Eleven" "eFootball Mobile"
"Pokemon Go" "Clash Quest" "Legends of Runeterra" "Brawlout" "MARVEL Future Fight" "Call of Dragons" "Dragon Raja" "Lineage 2: Revolution" "Black Desert Mobile" "Vainglory"
)

# DNS pools: برای هر کشور یک مجموعه اولیه و ثانویه (خیلی بزرگ)
declare -A DNS_POOL_PRIMARY
declare -A DNS_POOL_SECONDARY

# نمونه ساده: فقط 20 DNS برای هر کشور - برای واقعی بودن باید اضافه کنی
DNS_POOL_PRIMARY["Iran"]="1.1.1.1 8.8.8.8 9.9.9.9 208.67.222.222 94.140.14.14"
DNS_POOL_SECONDARY["Iran"]="1.0.0.1 8.8.4.4 149.112.112.112 208.67.220.220 94.140.15.15"

DNS_POOL_PRIMARY["Iraq"]="77.88.8.8 185.228.168.168 80.80.80.80 84.200.69.80 1.1.1.1"
DNS_POOL_SECONDARY["Iraq"]="77.88.8.1 185.228.169.9 80.80.81.81 84.200.70.40 1.0.0.1"

DNS_POOL_PRIMARY["UAE"]="8.8.8.8 1.1.1.1 9.9.9.9 208.67.222.222 94.140.14.14"
DNS_POOL_SECONDARY["UAE"]="8.8.4.4 1.0.0.1 149.112.112.112 208.67.220.220 94.140.15.15"

DNS_POOL_PRIMARY["Turkey"]="9.9.9.9 1.1.1.1 8.8.8.8 208.67.222.222 77.88.8.8"
DNS_POOL_SECONDARY["Turkey"]="149.112.112.112 1.0.0.1 8.8.4.4 208.67.220.220 77.88.8.1"

DNS_POOL_PRIMARY["Qatar"]="208.67.222.222 9.9.9.9 1.1.1.1 8.8.8.8 77.88.8.8"
DNS_POOL_SECONDARY["Qatar"]="208.67.220.220 149.112.112.112 1.0.0.1 8.8.4.4 77.88.8.1"

DNS_POOL_PRIMARY["Saudi Arabia"]="1.1.1.1 8.8.8.8 9.9.9.9 208.67.222.222 94.140.14.14"
DNS_POOL_SECONDARY["Saudi Arabia"]="1.0.0.1 8.8.4.4 149.112.112.112 208.67.220.220 94.140.15.15"

DNS_POOL_PRIMARY["Jordan"]="8.8.8.8 1.1.1.1 77.88.8.8 208.67.222.222 9.9.9.9"
DNS_POOL_SECONDARY["Jordan"]="8.8.4.4 1.0.0.1 77.88.8.1 208.67.220.220 149.112.112.112"

DNS_POOL_PRIMARY["Kuwait"]="1.1.1.1 9.9.9.9 208.67.222.222 8.8.8.8 77.88.8.8"
DNS_POOL_SECONDARY["Kuwait"]="1.0.0.1 149.112.112.112 208.67.220.220 8.8.4.4 77.88.8.1"

DNS_POOL_PRIMARY["Oman"]="208.67.222.222 1.1.1.1 8.8.8.8 9.9.9.9 94.140.14.14"
DNS_POOL_SECONDARY["Oman"]="208.67.220.220 1.0.0.1 8.8.4.4 149.112.112.112 94.140.15.15"

DNS_POOL_PRIMARY["Bahrain"]="9.9.9.9 208.67.222.222 1.1.1.1 8.8.8.8 77.88.8.8"
DNS_POOL_SECONDARY["Bahrain"]="149.112.112.112 208.67.220.220 1.0.0.1 8.8.4.4 77.88.8.1"

# حافظه کوتاه مدت DNS های داده شده تا تکراری نده
declare -A USED_DNS_PRIMARY
declare -A USED_DNS_SECONDARY

# متد چاپ عنوان با رنگ چرخشی
title_color_index=0
print_title() {
  clear
  local color=${TITLE_COLORS[$title_color_index]}
  ((title_color_index=(title_color_index+1) % ${#TITLE_COLORS[@]}))
  for line in "${TITLE_LINES[@]}"; do
    echo -e "${color}${line}${RESET}"
  done
  echo
}

# انیمیشن ساده چاپ خط به خط
animate_print() {
  for line in "$@"; do
    echo -e "$line"
    sleep 0.03
  done
}

# نمایش منوی اصلی
show_main_menu() {
  print_title
  local menu=(
    "[1] PC Games"
    "[2] Console Games"
    "[3] Mobile Games"
    "[4] Download Accelerator DNS"
    "[5] VPN DNS (Anti-Filter)"
    "[6] Auto Benchmark DNS"
    "[0] Exit"
  )
  animate_print "${menu[@]}"
  echo
  read -rp "Select your option: " opt
  case $opt in
    1) show_game_list "pc" ;;
    2) show_game_list "console" ;;
    3) show_game_list "mobile" ;;
    4) show_dns_list "download" ;;
    5) show_dns_list "vpn" ;;
    6) auto_benchmark ;;
    0) exit 0 ;;
    *) echo -e "${RED}Invalid option.${RESET}"; sleep 1; show_main_menu ;;
  esac
}

# انتخاب بازی
show_game_list() {
  local section=$1
  print_title
  local games_var="${section^^}_GAMES[@]"
  local games_list=("${!games_var}")
  echo -e "${ORANGE}Select a game:${RESET}"
  local i=1
  for game in "${games_list[@]}"; do
    if [[ "$game" == *"New"* ]]; then
      # حذف کلمه New در متن اصلی و اضافه کردن رنگ و (New) در نمایش
      plain_game="${game//\(New\)/}"
      echo -e "[$i] ${plain_game} ${GREEN}(New)${RESET}"
    else
      echo "[$i] $game"
    fi
    ((i++))
  done
  echo "[0] Back to main menu"
  echo
  read -rp "Choose game: " game_opt
  if [[ "$game_opt" == "0" ]]; then show_main_menu; return; fi
  if (( game_opt < 1 || game_opt > ${#games_list[@]} )); then
    echo -e "${RED}Invalid selection.${RESET}"
    sleep 1
    show_game_list "$section"
    return
  fi

  # انتخاب کشور بعد بازی
  selected_game="${games_list[$game_opt-1]}"
  select_country_and_show_dns "$section" "$selected_game"
}

# انتخاب کشور و نمایش DNS برای بازی انتخاب شده
select_country_and_show_dns() {
  local section=$1
  local game=$2
  print_title
  echo -e "${CYAN}Selected Game: ${GREEN}$game${RESET}"
  echo -e "${ORANGE}Select your country:${RESET}"
  local i=1
  for c in "${COUNTRIES[@]}"; do
    echo "[$i] $c"
    ((i++))
  done
  echo "[0] Back to game list"
  echo
  read -rp "Choose country: " country_opt
  if [[ "$country_opt" == "0" ]]; then
    show_game_list "$section"
    return
  fi
  if (( country_opt < 1 || country_opt > ${#COUNTRIES[@]} )); then
    echo -e "${RED}Invalid selection.${RESET}"
    sleep 1
    select_country_and_show_dns "$section" "$game"
    return
  fi
  selected_country="${COUNTRIES[$country_opt-1]}"
  show_dns_for_game_country "$game" "$selected_country"
}

# نمایش DNS با ping و بدون تکرار DNS قبلی
show_dns_for_game_country() {
  local game=$1
  local country=$2
  print_title
  echo -e "${GREEN}Game: ${CYAN}$game${RESET}"
  echo -e "${GREEN}Country: ${CYAN}$country${RESET}"

  # انتخاب dns اولیه و ثانویه بدون تکرار
  IFS=' ' read -r -a primaries <<< "${DNS_POOL_PRIMARY[$country]}"
  IFS=' ' read -r -a secondaries <<< "${DNS_POOL_SECONDARY[$country]}"

  # تابع برای انتخاب dns جدید از لیست بدون تکرار
  select_new_dns() {
    local -n dns_array=$1
    local used_dns_ref=$2
    local tries=0
    local max_tries=100
    local dns_ip=""
    while (( tries < max_tries )); do
      local idx=$(( RANDOM % ${#dns_array[@]} ))
      dns_ip=${dns_array[$idx]}
      if [[ -z "${used_dns_ref[$dns_ip]}" ]]; then
        used_dns_ref[$dns_ip]=1
        echo "$dns_ip"
        return
      fi
      ((tries++))
    done
    # اگر نتونست dns جدید پیدا کنه، dns اول لیست رو برگردونه
    echo "${dns_array[0]}"
  }

  primary_dns=$(select_new_dns primaries USED_DNS_PRIMARY)
  secondary_dns=$(select_new_dns secondaries USED_DNS_SECONDARY)

  echo -e "Primary DNS  : $primary_dns"
  echo -e "Secondary DNS: $secondary_dns"
  echo

  echo -e "${CYAN}Pinging Primary DNS ($primary_dns)...${RESET}"
  ping -c 3 "$primary_dns" 2>&1 | grep 'rtt\|time=' || echo -e "${RED}Ping failed or no response.${RESET}"
  echo
  echo -e "${CYAN}Pinging Secondary DNS ($secondary_dns)...${RESET}"
  ping -c 3 "$secondary_dns" 2>&1 | grep 'rtt\|time=' || echo -e "${RED}Ping failed or no response.${RESET}"
  echo

  read -rp "Press Enter to return to main menu..." _
  show_main_menu
}

# نمایش لیست DNS های دانلود یا VPN (مثال ساده)
show_dns_list() {
  local section=$1
  print_title
  echo -e "${GREEN}$section DNS List:${RESET}"
  echo -e "1. Primary: 1.1.1.1 | Secondary: 1.0.0.1"
  echo -e "2. Primary: 8.8.8.8 | Secondary: 8.8.4.4"
  echo
  read -rp "Press Enter to return to main menu..." _
  show_main_menu
}

# بنچمارک خودکار DNS (برای نمونه فقط 5 dns اول)
auto_benchmark() {
  print_title
  echo -e "${ORANGE}Auto Benchmark DNS - Top 5 from Iran DNS Pool:${RESET}"
  IFS=' ' read -r -a dns_list <<< "${DNS_POOL_PRIMARY["Iran"]}"
  declare -A ping_results
  for dns in "${dns_list[@]:0:5}"; do
    echo -e "${CYAN}Pinging $dns...${RESET}"
    avg_ping=$(ping -c 4 "$dns" 2>/dev/null | grep 'rtt' | awk -F '/' '{print $5}')
    if [[ -z "$avg_ping" ]]; then avg_ping=999; fi
    ping_results["$dns"]=$avg_ping
  done
  echo -e "${GREEN}Benchmark results:${RESET}"
  for dns in "${!ping_results[@]}"; do
    echo "$dns : ${ping_results[$dns]} ms"
  done | sort -t: -k2 -n
  echo
  read -rp "Press Enter to return to main menu..." _
  show_main_menu
}

# حلقه اصلی برنامه
while true; do
  show_main_menu
done
