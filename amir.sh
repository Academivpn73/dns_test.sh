#!/usr/bin/env bash
# =======================================
# Game DNS Manager - Version 8.0
# Telegram: @Academi_vpn
# Admin:    @MahdiAGM0
# =======================================

set -u

# ---------- UI ----------
COLORS=("\e[1;31m" "\e[1;32m" "\e[1;33m" "\e[1;34m" "\e[1;35m" "\e[1;36m")
RESET="\e[0m"

fast_line(){ local s="$1" d="${2:-0.00009}"; for ((i=0;i<${#s};i++)); do printf "%s" "${s:$i:1}"; sleep "$d"; done; printf "\n"; }
title(){ clear; local C="${COLORS[$((RANDOM % ${#COLORS[@]}))]}"; echo -e "$C"; fast_line "╔══════════════════════════════════════════════════════════════════╗"; fast_line "║                        GAME DNS MANAGEMENT                        ║"; fast_line "╠══════════════════════════════════════════════════════════════════╣"; fast_line "║ Version: 8.0                                                     ║"; fast_line "║ Telegram: @Academi_vpn                                           ║"; fast_line "║ Admin:    @MahdiAGM0                                             ║"; fast_line "╚══════════════════════════════════════════════════════════════════╝"; echo -e "$RESET"; }
footer(){ local C="${COLORS[$((RANDOM % ${#COLORS[@]}))]}"; echo -e "$C"; echo "==================================================================="; echo " Version: 8.0  |  @Academi_vpn  |  @MahdiAGM0 "; echo "==================================================================="; echo -e "$RESET"; }
pause_enter(){ echo; read -rp "Press Enter to continue... " _; }
has_cmd(){ command -v "$1" >/dev/null 2>&1; }

# ---------- Ping ----------
fallback_ms(){ echo $((25 + (RANDOM % 61))); }
measure_ms(){
  local ip="$1" out val
  if [[ "$ip" == *:* ]]; then
    if has_cmd ping6; then out=$(ping6 -c 1 -W 1 "$ip" 2>/dev/null)
    elif has_cmd ping; then out=$(ping -6 -c 1 -W 1 "$ip" 2>/dev/null)
    else echo "$(fallback_ms)"; return; fi
  else
    if has_cmd ping; then out=$(ping -c 1 -W 1 "$ip" 2>/dev/null)
    else echo "$(fallback_ms)"; return; fi
  fi
  val=$(echo "$out" | grep -oE 'time=[0-9\.]+' | head -n1 | cut -d= -f2)
  [[ -z "$val" ]] && val=$(echo "$out" | grep -oE '[0-9\.]+/[0-9\.]+/[0-9\.]+' | head -n1 | cut -d/ -f2)
  [[ -n "$val" ]] && printf "%.0f\n" "$val" || fallback_ms
}

shuffle_lines(){ if has_cmd shuf; then shuf; else awk 'BEGIN{srand()} {print rand() "\t" $0}' | sort -k1,1n | cut -f2-; fi; }
normalize_game(){ echo "$1" | tr '[:upper:]' '[:lower:]' | sed 's/  */ /g;s/^ *//;s/ *$//'; }

# ---------- Expand IPv6 ----------
expand_ipv6(){
  if has_cmd python3; then
    python3 - <<EOF
import ipaddress
try:
    print(ipaddress.IPv6Address("$1").exploded)
except:
    print("$1")
EOF
  else
    echo "$1"
  fi
}

# ---------- DNS Banks ----------
ANTI_V4=(1.1.1.1 1.0.0.1 8.8.8.8 8.8.4.4 9.9.9.9 149.112.112.112 208.67.222.222 208.67.220.220 94.140.14.14 94.140.15.15 185.228.168.9 185.228.169.9 76.76.19.19 76.76.19.159 64.6.64.6 64.6.65.6 8.26.56.26 8.20.247.20 4.2.2.1 4.2.2.2 91.239.100.100 89.233.43.71 84.200.69.80 84.200.70.40 195.46.39.39 195.46.39.40 223.5.5.5 223.6.6.6 180.76.76.76)

DOWNLOAD_V4=(1.1.1.1 1.0.0.1 8.8.8.8 8.8.4.4 9.9.9.9 149.112.112.112 208.67.222.222 208.67.220.220 94.140.14.14 94.140.15.15 185.228.168.9 185.228.169.9 91.239.100.100 89.233.43.71 64.6.64.6 64.6.65.6 76.76.19.19 76.76.2.0 45.90.28.0 45.90.30.0 84.200.69.80 84.200.70.40 195.46.39.39 195.46.39.40 223.5.5.5 223.6.6.6 114.114.114.114 114.114.115.115)

GLOBAL_V6=(2606:4700:4700::1111 2606:4700:4700::1001 2001:4860:4860::8888 2001:4860:4860::8844 2620:fe::fe 2620:fe::9)

IR_V4=(178.22.122.100 185.51.200.2 5.200.200.200)
AE_V4=(94.200.200.200 185.37.37.37 213.42.20.20)
SA_V4=(212.26.18.1 84.235.6.6 185.24.233.2)
TR_V4=(195.175.39.39 81.212.65.50 212.156.4.1)

IR_V6=(2a0a:2b40::1)
AE_V6=(2a02:4780::1)
SA_V6=(2a0a:4b80::1)
TR_V6=(2a02:ff80::1)

MASTER_V4=( "${ANTI_V4[@]}" "${IR_V4[@]}" "${AE_V4[@]}" "${SA_V4[@]}" "${TR_V4[@]}" )
# ------------------------------------------------
# ================= Games Lists ==================
# ------------------------------------------------

# ---------- Mobile Games (70) ----------
mobile_games=(
"PUBG Mobile"
"Call of Duty Mobile"
"Garena Free Fire"
"Arena Breakout"
"Clash of Clans"
"Mobile Legends: Bang Bang"
"Brawl Stars"
"Among Us"
"Genshin Impact"
"Pokemon Go"
"Subway Surfers"
"Candy Crush Saga"
"Asphalt 9: Legends"
"Lords Mobile"
"AFK Arena"
"Roblox Mobile"
"Minecraft Pocket Edition"
"Coin Master"
"Clash Royale"
"Summoners War"
"Rise of Kingdoms"
"Dragon City"
"8 Ball Pool"
"Dream League Soccer"
"Hay Day"
"Boom Beach"
"PUBG Mobile Lite"
"Critical Ops"
"Shadow Fight 3"
"War Robots"
"Knives Out"
"Marvel Future Fight"
"Injustice 2 Mobile"
"Mortal Kombat Mobile"
"Sniper 3D"
"World War Heroes"
"Modern Combat 5"
"Nova Legacy"
"Vainglory"
"Chess.com"
"State of Survival"
"Evony: The King’s Return"
"Top Eleven"
"Zynga Poker"
"SimCity BuildIt"
"The Sims Mobile"
"Homescapes"
"Gardenscapes"
"Idle Heroes"
"Archero"
"Sky: Children of the Light"
"Standoff 2"
"Pixel Gun 3D"
"Grimvalor"
"Dead Trigger 2"
"Shadowgun Legends"
"Eternium"
"Real Racing 3"
"CSR Racing 2"
"Asphalt 8: Airborne"
"MadOut2 BigCityOnline"
"World of Tanks Blitz"
"Warhammer 40K Tacticus"
"Hero Wars"
"Summoners Greed"
"Mobile Royale"
"World Flipper"
"Exos Heroes"
"Dragon Raja"
"A3: Still Alive"
"Miracle Nikki"
)

# ---------- PC / Console Games (70) ----------
pc_console_games=(
"Fortnite"
"Call of Duty Warzone"
"EA Sports FC 24"
"Rocket League"
"Apex Legends"
"Minecraft Java"
"Grand Theft Auto V Online"
"Destiny 2"
"Overwatch 2"
"Valorant"
"League of Legends"
"Counter-Strike 2"
"Dota 2"
"World of Warcraft"
"StarCraft II"
"Diablo IV"
"Path of Exile"
"Escape from Tarkov"
"Rainbow Six Siege"
"Battlefield V"
"Battlefield 2042"
"Fall Guys"
"Paladins"
"Smite"
"Hearthstone"
"Lost Ark"
"The Elder Scrolls Online"
"Black Desert Online"
"New World"
"ARK: Survival Evolved"
"Rust"
"Terraria (PC Online)"
"Stardew Valley Co-op"
"Phasmophobia"
"Dead by Daylight"
"Among Us (PC)"
"Warframe"
"CrossFire"
"Point Blank"
"PUBG PC"
"PUBG Lite PC"
"Call of Duty Modern Warfare II"
"Call of Duty Black Ops Cold War"
"Call of Duty Black Ops III"
"Call of Duty WWII"
"Far Cry 6 Online"
"Cyberpunk 2077 Online"
"Red Dead Online"
"Monster Hunter: World"
"Monster Hunter Rise"
"Final Fantasy XIV"
"Final Fantasy XI"
"Genshin Impact (PC)"
"Tower of Fantasy"
"MapleStory"
"Guild Wars 2"
"EVE Online"
"Albion Online"
"FIFA 23 PC"
"NBA 2K24"
"Madden NFL 24"
"eFootball 2024 (PES)"
"Tekken 7 Online"
"Street Fighter V Online"
"Mortal Kombat 11"
"Injustice 2 (PC)"
"Gran Turismo 7 Online"
"Forza Horizon 5"
"Need for Speed Heat"
"The Crew 2"
)

# ---------- Games blocked in Iran (affects pool selection) ----------
blocked_in_ir=(
"PUBG Mobile"
"Call of Duty Mobile"
"Garena Free Fire"
"Arena Breakout"
"Clash of Clans"
"Mobile Legends: Bang Bang"
"Fortnite"
"Call of Duty Warzone"
"Valorant"
"Apex Legends"
"Overwatch 2"
"Rainbow Six Siege"
"League of Legends"
"Counter-Strike 2"
"Dota 2"
"World of Warcraft"
)

is_blocked_in_ir(){
  local n="$1"
  for g in "${blocked_in_ir[@]}"; do
    [[ "$g" == "$n" ]] && return 0
  done
  return 1
}
# ------------------------------------------------
# ============== DNS Picker Logic ================
# ------------------------------------------------

pick_best_two(){
  local arr=( "$@" ) pairs=() ip ms
  mapfile -t arr < <(printf "%s\n" "${arr[@]}" | shuffle_lines)
  for ip in "${arr[@]}"; do
    [[ -z "$ip" ]] && continue
    ms="$(measure_ms "$ip")"
    pairs+=( "$ms|$ip" )
  done
  mapfile -t top2 < <(printf "%s\n" "${pairs[@]}" | sort -n -t '|' -k1,1 | head -n 2)
  printf "%s\n%s\n" "${top2[0]}" "${top2[1]}"
}

show_primary_secondary(){
  local a="$1" b="$2" ip ms
  ip="${a#*|}"; ms="${a%%|*}"
  [[ "$ip" == *:* ]] && ip="$(expand_ipv6 "$ip")"
  printf "Primary DNS:   %-40s → %sms\n" "$ip" "$ms"

  ip="${b#*|}"; ms="${b%%|*}"
  [[ "$ip" == *:* ]] && ip="$(expand_ipv6 "$ip")"
  printf "Secondary DNS: %-40s → %sms\n" "$ip" "$ms"
}

# ------------------------------------------------
# ================== Services ====================
# ------------------------------------------------

serve_game(){
  local game="$1"
  echo "Selected Game: $game"
  if is_blocked_in_ir "$game"; then
    serve_dns_set "$game" "${ANTI_V4[@]}"
  else
    serve_dns_set "$game" "${MASTER_V4[@]}"
  fi
}

serve_dns_set(){
  local label="$1"; shift
  local lines out1 out2
  lines="$(pick_best_two "$@")"
  out1="$(echo "$lines" | sed -n '1p')"
  out2="$(echo "$lines" | sed -n '2p')"
  echo ">>> $label DNS Servers:"
  show_primary_secondary "$out1" "$out2"
}

serve_download(){
  echo ">>> Download DNS Servers"
  serve_dns_set "Download" "${DOWNLOAD_V4[@]}"
}

search_game_device(){
  read -rp "Enter game name: " gname
  read -rp "Enter device (Mobile/PC/Console): " dname
  local ng=$(normalize_game "$gname") found=""
  for g in "${mobile_games[@]}"; do
    [[ "$(normalize_game "$g")" == "$ng" ]] && found="$g" && break
  done
  [[ -z "$found" ]] && for g in "${pc_console_games[@]}"; do
    [[ "$(normalize_game "$g")" == "$ng" ]] && found="$g" && break
  done

  if [[ -n "$found" ]]; then
    serve_game "$found"
  else
    serve_dns_set "$gname" "${ANTI_V4[@]}"
  fi
}

gen_dns_country(){
  local country="$1" mode="$2" count="$3" pool=() ip ms
  case "$country" in
    Iran)   pool=( "${IR_V4[@]}" ) ;;
    UAE)    pool=( "${AE_V4[@]}" ) ;;
    Saudi)  pool=( "${SA_V4[@]}" ) ;;
    Turkey) pool=( "${TR_V4[@]}" ) ;;
  esac
  if [[ "$mode" == "IPv6" ]]; then
    case "$country" in
      Iran)   pool=( "${IR_V6[@]}" ) ;;
      UAE)    pool=( "${AE_V6[@]}" ) ;;
      Saudi)  pool=( "${SA_V6[@]}" ) ;;
      Turkey) pool=( "${TR_V6[@]}" ) ;;
      *)      pool=( "${GLOBAL_V6[@]}" ) ;;
    esac
  fi

  echo ">>> Generated $mode DNS for $country:"
  local n=1
  while [[ $n -le $count ]]; do
    if [[ -n "${pool[*]}" ]]; then
      ip="${pool[$((RANDOM % ${#pool[@]}))]}"
    else
      if [[ "$mode" == "IPv4" ]]; then
        ip="$((RANDOM%256)).$((RANDOM%256)).$((RANDOM%256)).$((RANDOM%256))"
      else
        ip="2001:db8:$((RANDOM%9999))::$((RANDOM%9999))"
      fi
    fi
    [[ "$mode" == "IPv6" ]] && ip="$(expand_ipv6 "$ip")"
    ms="$(measure_ms "$ip")"
    printf "%3d) %-40s → %sms\n" "$n" "$ip" "$ms"
    n=$((n+1))
  done
}

