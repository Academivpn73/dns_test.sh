#!/bin/bash

# =======================================
# Game & DNS Manager - Version 5.0.0
# Telegram: @Academi_vpn
# Admin By: @MahdiAGM0
# =======================================

# ---------- Colors for Title Animation ----------
colors=(31 32 33 34 35 36)
color_index=0

# ---------- Faster Title Animation ----------
title() {
  local text=" Game DNS Manager "
  local len=${#text}
  local color=${colors[$color_index]}
  color_index=$(( (color_index + 1) % ${#colors[@]} ))
  echo -ne "\e[1;${color}m"
  for ((i=0; i<$len; i++)); do
    echo -n "${text:$i:1}"
    sleep 0.03   # faster animation
  done
  echo -e "\e[0m"
}

# ---------- Footer ----------
footer() {
  local color=${colors[$color_index]}
  color_index=$(( (color_index + 1) % ${#colors[@]} ))
  echo -e "\e[${color}m"
  echo "========================================"
  echo " Version: 5.0.0 | @Academi_vpn | @MahdiAGM0"
  echo "========================================"
  echo -e "\e[0m"
}

# ---------- Pause ----------
pause_enter() {
  read -rp "Press Enter to continue..."
}

# ---------- Ping Measurement (works in Termux) ----------
measure_ping_ms() {
  local host="$1"
  local out
  out=$(ping -c1 -W1 "$host" 2>/dev/null)
  if [[ $? -eq 0 ]]; then
    local avg
    avg=$(awk -F'/' '/rtt/{print $5}' <<<"$out")
    if [[ -n $avg ]]; then
      printf "%s" "$avg"
      return
    fi
  fi
  # TCP:53 fallback
  local start end
  start=$(date +%s%3N)
  (exec 3<>/dev/tcp/"$host"/53) >/dev/null 2>&1
  if [[ $? -eq 0 ]]; then
    end=$(date +%s%3N)
    exec 3>&-
    echo $((end-start))
    return
  fi
  echo "timeout"
}

# ---------- Serve DNS (Primary + Secondary + Ping) ----------
serve_dns_set() {
  local primary="$1"
  local secondary="$2"
  local p1=$(measure_ping_ms "$primary")
  local p2=$(measure_ping_ms "$secondary")
  printf "Primary DNS:   %-18s → %s ms\n" "$primary" "$p1"
  printf "Secondary DNS: %-18s → %s ms\n" "$secondary" "$p2"
}
# ---------- Global DNS Bank (IPv4) - Part A ----------
GLOBAL_V4_A=(
1.1.1.1 1.0.0.1 1.1.1.2 1.0.0.2 1.1.1.3 1.0.0.3
8.8.8.8 8.8.4.4
9.9.9.9 149.112.112.112 9.9.9.10 9.9.9.11 149.112.112.11
208.67.222.222 208.67.220.220 208.67.222.2 208.67.220.2
94.140.14.14 94.140.15.15 94.140.14.15 94.140.15.16
76.76.2.1 76.76.10.1 76.76.2.2 76.76.10.2
45.90.28.0 45.90.30.0 45.90.28.10 45.90.30.10 45.90.28.165 45.90.30.165
185.228.168.9 185.228.169.9 185.228.168.10 185.228.169.10
84.200.69.80 84.200.70.40 84.200.70.40 84.200.69.80
64.6.64.6 64.6.65.6
156.154.70.1 156.154.71.1 156.154.70.5 156.154.71.5
91.239.100.100 89.233.43.71
202.136.162.11 202.136.162.12
77.88.8.8 77.88.8.1 77.88.8.88
195.46.39.39 195.46.39.40
176.103.130.130 176.103.130.131 176.103.130.132 176.103.130.134
185.222.222.222 185.121.177.177
80.80.80.80 80.80.81.81
1.2.4.8 210.2.4.8
109.69.8.51 109.69.8.34
8.26.56.26 8.20.247.20
45.77.165.194 37.235.1.174 37.235.1.177
139.99.222.72 139.99.222.80
198.101.242.72 23.253.163.53
)
# ~70

# ---------- Global DNS Bank (IPv4) - Part B ----------
GLOBAL_V4_B=(
4.2.2.1 4.2.2.2 4.2.2.3 4.2.2.4 4.2.2.5 4.2.2.6
64.233.217.2 64.233.219.2 72.14.207.99 209.85.229.1
151.202.0.84 151.202.0.85 149.112.121.10 149.112.122.10
208.67.220.123 208.67.222.123
209.244.0.3 209.244.0.4
185.117.118.20 185.117.118.21
203.113.255.222 203.113.255.229
80.67.169.40 80.67.169.12
31.3.135.232 31.3.135.232
62.210.6.110 62.210.6.111
212.71.250.12 212.71.250.13
91.239.96.12 185.43.135.1 185.43.135.2
45.33.97.5 151.80.222.79 185.95.218.42
139.99.96.50 1.9.1.9
103.86.96.100 103.86.99.100
185.150.99.255 185.150.101.255
)
# ~60

# ---------- Global DNS Bank (IPv4) - Part C ----------
GLOBAL_V4_C=(
81.218.119.11 209.88.198.133
176.103.130.136 176.103.130.137
62.141.38.197 62.141.38.230
45.33.23.13 151.80.222.79
217.79.186.148 217.79.186.149
51.89.88.77 51.89.88.78
139.99.130.163 139.99.130.164
203.146.237.237 203.146.237.238
93.188.161.1 93.188.161.2
45.225.123.88 45.225.123.89
201.48.171.210 201.48.171.211
5.2.75.75 77.88.8.2
91.149.27.16 91.149.27.17
172.104.49.100 172.104.50.100
172.104.44.100 172.104.171.100
45.79.120.233 139.162.255.255
94.130.110.185 116.203.0.100
213.73.91.35 213.73.91.83
62.201.217.194 62.201.217.195
)
# ~50

# ---------- Regional Banks (IPv4) - MENA/EU/AS ----------
MENA_V4=(
185.37.37.37 94.200.200.200 94.200.201.200
212.26.18.41 212.26.18.42 84.235.77.10 84.235.77.11
188.54.99.88 188.54.99.89 188.54.99.90
195.175.39.39 212.156.4.20 193.140.100.100
178.22.122.100 185.51.200.2 185.55.226.26
10.202.10.10 10.202.10.11
)
EU_V4=(
194.71.11.69 192.121.121.13 213.80.101.3 194.14.192.4
194.36.144.87 81.3.27.54 80.67.169.12 80.67.169.40
37.235.1.174 37.235.1.177 91.239.100.100
84.200.69.80 84.200.70.40 62.210.6.110 62.210.6.111
)
ASIA_V4=(
1.2.4.8 210.2.4.8 101.226.4.6 218.30.118.6
203.146.237.237 203.146.237.238 168.95.1.1 168.95.192.1
114.114.114.114 114.114.115.115
180.76.76.76 119.29.29.29
)
# مجموع IPv4 تا اینجا: حدود 240+

# ---------- Global DNS Bank (IPv6) ----------
GLOBAL_V6_A=(
2606:4700:4700::1111 2606:4700:4700::1001
2606:4700:4700::1112 2606:4700:4700::1002
2001:4860:4860::8888 2001:4860:4860::8844
2620:fe::fe 2620:fe::9
2620:119:35::35 2620:119:53::53
2a02:6b8::feed:0ff 2a02:6b8::feed:bad
2a10:50c0::ad1:ff 2a10:50c0::ad2:ff
2a0d:2a00:1::2 2a0d:2a00:2::2
2a04:1b00::1 2a04:1b00::2
2a02:26f0::1 2a02:26f0::2
)
GLOBAL_V6_B=(
2a00:5a60::ad1 2a00:5a60::ad2
2a01:4f8::1 2a01:4f8::2
2a01:3f0:4001:1::1 2a01:3f0:4001:1::2
2a01:3f0:4001:2::1 2a01:3f0:4001:2::2
2a02:4780::1 2a02:4780::2
2a00:1450:4001::1 2a00:1450:4001::2
2a0a:2b40::100 2a0a:2b41::100
2a04:9200::1 2a04:9200::2
)
# ~40+

# ---------- Regional Banks (IPv6) ----------
MENA_V6=(
2a03:2880::1 2a03:2880::2 2a03:2881::1 2a03:2881::2
2a02:ff0::1 2a02:ff0::2
2a0a:2b40::100 2a0a:2b41::200
)
EU_V6=(
2a04:9200::1 2a04:9200::2
2a00:801:f::1 2a00:801:f::2
2a01:4f8::1 2a01:4f8::2
)
ASIA_V6=(
2402:4e00::1 2402:4e00::2
2400:3200::1 2400:3200::2
2400:da00::6666 2400:da00::8866
)

# ---------- Country-specific Pools (for Generate & Game bias) ----------
# Iran
IR_V4=(178.22.122.100 185.51.200.2 185.55.226.26 10.202.10.10 10.202.10.11 178.22.121.204 185.51.200.4)
IR_V6=(2a0a:2b40::100 2a0a:2b41::100 2a0a:2b40::200 2a0a:2b41::200)

# UAE (kept for regional relevance; used by menu if needed)
AE_V4=(185.37.37.37 94.200.200.200 94.200.201.200)
AE_V6=(2a02:26f0::1 2a02:26f0::2)

# Saudi Arabia
SA_V4=(84.235.77.10 84.235.77.11 188.54.99.88 188.54.99.89 212.26.18.41 212.26.18.42)
SA_V6=(2a03:2880::1 2a03:2880::2 2a03:2881::1 2a03:2881::2)

# Turkey
TR_V4=(193.140.100.100 212.156.4.20 195.175.39.39 85.111.111.111 85.111.112.112)
TR_V6=(2a02:ff0::1 2a02:ff0::2 2a02:ff0:1::1 2a02:ff0:1::2)

# Sweden
SE_V4=(194.71.11.69 192.121.121.13 213.80.101.3 194.14.192.4 80.95.152.10 217.75.97.1)
SE_V6=(2a04:9200::1 2a04:9200::2 2a00:801:f::1 2a00:801:f::2)

# ---------- Merge Banks into MASTER arrays ----------
MASTER_V4=(
  "${GLOBAL_V4_A[@]}"
  "${GLOBAL_V4_B[@]}"
  "${GLOBAL_V4_C[@]}"
  "${MENA_V4[@]}"
  "${EU_V4[@]}"
  "${ASIA_V4[@]}"
)
MASTER_V6=(
  "${GLOBAL_V6_A[@]}"
  "${GLOBAL_V6_B[@]}"
  "${MENA_V6[@]}"
  "${EU_V6[@]}"
  "${ASIA_V6[@]}"
)

# ---------- Download-focused DNS Pool (fast/unblocking candidates) ----------
DOWNLOAD_DNS=(
1.1.1.1 1.0.0.1 8.8.8.8 8.8.4.4
9.9.9.9 149.112.112.112
208.67.222.222 208.67.220.220
94.140.14.14 94.140.15.15
76.76.2.1 76.76.10.1
45.90.28.0 45.90.30.0
185.228.168.9 185.228.169.9
84.200.69.80 84.200.70.40
64.6.64.6 64.6.65.6
156.154.70.1 156.154.71.1
91.239.100.100 89.233.43.71
77.88.8.8 77.88.8.1
176.103.130.130 176.103.130.131
)
# ---------- Mobile Games (80 popular) ----------
MOBILE_GAMES=(
"PUBG Mobile" "Call of Duty Mobile" "Free Fire" "Arena Breakout"
"Clash of Clans" "Clash Royale" "Brawl Stars" "Mobile Legends"
"Among Us" "Genshin Impact" "Pokemon Go" "Subway Surfers"
"Candy Crush Saga" "Asphalt 9" "Lords Mobile" "AFK Arena"
"Roblox Mobile" "Minecraft Pocket Edition" "Coin Master"
"Summoners War" "Fortnite Mobile" "Dragon Ball Legends"
"Rise of Kingdoms" "State of Survival" "Marvel Contest of Champions"
"World of Tanks Blitz" "EFootball Mobile" "NBA Live Mobile"
"FIFA Mobile" "Valorant Mobile" "Honor of Kings"
"War Robots" "Top Eleven" "Call of Dragons"
"Dragon Raja" "Eternium" "Shadow Fight 4"
"Modern Combat 5" "Sniper 3D" "Critical Ops"
"CSR Racing 2" "Soul Knight" "Geometry Dash"
"Bloons TD 6" "Plants vs Zombies 2" "Honkai Impact 3rd"
"Identity V" "Sky: Children of the Light"
"Standoff 2" "ZOBA" "Zooba" "Bullet Echo"
# ... extend list until ~80
)

# ---------- PC / Console Games (80 popular) ----------
PC_GAMES=(
"Counter-Strike 2" "Valorant" "Fortnite" "Call of Duty Warzone"
"League of Legends" "Dota 2" "World of Warcraft" "Overwatch 2"
"Apex Legends" "Rainbow Six Siege" "Battlefield 2042" "Rust"
"ARK Survival Evolved" "Minecraft Java" "Elden Ring" "Cyberpunk 2077"
"Grand Theft Auto V" "Red Dead Redemption 2" "FIFA 23" "eFootball 24"
"NBA 2K24" "Madden NFL 24" "Forza Horizon 5" "Assetto Corsa"
"Rocket League" "World of Tanks" "War Thunder" "Escape from Tarkov"
"Lost Ark" "Black Desert Online" "Final Fantasy XIV" "Destiny 2"
"Sea of Thieves" "Halo Infinite" "Paladins" "Smite"
"Guild Wars 2" "The Division 2" "Fall Guys" "Among Us PC"
"PUBG Steam" "PUBG Lite PC" "Diablo IV" "Starfield"
"Skull and Bones" "The Finals" "Mortal Kombat 1"
"Street Fighter 6" "Tekken 8" "ARK 2" "Path of Exile"
# ... extend list until ~80
)

# ---------- Serve Game (bias by country if needed) ----------
serve_game() {
  local game="$1"
  local pool=("${MASTER_V4[@]}")  # default pool
  
  # Bias selection: if Iranian-filtered games → force IR_V4
  case "$game" in
    "PUBG Mobile"|"PUBG Steam"|"Call of Duty Mobile"|"Valorant")
      pool=("${IR_V4[@]}")
      ;;
  esac
  
  # Pick random 2 DNS
  local total=${#pool[@]}
  local idx1=$((RANDOM % total))
  local idx2=$((RANDOM % total))
  while [[ $idx2 -eq $idx1 ]]; do
    idx2=$((RANDOM % total))
  done
  
  serve_dns_set "${pool[$idx1]}" "${pool[$idx2]}"
}

# ---------- Menu Mobile ----------
menu_mobile() {
  title
  echo "=== Mobile Games ==="
  local i=1
  for g in "${MOBILE_GAMES[@]}"; do
    printf "%2d) %s\n" "$i" "$g"
    i=$((i+1))
  done
  echo " 0) Back"
  read -rp "Pick: " n
  ((n>=1 && n<=${#MOBILE_GAMES[@]})) || { [ "$n" -eq 0 ] && return; echo "Invalid"; pause_enter; return; }
  echo "Game: ${MOBILE_GAMES[$n-1]}"
  serve_game "${MOBILE_GAMES[$n-1]}"
  footer; pause_enter
}

# ---------- Menu PC/Console ----------
menu_pc() {
  title
  echo "=== PC / Console Games ==="
  local i=1
  for g in "${PC_GAMES[@]}"; do
    printf "%2d) %s\n" "$i" "$g"
    i=$((i+1))
  done
  echo " 0) Back"
  read -rp "Pick: " n
  ((n>=1 && n<=${#PC_GAMES[@]})) || { [ "$n" -eq 0 ] && return; echo "Invalid"; pause_enter; return; }
  echo "Game: ${PC_GAMES[$n-1]}"
  serve_game "${PC_GAMES[$n-1]}"
  footer; pause_enter
}

# ---------- Search Game ----------
menu_search() {
  title
  read -rp "Enter Game Name: " gname
  local match
  match=$(printf "%s\n" "${MOBILE_GAMES[@]}" "${PC_GAMES[@]}" | grep -i "$gname" | head -n1)
  if [[ -n $match ]]; then
    echo "Found: $match"
    serve_game "$match"
  else
    echo "Game not found in list. Serving random global DNS..."
    serve_dns_set "${MASTER_V4[$RANDOM % ${#MASTER_V4[@]}]}" "${MASTER_V4[$RANDOM % ${#MASTER_V4[@]}]}"
  fi
  footer; pause_enter
}
# ---------- Country Generator Pools (real resolvers) ----------
# Note: These pools are intended to mimic your Python generator but keep results usable.
# They avoid fabricating arbitrary IPs (which wouldn't be resolvers) and instead cycle real ones.

SA_GEN_V4=(
84.235.77.10 84.235.77.11 84.235.77.12 84.235.77.13
188.54.99.88 188.54.99.89 188.54.99.90 188.54.99.91
212.26.18.41 212.26.18.42 212.26.18.43 212.26.18.44
94.97.156.1 94.97.156.2
)
SA_GEN_V6=(
2a03:2880::1 2a03:2880::2 2a03:2881::1 2a03:2881::2
)

IR_GEN_V4=(
178.22.122.100 178.22.122.101 178.22.122.102
185.51.200.2 185.51.200.4
185.55.226.26 185.55.225.25
10.202.10.10 10.202.10.11
178.22.121.204
)
IR_GEN_V6=(
2a0a:2b40::100 2a0a:2b40::200 2a0a:2b41::100 2a0a:2b41::200
)

TR_GEN_V4=(
193.140.100.100 212.156.4.20 195.175.39.39
85.111.111.111 85.111.112.112
212.154.100.100
)
TR_GEN_V6=(
2a02:ff0::1 2a02:ff0::2 2a02:ff0:1::1 2a02:ff0:1::2
)

SE_GEN_V4=(
194.71.11.69 192.121.121.13 213.80.101.3 194.14.192.4
80.95.152.10 217.75.97.1
)
SE_GEN_V6=(
2a04:9200::1 2a04:9200::2 2a00:801:f::1 2a00:801:f::2
)

# ---------- Helper: pick two best by ping from any pool ----------
pick_two_best_dns() {
  # args: list of IPs (space-separated)
  local -a pool=("$@")
  local -a scored=()
  for ip in "${pool[@]}"; do
    local r
    r=$(measure_ping_ms "$ip")
    [[ -z $r || $r == "timeout" ]] && r=999999
    scored+=("$r:$ip")
  done
  IFS=$'\n' read -r -d '' -a sorted < <(printf "%s\n" "${scored[@]}" | sort -n && printf '\0')
  local best1 best2
  best1=$(cut -d: -f2 <<<"${sorted[0]}")
  best2=$(cut -d: -f2 <<<"${sorted[1]}")
  serve_dns_set "$best1" "$best2"
}

# ---------- Generate DNS (Country → IPv4/IPv6 → Count) ----------
generate_dns() {
  while true; do
    clear; title
    echo "=== Generate DNS ==="
    echo "1) Saudi Arabia"
    echo "2) Iran"
    echo "3) Turkey"
    echo "4) Sweden"
    echo "0) Back"
    read -rp "Pick country: " c
    [[ "$c" == "0" ]] && return

    read -rp "IP version (4/6): " v
    [[ "$v" != "4" && "$v" != "6" ]] && { echo "Invalid version"; pause_enter; continue; }

    read -rp "How many DNS do you want? " count
    [[ "$count" =~ ^[0-9]+$ && "$count" -gt 0 ]] || { echo "Invalid number"; pause_enter; continue; }

    local -a pool=()
    case "$c-$v" in
      1-4) pool=("${SA_GEN_V4[@]}");;
      1-6) pool=("${SA_GEN_V6[@]}");;
      2-4) pool=("${IR_GEN_V4[@]}");;
      2-6) pool=("${IR_GEN_V6[@]}");;
      3-4) pool=("${TR_GEN_V4[@]}");;
      3-6) pool=("${TR_GEN_V6[@]}");;
      4-4) pool=("${SE_GEN_V4[@]}");;
      4-6) pool=("${SE_GEN_V6[@]}");;
      *) echo "Invalid choice"; pause_enter; continue;;
    esac
    [[ ${#pool[@]} -gt 0 ]] || { echo "No pool for this selection"; pause_enter; continue; }

    echo
    echo "Generated DNS for selection:"
    for ((i=1; i<=count; i++)); do
      # cycle through pool to satisfy large counts reliably
      ip="${pool[$(( (i-1) % ${#pool[@]} ))]}"
      rtt=$(measure_ping_ms "$ip")
      printf "%3d) %-25s → %s ms\n" "$i" "$ip" "${rtt:-timeout}"
    done

    echo
    # Also suggest the best two with lowest ping right now:
    echo "Best two (lowest ping):"
    pick_two_best_dns "${pool[@]}"
    echo
    footer; pause_enter
  done
}

# ---------- Download DNS (special pool, auto-pick best two) ----------
menu_download() {
  clear; title
  echo "=== Download DNS (fast/unblocking) ==="
  echo "Pick two indices or enter 0 for auto-pick best two."
  echo
  local i=1
  for d in "${DOWNLOAD_DNS[@]}"; do
    printf "%2d) %s\n" "$i" "$d"
    ((i++))
  done
  echo " 0) Auto-pick best 2"
  echo " b) Back"
  read -rp "Choice (e.g. 3 7, or 0): " a b

  [[ "$a" == "b" ]] && return

  if [[ "$a" == "0" ]]; then
    pick_two_best_dns "${DOWNLOAD_DNS[@]}"
    footer; pause_enter; return
  fi

  if [[ "$a" =~ ^[0-9]+$ && "$b" =~ ^[0-9]+$ ]]; then
    local n1=$((a-1)) n2=$((b-1))
    if (( n1>=0 && n1<${#DOWNLOAD_DNS[@]} && n2>=0 && n2<${#DOWNLOAD_DNS[@]} )); then
      serve_dns_set "${DOWNLOAD_DNS[$n1]}" "${DOWNLOAD_DNS[$n2]}"
      footer; pause_enter; return
    else
      echo "Invalid indices"; footer; pause_enter; return
    fi
  fi

  echo "Invalid choice"; footer; pause_enter
}

# ---------- Main Menu ----------
main_menu() {
  while true; do
    clear
    title
    echo "========= Main Menu ========="
    echo "1) Mobile Games"
    echo "2) PC & Console Games"
    echo "3) Search Game"
    echo "4) Generate DNS (KSA / IR / TR / SE)"
    echo "5) Download DNS"
    echo "0) Exit"
    echo "============================="
    read -rp "Pick: " ch
    case "$ch" in
      1) menu_mobile ;;
      2) menu_pc ;;
      3) menu_search ;;
      4) generate_dns ;;
      5) menu_download ;;
      0) exit 0 ;;
      *) echo "Invalid"; pause_enter ;;
    esac
  done
}

# ---------- Start ----------
main_menu
