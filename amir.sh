#!/bin/bash
# =======================================
# Game & DNS Manager - Version 6.0.0
# Telegram: @Academi_vpn
# Admin By: @MahdiAGM0
# =======================================

# ---------- Colors for Title ----------
colors=(31 32 33 34 35 36)
color_index=0

# ---------- Title Animation ----------
title() {
  local text=" Game DNS Manager "
  local len=${#text}
  local color=${colors[$color_index]}
  color_index=$(( (color_index + 1) % ${#colors[@]} ))
  echo -ne "\e[1;${color}m"
  for ((i=0; i<$len; i++)); do
    echo -n "${text:$i:1}"
    sleep 0.02   # faster animation
  done
  echo -e "\e[0m"
}

# ---------- Footer ----------
footer() {
  local color=${colors[$color_index]}
  color_index=$(( (color_index + 1) % ${#colors[@]} ))
  echo -e "\e[${color}m"
  echo "========================================"
  echo " Version: 6.0.0 | @Academi_vpn | @MahdiAGM0"
  echo "========================================"
  echo -e "\e[0m"
}

# ---------- Pause ----------
pause_enter() {
  read -rp "Press Enter to continue..."
}

# ---------- Ping Measurement ----------
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

# ---------- Serve DNS ----------
serve_dns_set() {
  local primary="$1"
  local secondary="$2"
  local p1=$(measure_ping_ms "$primary")
  local p2=$(measure_ping_ms "$secondary")
  printf "Primary DNS:   %-18s → %s ms\n" "$primary" "$p1"
  printf "Secondary DNS: %-18s → %s ms\n" "$secondary" "$p2"
}# =====================================================
# =============== DNS BANKS (EXPANDED) ================
# =====================================================

# ---------- Global / Popular (IPv4) ----------
GLOBAL_V4_A=(
# Cloudflare
1.1.1.1 1.0.0.1 1.1.1.2 1.0.0.2 1.1.1.3 1.0.0.3
# Google
8.8.8.8 8.8.4.4
# Quad9
9.9.9.9 149.112.112.112 9.9.9.10 9.9.9.11 149.112.112.11
# OpenDNS
208.67.222.222 208.67.220.220 208.67.222.2 208.67.220.2 208.67.222.123 208.67.220.123
# AdGuard
94.140.14.14 94.140.15.15 94.140.14.15 94.140.15.16
# NextDNS (public anycast)
76.76.2.1 76.76.10.1 76.76.2.2 76.76.10.2
# CleanBrowsing (Family/Adult/Security)
185.228.168.9 185.228.169.9 185.228.168.10 185.228.169.11 185.228.168.168 185.228.169.168
# DNS.WATCH
84.200.69.80 84.200.70.40
# Verisign / Neustar
64.6.64.6 64.6.65.6 156.154.70.1 156.154.71.1 156.154.70.5 156.154.71.5
# UncensoredDNS
91.239.100.100 89.233.43.71
# Yandex
77.88.8.8 77.88.8.1 77.88.8.2
# Comodo
8.26.56.26 8.20.247.20
# Level3 / GTEI legacy
4.2.2.1 4.2.2.2 4.2.2.3 4.2.2.4 4.2.2.5 4.2.2.6
# Hurricane Electric (public)
74.82.42.42
# SafeDNS
195.46.39.39 195.46.39.40
# OpenNIC (selection of anycast/known hubs)
185.121.177.177 169.239.202.202 51.89.233.166 51.15.119.66
# CleanBrowsing more endpoints
185.228.169.9 185.228.168.9 185.228.168.10 185.228.169.10
# CF alt PoPs (anycast same service)
1.1.1.4 1.0.0.4
# Misc reputable
37.235.1.174 37.235.1.177
23.253.163.53 198.101.242.72
64.113.32.5 64.113.44.53
208.76.50.50 208.76.51.51
205.171.3.65 205.171.2.65
1.0.0.10 1.1.1.10
9.9.9.12 149.112.112.12
208.91.112.52 199.85.126.10
# PowerDNS community/public
85.214.20.141 52.58.115.42
# more OpenNIC/alt
139.99.222.72 172.104.93.80 172.104.49.100 172.104.50.100 172.104.44.100 172.104.171.100
# OVH/Scaleway public recursors (common)
51.68.190.250 51.178.83.24 51.89.88.77 51.89.88.78 51.75.79.25
# Linode/Fra
45.79.120.233 45.33.23.13 45.33.97.5
)

GLOBAL_V4_B=(
# Cisco/OpenDNS edges
208.67.220.222 208.67.222.220
# Neustar additional
156.154.70.10 156.154.71.10
# AdGuard additional
94.140.14.140 94.140.14.141
# CleanBrowsing alt
185.228.169.168 185.228.168.168
# SafeDNS extra
195.46.39.41 195.46.39.42
# DNS.SB (BlahDNS/Anycast)
45.11.45.11 185.222.222.222
# Alternate resolvers—Europe nodes
80.67.169.12 80.67.169.40
62.210.6.110 62.210.6.111
84.200.70.40 84.200.69.80
45.90.28.193 45.90.30.193
45.90.28.226 45.90.30.226
# FDN (France)
80.67.188.188 80.67.169.12
# Digitalcourage (DE)
46.182.19.48 46.182.19.49
# Mullvad public
194.242.2.2 194.242.2.3
# ControlD public
76.76.2.11 76.76.2.22
# Alternate CF malware/family new aliases
1.1.1.2 1.0.0.2 1.1.1.3 1.0.0.3
# Cloud9/Quad9 edges
9.9.9.11 149.112.112.11 9.9.9.10
# OpenDNS family again (ensure redundancy)
208.67.222.123 208.67.220.123
# CenturyLink/Lumen public
205.171.3.25 205.171.202.166
# Singapore/JP public hubs
203.80.96.10 203.80.96.9 203.112.2.4 203.112.2.5
# AU/NZ public
203.109.191.1 202.27.158.40
# Misc peers
185.222.222.222 45.90.28.0 45.90.30.0
)

# ---------- Regional (IPv4) ----------
MENA_V4=(
# KSA / GCC
84.235.77.10 84.235.77.11 188.54.99.88 188.54.99.89 212.26.18.41 212.26.18.42 94.97.156.1 94.97.156.2
# UAE Etisalat/du publics
94.200.200.200 94.200.201.200 185.37.37.37
# IR (public/anycast-style)
178.22.122.100 178.22.122.101 185.51.200.2 185.51.200.4 185.55.226.26 185.55.225.25 10.202.10.10 10.202.10.11 178.22.121.204
# TR (Turkey)
193.140.100.100 212.156.4.20 195.175.39.39 85.111.111.111 85.111.112.112 212.154.100.100
# IL/LB/JO/EG common publics
62.219.186.7 62.219.186.9 80.179.52.100 212.69.48.61 213.57.2.5 163.121.128.134
)

EU_V4=(
# SE / DK / DE / FR / NL / UK mix
194.71.11.69 192.121.121.13 213.80.101.3 194.14.192.4 80.95.152.10 217.75.97.1
80.67.169.12 80.67.169.40 91.239.100.100 89.233.43.71
84.200.69.80 84.200.70.40 62.210.6.110 62.210.6.111
46.182.19.48 46.182.19.49 51.89.88.77 51.89.88.78
9.9.9.9 149.112.112.112 94.140.14.14 94.140.15.15
185.228.168.9 185.228.169.9
195.46.39.39 195.46.39.40
176.103.130.130 176.103.130.131
)

ASIA_V4=(
# CN / HK / JP / SG / TW / TH mix
114.114.114.114 114.114.115.115
223.5.5.5 223.6.6.6
180.76.76.76
1.2.4.8 210.2.4.8
101.226.4.6 218.30.118.6
168.95.1.1 168.95.192.1
203.146.237.237 203.146.237.238
1.1.1.1 8.8.8.8 9.9.9.9
119.29.29.29 182.254.116.116
# Quad101 (TW)
101.101.101.101 101.102.103.104
# Public JP/SG hubs
203.112.2.4 203.112.2.5 61.8.0.113 203.80.96.9 203.80.96.10
)

# ---------- Global / Popular (IPv6) ----------
GLOBAL_V6_A=(
2606:4700:4700::1111 2606:4700:4700::1001 2606:4700:4700::1112 2606:4700:4700::1002
2001:4860:4860::8888 2001:4860:4860::8844
2620:fe::fe 2620:fe::9
2620:119:35::35 2620:119:53::53
2a02:6b8::feed:0ff 2a02:6b8::feed:bad
2a0d:2a00:1::2 2a0d:2a00:2::2
2a04:1b00::1 2a04:1b00::2
2a01:4f8::1 2a01:4f8::2
2a02:4780::1 2a02:4780::2
)

GLOBAL_V6_B=(
2a00:1450:4001::1 2a00:1450:4001::2
2a04:9200::1 2a04:9200::2
2a00:801:f::1 2a00:801:f::2
2a0a:2b40::100 2a0a:2b41::100
2a03:2880::1 2a03:2880::2 2a03:2881::1 2a03:2881::2
2a01:4f9:c010::1 2a01:4f9:c010::2
2a02:c205:0:5001::1 2a02:c205:0:5001::2
)

MENA_V6=(
2a03:2880::1 2a03:2880::2 2a03:2881::1 2a03:2881::2
2a02:ff0::1 2a02:ff0::2 2a02:ff0:1::1 2a02:ff0:1::2
2a0a:2b40::100 2a0a:2b41::200
)

EU_V6=(
2a04:9200::1 2a04:9200::2
2a00:801:f::1 2a00:801:f::2
2a01:4f8::1 2a01:4f8::2
2a01:4f9:c010::1 2a01:4f9:c010::2
2a02:6b8::feed:0ff 2a02:6b8::feed:bad
)

ASIA_V6=(
2402:4e00::1 2402:4e00::2
2400:3200::1 2400:3200::2
2400:da00::6666 2400:da00::8866
2405:200:800::1 2405:200:800::2
)

# ---------- Country Pools (used by generator & game-bias) ----------
IR_V4=(
178.22.122.100 178.22.122.101 185.51.200.2 185.51.200.4
185.55.226.26 185.55.225.25 10.202.10.10 10.202.10.11 178.22.121.204
)
IR_V6=(2a0a:2b40::100 2a0a:2b40::200 2a0a:2b41::100 2a0a:2b41::200)

SA_V4=(84.235.77.10 84.235.77.11 188.54.99.88 188.54.99.89 212.26.18.41 212.26.18.42 94.97.156.1 94.97.156.2)
SA_V6=(2a03:2880::1 2a03:2880::2 2a03:2881::1 2a03:2881::2)

TR_V4=(193.140.100.100 212.156.4.20 195.175.39.39 85.111.111.111 85.111.112.112 212.154.100.100)
TR_V6=(2a02:ff0::1 2a02:ff0::2 2a02:ff0:1::1 2a02:ff0:1::2)

SE_V4=(194.71.11.69 192.121.121.13 213.80.101.3 194.14.192.4 80.95.152.10 217.75.97.1)
SE_V6=(2a04:9200::1 2a04:9200::2 2a00:801:f::1 2a00:801:f::2)

# ---------- Merge into MASTER pools ----------
MASTER_V4=( "${GLOBAL_V4_A[@]}" "${GLOBAL_V4_B[@]}" "${MENA_V4[@]}" "${EU_V4[@]}" "${ASIA_V4[@]}" )
MASTER_V6=( "${GLOBAL_V6_A[@]}" "${GLOBAL_V6_B[@]}" "${MENA_V6[@]}" "${EU_V6[@]}" "${ASIA_V6[@]}" )

# ---------- Download-focused pool (fast/unblocking) ----------
DOWNLOAD_DNS=(
# Prioritize anycast & well-peered resolvers (mix of providers)
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
205.171.3.65 205.171.2.65
195.46.39.39 195.46.39.40
)# =====================================================
# =============== GAMES SECTION =======================
# =====================================================

# ---------- Mobile Games ----------
MOBILE_GAMES=(
"PUBG Mobile" "Call of Duty Mobile" "Garena Free Fire" "Arena Breakout" "Clash of Clans"
"Mobile Legends" "Brawl Stars" "Among Us" "Genshin Impact" "Pokemon Go"
"Subway Surfers" "Candy Crush Saga" "Asphalt 9" "Lords Mobile" "AFK Arena"
"Roblox Mobile" "Minecraft Pocket Edition" "Coin Master" "Clash Royale" "Summoners War"
"Dragon City" "Boom Beach" "Hay Day" "Rise of Kingdoms" "State of Survival"
"Dragon Raja" "Diablo Immortal" "EFootball Mobile" "FIFA Mobile" "Top Eleven"
"Marvel Future Fight" "Honkai Impact 3rd" "Raid Shadow Legends" "War Robots" "World of Tanks Blitz"
"Identity V" "CrossFire Legends" "Creative Destruction" "Bullet Echo" "Shadow Fight 4"
"Sniper 3D" "8 Ball Pool" "Angry Birds" "Temple Run 2" "Jetpack Joyride"
"Modern Combat 5" "Critical Ops" "Zombie Hunter" "WWE Mayhem" "Injustice 2"
"Naruto Slugfest" "One Piece Treasure Cruise" "Dragon Ball Legends" "Bleach Brave Souls" "Yu-Gi-Oh Duel Links"
"Fortnite Mobile" "Apex Legends Mobile" "Valorant Mobile" "Lost Light" "Torchlight Infinite"
"Tower of Fantasy" "Honkai Star Rail" "Arena of Valor" "Summoners Greed" "Mobile Royale"
"Game for Peace (China PUBG)" "Knives Out" "Onmyoji Arena" "KartRider Rush+" "Arknights"
"Banana Kong" "Plants vs Zombies 2" "CSR Racing 2" "Need for Speed No Limits" "Real Racing 3"
)

# ---------- PC / Console Games ----------
CONSOLE_GAMES=(
"Valorant" "CS:GO" "Dota 2" "League of Legends" "World of Warcraft"
"Overwatch 2" "Diablo IV" "Hearthstone" "Starcraft II" "Heroes of the Storm"
"Call of Duty Warzone" "Call of Duty MW2" "Call of Duty Cold War" "Call of Duty Black Ops 3" "Call of Duty Vanguard"
"Fortnite" "Apex Legends" "Battlefield 2042" "Battlefield V" "Battlefield 1"
"Rainbow Six Siege" "The Division 2" "Ghost Recon Breakpoint" "Far Cry 6" "Assassin’s Creed Valhalla"
"Cyberpunk 2077" "The Witcher 3" "Elden Ring" "Dark Souls III" "Sekiro Shadows Die Twice"
"Monster Hunter World" "Lost Ark" "New World" "Final Fantasy XIV" "Phantasy Star Online 2"
"Rocket League" "Fall Guys" "Destiny 2" "Warframe" "Paladins"
"Smite" "PUBG PC" "Escape from Tarkov" "Rust" "DayZ"
"ARK Survival Evolved" "Conan Exiles" "Minecraft Java" "Terraria" "Stardew Valley"
"Among Us PC" "Phasmophobia" "Dead by Daylight" "Left 4 Dead 2" "Killing Floor 2"
"GTA Online" "Red Dead Online" "Mafia Definitive Edition" "Forza Horizon 5" "Gran Turismo 7"
"FIFA 23" "NBA 2K23" "PES eFootball 2023" "Madden NFL 23" "NHL 23"
"Tekken 7" "Street Fighter V" "Mortal Kombat 11" "SoulCalibur VI" "Dragon Ball FighterZ"
"Naruto Storm 4" "JoJo’s Bizarre Adventure All Star Battle R" "Guilty Gear Strive" "BlazBlue Cross Tag Battle" "King of Fighters XV"
)

# ---------- DNS Mapping ----------
# (For simplicity, games map to MASTER pools. Could bias by region)
declare -A GAME_TO_POOL
for g in "${MOBILE_GAMES[@]}"; do GAME_TO_POOL["$g"]="MASTER_V4"; done
for g in "${CONSOLE_GAMES[@]}"; do GAME_TO_POOL["$g"]="MASTER_V4"; done

# ---------- Serve Game DNS ----------
serve_game_dns() {
  local game="$1"
  local pool_name="${GAME_TO_POOL[$game]}"
  local pool=("${!pool_name}")
  local count=${#pool[@]}
  if ((count < 2)); then
    echo "No DNS pool available for $game"
    return
  fi
  local i1=$((RANDOM % count))
  local i2=$((RANDOM % count))
  while [[ $i2 -eq $i1 ]]; do i2=$((RANDOM % count)); done
  local dns1=${pool[$i1]}
  local dns2=${pool[$i2]}
  echo "DNS for $game:"
  serve_dns_set "$dns1" "$dns2"
}

# ---------- Menus ----------
menu_mobile() {
  title
  echo "===== Mobile Games ====="
  local i=1
  for g in "${MOBILE_GAMES[@]}"; do
    printf "%2d) %s\n" "$i" "$g"
    i=$((i+1))
  done
  echo " B) Back"
  read -rp "Choose game: " choice
  if [[ $choice =~ ^[0-9]+$ && $choice -ge 1 && $choice -le ${#MOBILE_GAMES[@]} ]]; then
    serve_game_dns "${MOBILE_GAMES[$choice-1]}"
    footer; pause_enter
  fi
}

menu_console() {
  title
  echo "===== PC & Console Games ====="
  local i=1
  for g in "${CONSOLE_GAMES[@]}"; do
    printf "%2d) %s\n" "$i" "$g"
    i=$((i+1))
  done
  echo " B) Back"
  read -rp "Choose game: " choice
  if [[ $choice =~ ^[0-9]+$ && $choice -ge 1 && $choice -le ${#CONSOLE_GAMES[@]} ]]; then
    serve_game_dns "${CONSOLE_GAMES[$choice-1]}"
    footer; pause_enter
  fi
}

# ---------- Search Function ----------
search_game() {
  title
  read -rp "Enter game name: " name
  local found=0
  for g in "${MOBILE_GAMES[@]}" "${CONSOLE_GAMES[@]}"; do
    if [[ "${g,,}" == *"${name,,}"* ]]; then
      serve_game_dns "$g"
      found=1
      break
    fi
  done
  [[ $found -eq 0 ]] && echo "Game not found."
  footer; pause_enter
}# =====================================================
# ============== GENERATE / DOWNLOAD / MAIN ===========
# =====================================================

# ---------- Pick best two by measured ping ----------
pick_two_best_dns() {
  local -a pool=("$@")
  local -a scored
  local line ip r

  # measure and build "rtt:ip"
  for ip in "${pool[@]}"; do
    r=$(measure_ping_ms "$ip")
    [[ -z $r || $r == "timeout" ]] && r=999999
    scored+=("$r:$ip")
  done

  # sort ascending by rtt
  IFS=$'\n' read -r -d '' -a scored < <(printf "%s\n" "${scored[@]}" | sort -n && printf '\0')

  local best1 best2
  best1=$(cut -d: -f2 <<<"${scored[0]}")
  best2=$(cut -d: -f2 <<<"${scored[1]}")
  serve_dns_set "$best1" "$best2"
}

# ---------- Country pools used by generator ----------
# (استفاده از همین بانک‌های واقعی که در Part 2 تعریف شده‌اند)
# SA_GEN_V4 / SA_GEN_V6
# IR_GEN_V4 / IR_GEN_V6
# TR_GEN_V4 / TR_GEN_V6
# SE_GEN_V4 / SE_GEN_V6

# اگر آن‌ها را در Part 2 نذاشتی، می‌تونی از SA_V4 ... به‌عنوان fallback استفاده کنی:
[[ ${#SA_GEN_V4[@]} -eq 0 ]] && SA_GEN_V4=("${SA_V4[@]}")
[[ ${#SA_GEN_V6[@]} -eq 0 ]] && SA_GEN_V6=("${SA_V6[@]}")
[[ ${#IR_GEN_V4[@]} -eq 0 ]] && IR_GEN_V4=("${IR_V4[@]}")
[[ ${#IR_GEN_V6[@]} -eq 0 ]] && IR_GEN_V6=("${IR_V6[@]}")
[[ ${#TR_GEN_V4[@]} -eq 0 ]] && TR_GEN_V4=("${TR_V4[@]}")
[[ ${#TR_GEN_V6[@]} -eq 0 ]] && TR_GEN_V6=("${TR_V6[@]}")
[[ ${#SE_GEN_V4[@]} -eq 0 ]] && SE_GEN_V4=("${SE_V4[@]}")
[[ ${#SE_GEN_V6[@]} -eq 0 ]] && SE_GEN_V6=("${SE_V6[@]}")

# ---------- Generate DNS (real, from country pools) ----------
generate_dns() {
  while true; do
    clear; title
    echo "===== Generate DNS ====="
    echo "1) Saudi Arabia"
    echo "2) Iran"
    echo "3) Turkey"
    echo "4) Sweden"
    echo "B) Back"
    read -rp "Pick country: " c
    case "${c^^}" in
      1) CNAME="Saudi Arabia";;
      2) CNAME="Iran";;
      3) CNAME="Turkey";;
      4) CNAME="Sweden";;
      B) return;;
      *) echo "Invalid choice"; pause_enter; continue;;
    esac

    read -rp "IP version (4/6): " v
    [[ "$v" != "4" && "$v" != "6" ]] && { echo "Invalid version"; pause_enter; continue; }

    read -rp "How many DNS to list? " count
    [[ "$count" =~ ^[0-9]+$ && "$count" -gt 0 ]] || { echo "Invalid number"; pause_enter; continue; }

    # select pool by country/version
    local -a pool=()
    case "$CNAME-$v" in
      "Saudi Arabia-4") pool=("${SA_GEN_V4[@]}");;
      "Saudi Arabia-6") pool=("${SA_GEN_V6[@]}");;
      "Iran-4")         pool=("${IR_GEN_V4[@]}");;
      "Iran-6")         pool=("${IR_GEN_V6[@]}");;
      "Turkey-4")       pool=("${TR_GEN_V4[@]}");;
      "Turkey-6")       pool=("${TR_GEN_V6[@]}");;
      "Sweden-4")       pool=("${SE_GEN_V4[@]}");;
      "Sweden-6")       pool=("${SE_GEN_V6[@]}");;
      *) echo "Pool not found"; pause_enter; continue;;
    esac

    if ((${#pool[@]}==0)); then
      echo "No DNS available for $CNAME IPv$v"
      pause_enter; continue
    fi

    echo
    echo "Country: $CNAME | IPv$v"
    echo "Listing $count DNS (measured):"
    local i ip rtt
    for ((i=1; i<=count; i++)); do
      ip="${pool[$(( (i-1) % ${#pool[@]} ))]}"
      rtt=$(measure_ping_ms "$ip")
      printf "%3d) %-25s → %s ms\n" "$i" "$ip" "${rtt:-timeout}"
    done

    echo
    echo "Best two right now:"
    pick_two_best_dns "${pool[@]}"

    echo
    footer; pause_enter
  done
}

# ---------- Download DNS (fast/unblocking) ----------
menu_download() {
  while true; do
    clear; title
    echo "===== Download DNS ====="
    echo "0) Auto-pick best two"
    local i=1
    for d in "${DOWNLOAD_DNS[@]}"; do
      printf "%2d) %s\n" "$i" "$d"
      ((i++))
    done
    echo "B) Back"
    read -rp "Choose two numbers (e.g. 3 7) or 0: " a b

    # Back
    [[ "${a^^}" == "B" || "${b^^}" == "B" ]] && return

    # Auto best
    if [[ "$a" == "0" ]]; then
      pick_two_best_dns "${DOWNLOAD_DNS[@]}"
      footer; pause_enter; continue
    fi

    if [[ "$a" =~ ^[0-9]+$ && "$b" =~ ^[0-9]+$ ]]; then
      local n1=$((a-1)) n2=$((b-1))
      if (( n1>=0 && n1<${#DOWNLOAD_DNS[@]} && n2>=0 && n2<${#DOWNLOAD_DNS[@]} )); then
        serve_dns_set "${DOWNLOAD_DNS[$n1]}" "${DOWNLOAD_DNS[$n2]}"
        footer; pause_enter; continue
      fi
    fi

    echo "Invalid choice"; pause_enter
  done
}

# ---------- Main Menu ----------
main_menu() {
  while true; do
    clear; title
    echo "========= Main Menu ========="
    echo "1) Mobile Games"
    echo "2) PC & Console Games"
    echo "3) Search Game"
    echo "4) Generate DNS (KSA / IR / TR / SE)"
    echo "5) Download DNS"
    echo "0) Exit"
    echo "============================="
    read -rp "Pick: " ch
    case "${ch^^}" in
      1) clear; menu_mobile ;;
      2) clear; menu_console ;;
      3) clear; search_game ;;
      4) clear; generate_dns ;;
      5) clear; menu_download ;;
      0) exit 0 ;;
      *) echo "Invalid option"; pause_enter ;;
    esac
  done
}

# ---------- START ----------
main_menu
