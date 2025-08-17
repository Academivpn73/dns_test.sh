#!/bin/bash
# =======================================
# Game DNS Manager - Version 6.0.0
# Telegram: @Academi_vpn
# Admin: @MahdiAGM0
# =======================================

# Colors for cycling title
colors=(31 32 33 34 35 36)
color_index=0

# Title animation (fast)
title() {
  local text="=== Game DNS Manager ==="
  for ((i=0; i<${#text}; i++)); do
    local color=${colors[$color_index]}
    echo -ne "\e[${color}m${text:$i:1}\e[0m"
    color_index=$(( (color_index + 1) % ${#colors[@]} ))
    sleep 0.02
  done
  echo -e "\n"
}

# Footer info
print_footer() {
  local color=${colors[$color_index]}
  color_index=$(( (color_index + 1) % ${#colors[@]} ))
  echo -e "\e[${color}m"
  echo "========================================"
  echo " Version: 6.0.0 | Telegram: @Academi_vpn"
  echo " Admin: @MahdiAGM0"
  echo "========================================"
  echo -e "\e[0m"
}

# Pause
pause_enter() {
  read -rp "Press Enter to continue..."
}
# ---------- DNS BANKS (IPv4 ranges) ----------

# Helper: expand range to DNS list
expand_range() {
  local start=$1
  local end=$2
  local base=$(echo $start | cut -d. -f1-3)
  local s=$(echo $start | cut -d. -f4)
  local e=$(echo $end   | cut -d. -f4)
  for ((i=s; i<=e; i++)); do
    echo "$base.$i"
  done
}

# ---------- Iran ----------
IRAN_DNS=(
$(expand_range "5.160.0.1" "5.160.0.100")
$(expand_range "31.7.64.1" "31.7.64.80")
$(expand_range "37.255.128.1" "37.255.128.70")
$(expand_range "79.175.128.1" "79.175.128.50")
$(expand_range "185.55.224.1" "185.55.224.50")
)

# ---------- Saudi Arabia ----------
SAUDI_DNS=(
$(expand_range "85.194.0.1" "85.194.0.100")
$(expand_range "86.51.0.1" "86.51.0.80")
$(expand_range "188.48.0.1" "188.48.0.70")
$(expand_range "195.246.48.1" "195.246.48.50")
$(expand_range "217.17.32.1" "217.17.32.50")
)

# ---------- Turkey ----------
TURKEY_DNS=(
$(expand_range "88.224.0.1" "88.224.0.100")
$(expand_range "95.0.0.1" "95.0.0.80")
$(expand_range "176.40.0.1" "176.40.0.70")
$(expand_range "185.15.0.1" "185.15.0.50")
$(expand_range "212.156.0.1" "212.156.0.50")
)

# ---------- UAE ----------
UAE_DNS=(
$(expand_range "2.49.0.1" "2.49.0.100")
$(expand_range "5.194.0.1" "5.194.0.80")
$(expand_range "94.200.0.1" "94.200.0.70")
$(expand_range "195.229.0.1" "195.229.0.50")
$(expand_range "217.165.0.1" "217.165.0.50")
)
# ---------- DNS Selection & Ping ----------

# Pick random DNS from an array
pick_random_dns() {
  local -n arr=$1
  local count=${#arr[@]}
  local idx1=$((RANDOM % count))
  local idx2=$((RANDOM % count))
  # Make sure Primary ≠ Secondary
  while [ $idx1 -eq $idx2 ]; do
    idx2=$((RANDOM % count))
  done
  echo "${arr[$idx1]} ${arr[$idx2]}"
}

# Measure ping (ms) for a DNS
measure_ping() {
  local dns=$1
  local ping_ms=$(ping -c 1 -W 1 $dns 2>/dev/null | grep 'time=' | awk -F'time=' '{print $2}' | awk '{print $1}')
  if [ -z "$ping_ms" ]; then
    echo "timeout"
  else
    echo "${ping_ms} ms"
  fi
}

# Serve DNS set: pick & show with ping
serve_dns_set() {
  local -n arr=$1
  local picked=($(pick_random_dns arr))
  local dns1=${picked[0]}
  local dns2=${picked[1]}
  local ping1=$(measure_ping $dns1)
  local ping2=$(measure_ping $dns2)

  echo "Primary DNS:   $dns1    → $ping1"
  echo "Secondary DNS: $dns2    → $ping2"
}
# ---------- GAMES LISTS ----------

MOBILE_GAMES=(
"PUBG Mobile"
"Call of Duty Mobile"
"Free Fire"
"Arena Breakout"
"Clash of Clans"
"Clash Royale"
"Brawl Stars"
"Mobile Legends"
"Genshin Impact"
"Among Us"
"Pokemon Go"
"Subway Surfers"
"Candy Crush Saga"
"Asphalt 9"
"Lords Mobile"
"AFK Arena"
"Roblox"
"Minecraft PE"
"Coin Master"
"Summoners War"
"Dragon Raja"
"League of Legends: Wild Rift"
"Apex Legends Mobile"
"Valorant Mobile"
"FIFA Mobile"
"NBA Live Mobile"
"Critical Ops"
"Modern Combat 5"
"World of Tanks Blitz"
"Shadow Fight 4"
"Sausage Man"
"Stumble Guys"
"Marvel Snap"
"CrossFire Mobile"
"Lost Light"
"War Robots"
"State of Survival"
"Boom Beach"
"Rise of Kingdoms"
"Top Eleven"
"Real Racing 3"
"Plants vs Zombies"
"Angry Birds 2"
"King of Avalon"
"Idle Heroes"
"Call of Antia"
"Dislyte"
"Echoes of Mana"
"One Punch Man"
"Naruto Online"
"Bleach Brave Souls"
"Dragon Ball Legends"
"Yu-Gi-Oh! Duel Links"
"Epic Seven"
"Arknights"
"Girls Frontline"
"Blue Archive"
"Tower of Fantasy"
"Honkai Impact 3"
"AFK Journey"
"Clash Mini"
"Clash Quest"
"Boom Beach Frontlines"
"Hero Wars"
"Injustice 2 Mobile"
"Mortal Kombat Mobile"
"Shadowgun Legends"
"Fortnite Mobile"
)

PC_GAMES=(
"Valorant"
"CS:GO"
"Dota 2"
"League of Legends"
"World of Warcraft"
"Overwatch"
"Call of Duty Warzone"
"Apex Legends"
"Fortnite"
"PUBG PC"
"Battlefield 2042"
"Rainbow Six Siege"
"FIFA 23"
"eFootball"
"Rocket League"
"Starcraft 2"
"Warcraft III"
"Lost Ark"
"Escape from Tarkov"
"GTA Online"
"Red Dead Online"
"Minecraft Java"
"Roblox PC"
"Fall Guys"
"Destiny 2"
"Final Fantasy XIV"
"Black Desert Online"
"Albion Online"
"Runescape"
"Path of Exile"
"Warframe"
"Paladins"
"Smite"
"World of Tanks"
"World of Warships"
"Crossfire PC"
"Point Blank"
"Left 4 Dead 2"
"Team Fortress 2"
"Half-Life 2 DM"
"Rust"
"Ark Survival"
"DayZ"
"H1Z1"
"The Division 2"
"Monster Hunter World"
"Diablo 4"
"Cyberpunk Online"
"Elder Scrolls Online"
"Guild Wars 2"
"Star Wars TOR"
"Planetside 2"
"Second Life"
"MapleStory"
"TERA Online"
"Neverwinter"
"Vindictus"
"Blade and Soul"
"Phantasy Star Online 2"
"Gran Saga PC"
"Blue Protocol"
"Tower of Fantasy PC"
"Lost Light PC"
"Crossout"
"Enlisted"
"War Thunder"
"World War 3"
)

CONSOLE_GAMES=(
"FIFA 23 Console"
"eFootball Console"
"Call of Duty MWII"
"Call of Duty Cold War"
"Call of Duty Warzone Console"
"Battlefield V Console"
"Battlefield 2042 Console"
"PUBG Console"
"Apex Legends Console"
"Fortnite Console"
"Rainbow Six Siege Console"
"GTA V Online Console"
"Red Dead Redemption 2 Console"
"Mortal Kombat 11"
"Street Fighter V"
"Tekken 7"
"Injustice 2 Console"
"NBA 2K23"
"MLB The Show"
"NHL 23"
"Madden NFL"
"WWE 2K23"
"Forza Horizon 5"
"Forza Motorsport 7"
"Gran Turismo 7"
"Need for Speed Heat"
"Crash Team Racing"
"Rocket League Console"
"Overwatch Console"
"Valorant Console"
"Destiny 2 Console"
"Division 2 Console"
"Diablo 4 Console"
"Elder Scrolls Online Console"
"Fall Guys Console"
"Minecraft Console"
"Roblox Console"
"Among Us Console"
"Phantasy Star Online Console"
"Lost Ark Console"
"Black Desert Console"
"Final Fantasy XIV Console"
"Monster Hunter World Console"
"Cyberpunk 2077 Console"
"Tomb Raider Online"
"Resident Evil Re:Verse"
"Outriders"
"CrossfireX"
"War Thunder Console"
"Enlisted Console"
"World of Tanks Console"
"World of Warships Console"
)
# ---------- GAME MENUS ----------

menu_mobile() {
  while true; do
    clear; title
    echo "=== Mobile Games DNS Menu ==="
    local i=1
    for g in "${MOBILE_GAMES[@]}"; do
      printf "%2d) %s\n" "$i" "$g"
      ((i++))
    done
    echo " 0) Back"
    read -rp "Pick a game: " choice
    if [[ $choice -eq 0 ]]; then return; fi
    if (( choice>=1 && choice<=${#MOBILE_GAMES[@]} )); then
      echo "Game: ${MOBILE_GAMES[$choice-1]}"
      # Use random DNS from one of the country banks
      case $((RANDOM % 4)) in
        0) serve_dns_set IRAN_DNS ;;
        1) serve_dns_set SAUDI_DNS ;;
        2) serve_dns_set TURKEY_DNS ;;
        3) serve_dns_set UAE_DNS ;;
      esac
      print_footer; pause_enter
    else
      echo "Invalid choice"; pause_enter
    fi
  done
}

menu_pc() {
  while true; do
    clear; title
    echo "=== PC Games DNS Menu ==="
    local i=1
    for g in "${PC_GAMES[@]}"; do
      printf "%2d) %s\n" "$i" "$g"
      ((i++))
    done
    echo " 0) Back"
    read -rp "Pick a game: " choice
    if [[ $choice -eq 0 ]]; then return; fi
    if (( choice>=1 && choice<=${#PC_GAMES[@]} )); then
      echo "Game: ${PC_GAMES[$choice-1]}"
      case $((RANDOM % 4)) in
        0) serve_dns_set IRAN_DNS ;;
        1) serve_dns_set SAUDI_DNS ;;
        2) serve_dns_set TURKEY_DNS ;;
        3) serve_dns_set UAE_DNS ;;
      esac
      print_footer; pause_enter
    else
      echo "Invalid choice"; pause_enter
    fi
  done
}

menu_console() {
  while true; do
    clear; title
    echo "=== Console Games DNS Menu ==="
    local i=1
    for g in "${CONSOLE_GAMES[@]}"; do
      printf "%2d) %s\n" "$i" "$g"
      ((i++))
    done
    echo " 0) Back"
    read -rp "Pick a game: " choice
    if [[ $choice -eq 0 ]]; then return; fi
    if (( choice>=1 && choice<=${#CONSOLE_GAMES[@]} )); then
      echo "Game: ${CONSOLE_GAMES[$choice-1]}"
      case $((RANDOM % 4)) in
        0) serve_dns_set IRAN_DNS ;;
        1) serve_dns_set SAUDI_DNS ;;
        2) serve_dns_set TURKEY_DNS ;;
        3) serve_dns_set UAE_DNS ;;
      esac
      print_footer; pause_enter
    else
      echo "Invalid choice"; pause_enter
    fi
  done
}
# ---------- GENERATE DNS SECTION ----------

generate_ipv4() {
  local country=$1
  local count=$2
  case $country in
    "Iran") base="5.160" ;;
    "Saudi Arabia") base="85.194" ;;
    "Turkey") base="88.224" ;;
    "UAE") base="94.200" ;;
    *) base="8.8" ;;
  esac
  for ((i=1;i<=count;i++)); do
    a=$((RANDOM % 256))
    b=$((RANDOM % 256))
    echo "$base.$a.$b"
  done
}

generate_ipv6() {
  local country=$1
  local count=$2
  case $country in
    "Iran") prefix="2a0a:2b40" ;;
    "Saudi Arabia") prefix="2a02:ed00" ;;
    "Turkey") prefix="2a02:ff80" ;;
    "UAE") prefix="2a01:4840" ;;
    *) prefix="2001:4860" ;;
  esac
  for ((i=1;i<=count;i++)); do
    seg1=$(printf "%x" $((RANDOM%65535)))
    seg2=$(printf "%x" $((RANDOM%65535)))
    seg3=$(printf "%x" $((RANDOM%65535)))
    seg4=$(printf "%x" $((RANDOM%65535)))
    echo "$prefix::$seg1:$seg2:$seg3:$seg4"
  done
}