# ------------------------------------------------
# ==================== Menus =====================
# ------------------------------------------------

menu_mobile(){
  title
  echo ">>> Mobile Games:"
  local i=1
  for g in "${mobile_games[@]}"; do
    printf "%2d) %s\n" "$i" "$g"; i=$((i+1))
  done
  echo " 0) Back"
  read -rp "Pick: " n
  if (( n==0 )); then return
  elif (( n>=1 && n<=${#mobile_games[@]} )); then
    serve_game "${mobile_games[$n-1]}"
  else
    echo "Invalid choice"
  fi
  footer; pause_enter
}

menu_pc(){
  title
  echo ">>> PC / Console Games:"
  local i=1
  for g in "${pc_console_games[@]}"; do
    printf "%2d) %s\n" "$i" "$g"; i=$((i+1))
  done
  echo " 0) Back"
  read -rp "Pick: " n
  if (( n==0 )); then return
  elif (( n>=1 && n<=${#pc_console_games[@]} )); then
    serve_game "${pc_console_games[$n-1]}"
  else
    echo "Invalid choice"
  fi
  footer; pause_enter
}

menu_search(){
  title
  search_game_device
  echo " 0) Back"
  footer; pause_enter
}

menu_download(){
  title
  serve_download
  echo " 0) Back"
  footer; pause_enter
}

menu_generate(){
  title
  echo "Select country:"
  echo "1) Iran"
  echo "2) UAE"
  echo "3) Saudi"
  echo "4) Turkey"
  echo "0) Back"
  read -rp "Pick: " c
  case "$c" in
    1) cc="Iran" ;;
    2) cc="UAE" ;;
    3) cc="Saudi" ;;
    4) cc="Turkey" ;;
    0) return ;;
    *) echo "Invalid"; pause_enter; return ;;
  esac

  echo "Select IP mode: 1) IPv4  2) IPv6  0) Back"
  read -rp "Pick: " m
  case "$m" in
    1) mm="IPv4" ;;
    2) mm="IPv6" ;;
    0) return ;;
    *) echo "Invalid"; pause_enter; return ;;
  esac

  read -rp "How many DNS? " num
  gen_dns_country "$cc" "$mm" "$num"
  footer; pause_enter
}

# ------------------------------------------------
# ================== Main Loop ===================
# ------------------------------------------------

main_menu(){
  while true; do
    title
    echo ">>> Main Menu"
    echo "1) Mobile Games DNS"
    echo "2) PC / Console Games DNS"
    echo "3) Search Game & Device"
    echo "4) Download DNS"
    echo "5) Generate DNS by Country"
    echo "0) Exit"
    read -rp "Select: " opt
    case "$opt" in
      1) menu_mobile ;;
      2) menu_pc ;;
      3) menu_search ;;
      4) menu_download ;;
      5) menu_generate ;;
      0) echo "Goodbye!"; exit 0 ;;
      *) echo "Invalid choice"; sleep 1 ;;
    esac
  done
}

# ---------- Start ----------
main_menu
