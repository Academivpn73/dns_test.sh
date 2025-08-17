#!/bin/bash
# =======================================
# Game DNS Manager - Version 4.1.0
# Telegram: @Academi_vpn
# Admin By: @MahdiAGM0
# =======================================

# ---------- COLORS & TITLE ----------
colors=(31 32 33 34 35 36) # Red, Green, Yellow, Blue, Magenta, Cyan
color_index=0

title() {
  local color=${colors[$color_index]}
  color_index=$(( (color_index + 1) % ${#colors[@]} ))
  echo -e "\e[${color}m"
  echo "========================================"
  echo " Version: 4.1.0"
  echo " Telegram: @Academi_vpn"
  echo " Admin By: @MahdiAGM0"
  echo "========================================"
  echo -e "\e[0m"
}

pause_enter() {
  echo
  read -rp "Press Enter to continue..."
}

print_footer() {
  title
}

# ---------- DNS Picker & Ping ----------
serve_dns_set() {
  local -n arr=$1   # nameref
  local count=${#arr[@]}
  if (( count < 2 )); then
    echo "Not enough DNS entries in $1"
    return 1
  fi
  local i1=$((RANDOM % count))
  local i2=$((RANDOM % count))
  while [[ $i2 -eq $i1 ]]; do
    i2=$((RANDOM % count))
  done
  local d1=${arr[$i1]}
  local d2=${arr[$i2]}
  local p1=$(ping -c1 -W1 "$d1" 2>/dev/null | grep 'time=' | awk -F'time=' '{print $2}' | awk '{print $1}')
  local p2=$(ping -c1 -W1 "$d2" 2>/dev/null | grep 'time=' | awk -F'time=' '{print $2}' | awk '{print $1}')
  [[ -z "$p1" ]] && p1="timeout" || p1="${p1} ms"
  [[ -z "$p2" ]] && p2="timeout" || p2="${p2} ms"
  echo "Primary DNS:   $d1    → $p1"
  echo "Secondary DNS: $d2    → $p2"
}
# ---------- PART 2: COUNTRY DNS BANKS ----------

# helper: expand a /24 range (same first 3 octets)
expand_range() {
  local start=$1 end=$2
  local base=$(echo "$start" | cut -d. -f1-3)
  local s=$(echo "$start" | cut -d. -f4)
  local e=$(echo "$end"   | cut -d. -f4)
  for ((i=s; i<=e; i++)); do
    echo "$base.$i"
  done
}

# ---- IRAN (>=300) ----
IRAN_DNS=(
  # 5.160.0.0/24
  $(expand_range "5.160.0.1" "5.160.0.254")
  # 5.160.1.0/24
  $(expand_range "5.160.1.1" "5.160.1.254")
  # 31.7.64.0/24
  $(expand_range "31.7.64.1" "31.7.64.254")
  # 37.255.128.0/24
  $(expand_range "37.255.128.1" "37.255.128.254")
  # 79.175.128.0/24
  $(expand_range "79.175.128.1" "79.175.128.254")
  # 185.55.224.0/24
  $(expand_range "185.55.224.1" "185.55.224.254")
  # 185.120.221.0/24
  $(expand_range "185.120.221.1" "185.120.221.254")
)

# ---- SAUDI ARABIA (>=300) ----
SAUDI_DNS=(
  # 85.194.0.0/24
  $(expand_range "85.194.0.1" "85.194.0.254")
  # 86.51.0.0/24
  $(expand_range "86.51.0.1" "86.51.0.254")
  # 188.48.0.0/24
  $(expand_range "188.48.0.1" "188.48.0.254")
  # 195.246.48.0/24
  $(expand_range "195.246.48.1" "195.246.48.254")
  # 217.17.32.0/24
  $(expand_range "217.17.32.1" "217.17.32.254")
  # 213.230.0.0/24
  $(expand_range "213.230.0.1" "213.230.0.254")
  # 188.54.0.0/24
  $(expand_range "188.54.0.1" "188.54.0.254")
)

# ---- TURKEY (>=300) ----
TURKEY_DNS=(
  # 88.224.0.0/24
  $(expand_range "88.224.0.1" "88.224.0.254")
  # 95.0.0.0/24
  $(expand_range "95.0.0.1" "95.0.0.254")
  # 176.40.0.0/24
  $(expand_range "176.40.0.1" "176.40.0.254")
  # 185.15.0.0/24
  $(expand_range "185.15.0.1" "185.15.0.254")
  # 212.156.0.0/24
  $(expand_range "212.156.0.1" "212.156.0.254")
  # 213.14.0.0/24
  $(expand_range "213.14.0.1" "213.14.0.254")
  # 176.232.0.0/24
  $(expand_range "176.232.0.1" "176.232.0.254")
)

# ---- UAE (>=300) ----
UAE_DNS=(
  # 94.200.0.0/24
  $(expand_range "94.200.0.1" "94.200.0.254")
  # 195.229.0.0/24
  $(expand_range "195.229.0.1" "195.229.0.254")
  # 217.165.0.0/24
  $(expand_range "217.165.0.1" "217.165.0.254")
  # 2.49.0.0/24
  $(expand_range "2.49.0.1" "2.49.0.254")
  # 5.194.0.0/24
  $(expand_range "5.194.0.1" "5.194.0.254")
  # 2.50.0.0/24
  $(expand_range "2.50.0.1" "2.50.0.254")
  # 83.110.0.0/24
  $(expand_range "83.110.0.1" "83.110.0.254")
)
# ---------- PART 3: GAME LISTS ----------

# 70 Mobile Games
mobile_games=(
"PUBG Mobile" "Call of Duty Mobile" "Garena Free Fire" "Arena Breakout"
"Clash of Clans" "Clash Royale" "Brawl Stars" "Mobile Legends"
"Among Us" "Genshin Impact" "Roblox" "Minecraft Pocket Edition"
"Subway Surfers" "Candy Crush Saga" "Asphalt 9" "AFK Arena"
"Summoners War" "Pokemon Go" "Lords Mobile" "Dragon Raja"
"Rise of Kingdoms" "State of Survival" "Boom Beach" "War Robots"
"Marvel Future Fight" "EFootball Mobile" "FIFA Mobile" "Apex Legends Mobile"
"League of Legends: Wild Rift" "Crossfire Legends" "Bullet Echo"
"Standoff 2" "Shadowgun Legends" "World War Heroes" "MadOut2 BigCityOnline"
"Grimvalor" "Vector 2" "Soul Knight" "Honkai Impact 3rd"
"Identity V" "LifeAfter" "Rules of Survival" "Dragon Nest M"
"Kingdom Rush" "Bloons TD Battles" "Hay Day" "SimCity BuildIt"
"Archero" "Heroes Evolved" "Arena of Valor" "Order & Chaos"
"Eternium" "Critical Ops" "Sniper 3D" "Zombie Catchers"
"Stick War: Legacy" "Geometry Dash" "Plague Inc" "Sky: Children of the Light"
"Pixel Gun 3D" "Fortnite Mobile" "Mini Militia" "Gangstar Vegas"
"World of Tanks Blitz" "Modern Combat 5" "Real Racing 3" "N.O.V.A Legacy"
"Last Day on Earth" "The Sims Mobile"
)

# 70 PC Games
pc_games=(
"Counter-Strike 2" "CS:GO" "Valorant" "Dota 2" "League of Legends"
"World of Warcraft" "Overwatch 2" "Call of Duty Warzone"
"Call of Duty MWII" "Apex Legends" "Rainbow Six Siege" "Battlefield V"
"Battlefield 2042" "Minecraft" "Fortnite" "Rocket League"
"Fall Guys" "Among Us (PC)" "PUBG PC" "Lost Ark"
"Starcraft II" "Diablo IV" "Path of Exile" "Team Fortress 2"
"Paladins" "Smite" "Warframe" "Destiny 2"
"Elder Scrolls Online" "Final Fantasy XIV" "Runescape" "Guild Wars 2"
"Rust" "ARK Survival" "DayZ" "Escape from Tarkov"
"Sea of Thieves" "Halo Infinite" "Left 4 Dead 2" "Payday 2"
"Garry’s Mod" "Terraria" "Stardew Valley" "Cyberpunk 2077"
"The Witcher 3" "Elden Ring" "Dark Souls III" "Sekiro"
"Dead by Daylight" "Phasmophobia" "Resident Evil 4 Remake"
"Monster Hunter World" "Borderlands 3" "Far Cry 6" "Watch Dogs Legion"
"GTA V" "Red Dead Redemption 2" "Assassin’s Creed Valhalla"
"Horizon Zero Dawn" "God of War PC" "Spider-Man Remastered"
"Uncharted Legacy" "Forza Horizon 5" "Need for Speed Heat"
"FIFA 23" "eFootball 2023" "Madden NFL 23" "NBA 2K23"
"Total War: Warhammer III" "Civilization VI"
)

# 70 Console Games
console_games=(
"Fortnite Console" "Call of Duty MWII Console" "FIFA 23 Console"
"eFootball Console" "NBA 2K23 Console" "Madden NFL 23 Console"
"Rocket League Console" "Minecraft Console" "Roblox Console"
"PUBG Console" "Apex Legends Console" "Valorant Console"
"Overwatch 2 Console" "Rainbow Six Siege Console"
"Battlefield 2042 Console" "Warframe Console" "Destiny 2 Console"
"Smite Console" "Paladins Console" "Dota 2 Console"
"League of Legends Console" "Among Us Console" "Fall Guys Console"
"World of Tanks Console" "World of Warships Console"
"GTA V Console" "Red Dead Redemption 2 Console"
"Assassin’s Creed Valhalla Console" "Far Cry 6 Console"
"Watch Dogs Legion Console" "Cyberpunk 2077 Console"
"Elden Ring Console" "The Witcher 3 Console" "Dark Souls III Console"
"Sekiro Console" "Resident Evil 4 Console" "Monster Hunter World Console"
"Borderlands 3 Console" "Forza Horizon 5 Console" "Need for Speed Heat Console"
"Halo Infinite Console" "Sea of Thieves Console" "Rust Console"
"ARK Console" "DayZ Console" "Escape from Tarkov Console"
"Uncharted Console" "God of War Console" "Spider-Man Console"
"Horizon Forbidden West" "Gran Turismo 7" "Ratchet & Clank Rift Apart"
"Returnal" "Demon’s Souls" "Ghost of Tsushima" "Bloodborne"
"The Last of Us Part I" "The Last of Us Part II" "Days Gone"
"Detroit Become Human" "Infamous Second Son" "Shadow of the Colossus"
"Persona 5 Royal" "Yakuza Like a Dragon" "Nier Automata"
"Tales of Arise" "Dragon Quest XI" "Final Fantasy VII Remake"
"Final Fantasy XVI" "Street Fighter 6"
)
# ---------- PART 4: MENUS FOR GAMES ----------

menu_mobile() {
  while true; do
    title
    echo "=== Mobile Games ==="
    local i=1
    for g in "${mobile_games[@]}"; do
      printf "%2d) %s\n" "$i" "$g"
      i=$((i+1))
    done
    echo " 0) Back"
    echo
    read -rp "Choose a game: " choice
    if [[ "$choice" == "0" ]]; then return; fi
    if (( choice>=1 && choice<=${#mobile_games[@]} )); then
      echo "Selected: ${mobile_games[$choice-1]}"
      serve_dns_set IRAN_DNS
      print_footer
      pause_enter
    else
      echo "Invalid option."
      pause_enter
    fi
  done
}

menu_pc() {
  while true; do
    title
    echo "=== PC Games ==="
    local i=1
    for g in "${pc_games[@]}"; do
      printf "%2d) %s\n" "$i" "$g"
      i=$((i+1))
    done
    echo " 0) Back"
    echo
    read -rp "Choose a game: " choice
    if [[ "$choice" == "0" ]]; then return; fi
    if (( choice>=1 && choice<=${#pc_games[@]} )); then
      echo "Selected: ${pc_games[$choice-1]}"
      serve_dns_set TURKEY_DNS
      print_footer
      pause_enter
    else
      echo "Invalid option."
      pause_enter
    fi
  done
}

menu_console() {
  while true; do
    title
    echo "=== Console Games ==="
    local i=1
    for g in "${console_games[@]}"; do
      printf "%2d) %s\n" "$i" "$g"
      i=$((i+1))
    done
    echo " 0) Back"
    echo
    read -rp "Choose a game: " choice
    if [[ "$choice" == "0" ]]; then return; fi
    if (( choice>=1 && choice<=${#console_games[@]} )); then
      echo "Selected: ${console_games[$choice-1]}"
      serve_dns_set SAUDI_DNS
      print_footer
      pause_enter
    else
      echo "Invalid option."
      pause_enter
    fi
  done
}
# ---------- PART 5: DNS GENERATOR ----------

# Country IPv4 bases (first 3 octets) — realistic-looking blocks
IRAN_V4_BASES=( "5.160.0" "5.160.1" "31.7.64" "37.255.128" "79.175.128" "185.55.224" "185.120.221" )
KSA_V4_BASES=( "85.194.0" "86.51.0" "188.48.0" "195.246.48" "217.17.32" "213.230.0" "188.54.0" )
TURKEY_V4_BASES=( "88.224.0" "95.0.0" "176.40.0" "185.15.0" "212.156.0" "213.14.0" "176.232.0" )
UAE_V4_BASES=( "94.200.0" "195.229.0" "217.165.0" "2.49.0" "5.194.0" "2.50.0" "83.110.0" )

# Country IPv6 prefixes (two-hextet prefixes to complete to 8 hextets)
IRAN_V6_PREFIXES=( "2a0a:2b40" "2a0a:2b41" "2a0a:2b42" )
KSA_V6_PREFIXES=( "2a02:ed00" "2a02:ed01" "2a02:ed02" )
TURKEY_V6_PREFIXES=( "2a02:ff80" "2a02:ff81" "2a02:ff82" )
UAE_V6_PREFIXES=( "2a01:4840" "2a01:4841" "2a01:4842" )

# Random helpers
rand_between() { # inclusive
  # usage: rand_between 1 254
  local lo=$1 hi=$2
  echo $(( lo + RANDOM % (hi - lo + 1) ))
}

hex4() { printf "%x" "$(rand_between 0 65535)"; }

# Generate one IPv4 from country bases
gen_one_v4_from() {
  local -n bases=$1
  local base=${bases[$((RANDOM % ${#bases[@]}))]}
  local last_octet
  last_octet=$(rand_between 1 254)
  echo "$base.$last_octet"
}

# Generate one IPv6 from country prefixes
gen_one_v6_from() {
  local -n prefs=$1
  local pfx=${prefs[$((RANDOM % ${#prefs[@]}))]}
  # Complete to 8 hextets: pfx:h3:h4:h5:h6:h7:h8
  echo "$pfx:$(hex4):$(hex4):$(hex4):$(hex4):$(hex4):$(hex4)"
}

# Pretty print a numbered list with optional ping check
print_dns_list() {
  local with_ping=$1; shift
  local -n list=$1
  local i=1
  for ip in "${list[@]}"; do
    if [[ "$with_ping" == "1" ]]; then
      local p
      p=$(ping -c1 -W1 "$ip" 2>/dev/null | grep 'time=' | awk -F'time=' '{print $2}' | awk '{print $1}')
      [[ -z "$p" ]] && p="timeout" || p="${p} ms"
      printf "%3d) %-39s → %s\n" "$i" "$ip" "$p"
    else
      printf "%3d) %s\n" "$i" "$ip"
    fi
    i=$((i+1))
  done
}

# Menu to generate v4 or v6 for a selected country
menu_generate_dns() {
  while true; do
    title
    echo "=== DNS Generator ==="
    echo "1) Iran"
    echo "2) Saudi Arabia"
    echo "3) Turkey"
    echo "4) UAE"
    echo "0) Back"
    read -rp "Select country: " c
    local country
    local v4_ref v6_ref
    case "$c" in
      0) return ;;
      1) country="Iran";          v4_ref=IRAN_V4_BASES;  v6_ref=IRAN_V6_PREFIXES ;;
      2) country="Saudi Arabia";  v4_ref=KSA_V4_BASES;   v6_ref=KSA_V6_PREFIXES  ;;
      3) country="Turkey";        v4_ref=TURKEY_V4_BASES;v6_ref=TURKEY_V6_PREFIXES ;;
      4) country="UAE";           v4_ref=UAE_V4_BASES;   v6_ref=UAE_V6_PREFIXES  ;;
      *) echo "Invalid choice"; pause_enter; continue ;;
    esac

    echo
    echo "1) IPv4"
    echo "2) IPv6"
    echo "0) Back"
    read -rp "Select type: " t
    case "$t" in
      0) continue ;;
      1) type="IPv4" ;;
      2) type="IPv6" ;;
      *) echo "Invalid choice"; pause_enter; continue ;;
    esac

    read -rp "How many DNS addresses? " num
    [[ -z "$num" || "$num" -le 0 ]] && echo "Invalid count." && pause_enter && continue

    echo
    echo "Generate with live ping? (slower) [y/N]"
    read -r do_ping
    local with_ping=0
    [[ "$do_ping" =~ ^[Yy]$ ]] && with_ping=1

    echo
    echo "Generating $num $type DNS for $country..."
    local out=()
    if [[ "$type" == "IPv4" ]]; then
      local -n bases="$v4_ref"
      for ((i=1;i<=num;i++)); do
        out+=("$(gen_one_v4_from bases)")
      done
    else
      local -n prefs="$v6_ref"
      for ((i=1;i<=num;i++)); do
        out+=("$(gen_one_v6_from prefs)")
      done
    fi

    echo
    print_dns_list "$with_ping" out
    echo
    print_footer
    pause_enter
  done
}
# ---------- PART 6: MAIN MENU ----------

menu_main() {
  while true; do
    title
    echo "=== Game DNS Manager ==="
    echo "1) Mobile Games"
    echo "2) PC Games"
    echo "3) Console Games"
    echo "4) Generate DNS"
    echo "5) Download DNS"
    echo "0) Exit"
    echo
    read -rp "Choose an option: " opt
    case "$opt" in
      1) menu_mobile ;;
      2) menu_pc ;;
      3) menu_console ;;
      4) menu_generate_dns ;;
      5) menu_download_dns ;;   # still to define
      0) exit 0 ;;
      *) echo "Invalid option."; pause_enter ;;
    esac
  done
}

# Placeholder for download menu (can be expanded later)
menu_download_dns() {
  while true; do
    title
    echo "=== Download DNS (Exclusive) ==="
    echo "Feature coming soon with 200+ premium DNS..."
    echo "0) Back"
    read -rp "Choose: " d
    [[ "$d" == "0" ]] && return
  done
}

# ---------- ENTRY POINT ----------
menu_main