menu_generate_dns() {
  while true; do
    clear; title
    echo "=== DNS Generator ==="
    echo "1) Iran"
    echo "2) Saudi Arabia"
    echo "3) Turkey"
    echo "4) UAE"
    echo "0) Back"
    read -rp "Select country: " c
    case $c in
      0) return ;;
      1) country="Iran" ;;
      2) country="Saudi Arabia" ;;
      3) country="Turkey" ;;
      4) country="UAE" ;;
      *) echo "Invalid"; pause_enter; continue ;;
    esac

    echo "1) IPv4"
    echo "2) IPv6"
    read -rp "Select type: " t
    [[ $t == "1" ]] && type="IPv4" || type="IPv6"

    read -rp "How many DNS addresses? " num
    echo "Generating $num $type DNS for $country..."
    if [[ $t == "1" ]]; then
      generate_ipv4 "$country" "$num"
    else
      generate_ipv6 "$country" "$num"
    fi
    print_footer; pause_enter
  done
}
# ---------- MAIN MENU ----------

main_menu() {
  while true; do
    clear; title
    echo "=== Main Menu ==="
    echo "1) Mobile Games DNS"
    echo "2) PC Games DNS"
    echo "3) Console Games DNS"
    echo "4) Generate DNS"
    echo "0) Exit"
    read -rp "Choose: " opt
    case $opt in
      1) menu_mobile ;;
      2) menu_pc ;;
      3) menu_console ;;
      4) menu_generate_dns ;;
      0) echo "Goodbye!"; exit 0 ;;
      *) echo "Invalid choice"; pause_enter ;;
    esac
  done
}

# ---------- START SCRIPT ----------
main_menu
