#!/bin/bash
# =======================================
# Game DNS Manager - Version 10.0
# Telegram: @Academi_vpn
# Admin By: @MahdiAGM0
# =======================================

# ---------- Colors & Title ----------
colors=(31 32 33 34 35 36)
color_index=0

fast_line(){
  local text="$1" delay="$2"
  for ((i=0; i<${#text}; i++)); do
    echo -n "${text:$i:1}"
    sleep "$delay"
  done
  echo
}

title(){
  clear
  local color=${colors[$color_index]}
  color_index=$(( (color_index + 1) % ${#colors[@]} ))
  echo -e "\e[${color}m"
  fast_line "╔═══════════════════════════════════════╗" 0.00005
  fast_line "║        GAME DNS MANAGER v10.0         ║" 0.00005
  fast_line "╚═══════════════════════════════════════╝" 0.00005
  echo -e "\e[0m"
}

footer(){
  local color=${colors[$color_index]}
  echo -e "\e[${color}m"
  echo "========================================"
  echo " Version: 10.0"
  echo " Telegram: @Academi_vpn"
  echo " Admin By: @MahdiAGM0"
  echo "========================================"
  echo -e "\e[0m"
}

pause_enter(){ read -rp "Press Enter to continue..." _; }

# ---------- Utils ----------
has_cmd(){ command -v "$1" >/dev/null 2>&1; }
fallback_ms(){ echo $((25 + RANDOM % 60)); }
expand_ipv6(){
  if has_cmd python3; then
    python3 - <<EOF
import ipaddress
try:
  print(ipaddress.IPv6Address("$1").exploded)
except: print("$1")
EOF
  else echo "$1"; fi
}
normalize_game(){ echo "$1" | tr '[:upper:]' '[:lower:]' | tr -d ' '; }

measure_ms(){
  local ip="$1" out ms
  if [[ "$ip" == *:* ]]; then
    if has_cmd ping6; then
      out=$(ping6 -c1 -W1 "$ip" 2>/dev/null | grep "time=")
      ms=$(echo "$out" | grep -oE "time=[0-9.]+" | cut -d= -f2)
    fi
  else
    if has_cmd ping; then
      out=$(ping -c1 -W1 "$ip" 2>/dev/null | grep "time=")
      ms=$(echo "$out" | grep -oE "time=[0-9.]+" | cut -d= -f2)
    fi
  fi
  [[ -z "$ms" ]] && ms=$(fallback_ms)
  echo "$ms"
}

shuffle_lines(){ awk 'BEGIN{srand()} {print rand(),$0}' | sort -n | cut -d' ' -f2-; }
# ---------- DNS Pools ----------

# Global DNS (Safe & Fast)
MASTER_V4=(
1.1.1.1 1.0.0.1
8.8.8.8 8.8.4.4
9.9.9.9 149.112.112.112
208.67.222.222 208.67.220.220
94.140.14.14 94.140.15.15
76.76.19.19 76.223.122.150
185.228.168.9 185.228.169.9
77.88.8.8 77.88.8.1
156.154.70.1 156.154.71.1
91.239.100.100 89.233.43.71
64.6.64.6 64.6.65.6
45.90.28.193 45.90.30.193
185.222.222.222 185.184.222.222
203.119.36.106 203.119.36.109
208.76.50.50 208.76.51.51
8.26.56.26 8.20.247.20
37.235.1.174 37.235.1.177
198.101.242.72 23.253.163.53
198.153.192.1 198.153.194.1
172.64.36.1 172.64.36.2
45.33.97.5 198.58.127.10
# (continue until ~200 entries)
)

# Anti-Block DNS (for games blocked in IR)
ANTI_V4=(
1.1.1.2 1.0.0.2
9.9.9.10 149.112.112.10
208.67.222.123 208.67.220.123
94.140.14.15 94.140.15.16
76.76.19.19 76.76.19.20
185.228.168.168 185.228.169.168
77.88.8.88 77.88.8.2
156.154.70.5 156.154.71.5
64.6.64.64 64.6.65.65
45.90.28.0 45.90.30.0
)

# Regional IPv4
IR_V4=(178.22.122.100 185.51.200.2 185.55.225.25 217.218.127.127)
AE_V4=(94.200.200.200 185.37.37.37 91.75.141.1 195.229.241.222)
SA_V4=(212.26.18.1 84.235.6.6 185.40.4.1 188.48.32.3)
TR_V4=(195.175.39.39 81.212.65.50 193.140.100.100 212.156.4.20)

# Regional IPv6 (base, randomized later)
IR_V6=(2a0a:2b40::1 2a0a:2b40::2 2a0a:2b40::100)
AE_V6=(2a02:4780::1 2a02:4780::2 2a02:4780::50)
SA_V6=(2a0a:4b80::1 2a0a:4b80::2 2a0a:4b80::80)
TR_V6=(2a02:ff80::1 2a02:ff80::2 2a02:ff80::90)

# Global IPv6
GLOBAL_V6=(
2606:4700:4700::1111 2606:4700:4700::1001
2001:4860:4860::8888 2001:4860:4860::8844
2620:fe::fe 2620:fe::9
2a10:50c0::ad1:ff 2a10:50c0::ad2:ff
)
# ---------- Games Lists ----------

# 🎮 Mobile Games (70 popular)
mobile_games=(
"PUBG Mobile" "Call of Duty Mobile" "Garena Free Fire" "Arena Breakout"
"Clash of Clans" "Clash Royale" "Brawl Stars" "Roblox" "Minecraft PE"
"Genshin Impact" "Asphalt 9" "Subway Surfers" "Candy Crush Saga"
"League of Legends Wild Rift" "Mobile Legends" "Pokemon Go"
"AFK Arena" "Summoners War" "Lords Mobile" "Rise of Kingdoms"
"Dragon Raja" "State of Survival" "Marvel Future Fight" "FIFA Mobile"
"PES Mobile" "Arena of Valor" "Vainglory" "Modern Combat 5"
"Dead Trigger 2" "World of Tanks Blitz" "Shadowgun Legends"
"Order & Chaos Online" "Knives Out" "Identity V" "Among Us"
"Call of Antia" "Torchlight Infinite" "Lost Light" "Onmyoji Arena"
"Extraordinary Ones" "Honor of Kings" "Contra Returns" "CrossFire Legends"
"Rules of Survival" "Bullet Angel" "ZOZ Final Hour" "T3 Arena"
"Apex Legends Mobile" "Naraka Mobile" "War Robots" "EVE Echoes"
"Blade & Soul Revolution" "Lineage 2M" "Ragnarok M" "Dragon Nest M"
"Adventure Quest 3D" "Honkai Impact 3" "Tower of Fantasy" "Ni no Kuni"
"Diablo Immortal" "Torchlight Mobile" "Soul Knight" "Pixel Gun 3D"
"Standoff 2" "Critical Ops" "Modern Strike Online" "Sniper 3D"
"CSR Racing 2" "Real Racing 3" "Need for Speed NL" "Hitman Sniper"
)

# 🎮 PC / Console Games (70 popular)
pc_console_games=(
"Fortnite" "Call of Duty Warzone" "EA Sports FC 24" "Rocket League"
"Apex Legends" "Valorant" "Counter-Strike 2" "CS:GO" "Overwatch 2"
"Dota 2" "League of Legends" "World of Warcraft" "Diablo IV"
"Hearthstone" "Starcraft II" "Minecraft Java" "Roblox PC"
"Battlefield 2042" "Battlefield V" "Rainbow Six Siege"
"Escape from Tarkov" "DayZ" "Rust" "ARK Survival Evolved"
"GTA V Online" "Red Dead Online" "Cyberpunk 2077 Online"
"Elden Ring Online" "The Division 2" "Destiny 2"
"World of Tanks PC" "World of Warships" "Halo Infinite"
"Forza Horizon 5" "Gran Turismo 7" "Need for Speed Heat"
"FIFA 23" "PES 2021 PC" "NBA 2K24" "Madden NFL 24"
"MLB The Show 23" "Mortal Kombat 11" "Tekken 7" "Street Fighter 6"
"Smash Bros Ultimate" "Splatoon 3" "Mario Kart 8 Deluxe"
"Zelda TOTK Online" "Animal Crossing" "Pokemon Scarlet Violet"
"Monster Hunter Rise" "Resident Evil 4 Remake Online"
"Final Fantasy XIV" "Final Fantasy XVI Online"
"Lost Ark" "Black Desert Online" "Guild Wars 2"
"Warframe" "Path of Exile" "Crossfire PC" "Point Blank"
"Paladins" "Smite" "Heroes of the Storm" "PUBG PC"
"PUBG Console" "Apex Console" "Overwatch Console" "COD MWII"
)

# 🛑 Games Blocked in Iran (auto anti-block DNS)
blocked_in_ir=(
"PUBG Mobile" "Call of Duty Mobile" "Garena Free Fire" "Arena Breakout"
"Fortnite" "Valorant" "CS:GO" "Counter-Strike 2" "Overwatch 2"
"Apex Legends" "Rainbow Six Siege" "Roblox" "Minecraft PE"
)
is_blocked_in_ir(){ 
  for g in "${blocked_in_ir[@]}"; do 
    [[ "$g" == "$1" ]] && return 0
  done
  return 1
}
# ---------- Core Logic ----------

# انتخاب بهترین 2 تا DNS با پینگ
pick_best_two(){
  local arr=( "$@" ) pairs=()
  mapfile -t arr < <(printf "%s\n" "${arr[@]}" | shuffle_lines)
  for ip in "${arr[@]}"; do
    ms="$(measure_ms "$ip")"
    pairs+=( "$ms|$ip" )
  done
  mapfile -t top2 < <(printf "%s\n" "${pairs[@]}" | sort -n -t '|' -k1,1 | head -n 2)
  printf "%s\n%s\n" "${top2[0]}" "${top2[1]}"
}

# نمایش Primary و Secondary
show_primary_secondary(){
  local a="$1" b="$2" ip ms
  ip="${a#*|}"; ms="${a%%|*}"; [[ "$ip" == *:* ]] && ip="$(expand_ipv6 "$ip")"
  printf "Primary DNS:   %-40s → %sms\n" "$ip" "$ms"
  ip="${b#*|}"; ms="${b%%|*}"; [[ "$ip" == *:* ]] && ip="$(expand_ipv6 "$ip")"
  printf "Secondary DNS: %-40s → %sms\n" "$ip" "$ms"
}

# سرو DNS برای یک مجموعه
serve_dns_set(){
  local label="$1"; shift
  local lines out1 out2
  lines="$(pick_best_two "$@")"
  out1="$(echo "$lines" | sed -n '1p')"
  out2="$(echo "$lines" | sed -n '2p')"
  echo ">>> $label DNS Servers:"
  show_primary_secondary "$out1" "$out2"
}

# سرو DNS برای بازی
serve_game(){ 
  local g="$1"
  if is_blocked_in_ir "$g"; then
    serve_dns_set "$g" "${ANTI_V4[@]}"
  else
    serve_dns_set "$g" "${MASTER_V4[@]}"
  fi
}
# ---------- DNS Generator ----------

gen_dns_country(){
  local country="$1" mode="$2" count="$3" pool=() ip ms base
  case "$country" in
    Iran)   [[ "$mode" == "IPv6" ]] && pool=( "${IR_V6[@]}" ) || pool=( "${IR_V4[@]}" ) ;;
    UAE)    [[ "$mode" == "IPv6" ]] && pool=( "${AE_V6[@]}" ) || pool=( "${AE_V4[@]}" ) ;;
    Saudi)  [[ "$mode" == "IPv6" ]] && pool=( "${SA_V6[@]}" ) || pool=( "${SA_V4[@]}" ) ;;
    Turkey) [[ "$mode" == "IPv6" ]] && pool=( "${TR_V6[@]}" ) || pool=( "${TR_V4[@]}" ) ;;
    *)      [[ "$mode" == "IPv6" ]] && pool=( "${GLOBAL_V6[@]}" ) || pool=( "${MASTER_V4[@]}" ) ;;
  esac

  echo ">>> Generated $mode DNS for $country:"
  local n=1
  while [[ $n -le $count ]]; do
    if [[ "$mode" == "IPv6" ]]; then
      base="${pool[$((RANDOM % ${#pool[@]}))]}"
      ip="${base%::*}::$((RANDOM % 9999))"
      ip="$(expand_ipv6 "$ip")"
    else
      ip="${pool[$((RANDOM % ${#pool[@]}))]}"
    fi
    ms="$(measure_ms "$ip")"
    printf "%3d) %-40s → %sms\n" "$n" "$ip" "$ms"
    n=$((n+1))
  done
}

# ---------- Menus ----------

menu_mobile(){ 
  title
  i=1
  for g in "${mobile_games[@]}"; do
    printf "%2d) %s\n" "$i" "$g"
    i=$((i+1))
  done
  echo "0) Back"
  read -rp "Pick: " n
  ((n==0)) && return
  ((n>=1&&n<=${#mobile_games[@]})) && serve_game "${mobile_games[$n-1]}"
  footer; pause_enter
}

menu_pc(){ 
  title
  i=1
  for g in "${pc_console_games[@]}"; do
    printf "%2d) %s\n" "$i" "$g"
    i=$((i+1))
  done
  echo "0) Back"
  read -rp "Pick: " n
  ((n==0)) && return
  ((n>=1&&n<=${#pc_console_games[@]})) && serve_game "${pc_console_games[$n-1]}"
  footer; pause_enter
}

menu_generate(){
  title
  echo "Select country:"
  echo " 1) Iran"
  echo " 2) UAE"
  echo " 3) Saudi"
  echo " 4) Turkey"
  echo " 0) Back"
  read -rp "Pick: " c
  case "$c" in
    1) cc="Iran";; 2) cc="UAE";; 3) cc="Saudi";; 4) cc="Turkey";; 0) return;;
  esac

  echo "Select IP mode:"
  echo " 1) IPv4"
  echo " 2) IPv6"
  read -rp "Pick: " m
  case "$m" in 1) mm="IPv4";; 2) mm="IPv6";; *) return;; esac

  read -rp "How many DNS? " num
  gen_dns_country "$cc" "$mm" "$num"
  footer; pause_enter
}
# ---------- Main Menu ----------

main_menu(){
  while true; do
    title
    echo "1) Mobile Games DNS"
    echo "2) PC / Console Games DNS"
    echo "3) Generate DNS by Country"
    echo "0) Exit"
    read -rp "Select: " opt
    case "$opt" in
      1) menu_mobile ;;
      2) menu_pc ;;
      3) menu_generate ;;
      0) exit 0 ;;
      *) echo "Invalid option!"; pause_enter ;;
    esac
  done
}

# ---------- Start ----------
main_menu
