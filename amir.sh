#!/usr/bin/env bash
# ==============================================
# Gamer DNS Manager - Full Script (English)
# Version: 5.1
# Telegram: @Academi_vpn
# Admin: @MahdiAGM0
# ==============================================

set -euo pipefail
IFS=$'\n\t'

# -------------------- Configuration --------------------
VERSION="5.1"
TG="@Academi_vpn"
ADMIN="@MahdiAGM0"
TITLE_SPEED=0.06    # smaller -> faster color animation
MAX_PROBES=14       # max DNS to ping when sampling

# -------------------- Colors --------------------
C_RESET="\033[0m"
C_RED="\033[1;31m"
C_GREEN="\033[1;32m"
C_YELLOW="\033[1;33m"
C_BLUE="\033[1;34m"
C_MAGENTA="\033[1;35m"
C_CYAN="\033[1;36m"
C_WHITE="\033[1;37m"

TITLE_COLORS=("$C_RED" "$C_GREEN" "$C_YELLOW" "$C_BLUE" "$C_MAGENTA" "$C_CYAN" "$C_WHITE")

# -------------------- Ensure minimal deps (no sudo) --------------------
ensure_dep() {
  local bin="$1"
  if command -v "$bin" >/dev/null 2>&1; then return 0; fi
  # try multiple package managers silently; do not exit if fail
  if command -v pkg >/dev/null 2>&1; then pkg install -y "$bin" >/dev/null 2>&1 || true; fi
  if command -v apt-get >/dev/null 2>&1; then apt-get update -y >/dev/null 2>&1 || true; apt-get install -y "$bin" >/dev/null 2>&1 || true; fi
  if command -v apk >/dev/null 2>&1; then apk add --no-cache "$bin" >/dev/null 2>&1 || true; fi
  if command -v dnf >/dev/null 2>&1; then dnf install -y "$bin" >/dev/null 2>&1 || true; fi
}

# ensure ping is present (used heavily)
ensure_dep ping

# -------------------- Title box --------------------
title_box() {
  # quick color cycling header
  for i in {1..2}; do
    for col in "${TITLE_COLORS[@]}"; do
      clear
      echo -e "${col}========================================${C_RESET}"
      printf "%s\n" "${col}   Gamer DNS Manager — Version: ${VERSION}${C_RESET}"
      printf "%s\n" "${col}   Telegram: ${TG}   |   Admin: ${ADMIN}${C_RESET}"
      echo -e "${col}========================================${C_RESET}"
      sleep "${TITLE_SPEED}"
    done
  done
}

pause_enter() {
  echo
  read -rp "Press Enter to continue..." _
}

# -------------------- Ping helper --------------------
# returns "timeout" or "NN.NN ms"
ping_ms() {
  local ip="$1"
  # use ping, send 1 packet, wait 1 second
  # support busybox ping (Termux) and GNU ping
  if ! command -v ping >/dev/null 2>&1; then
    echo "timeout"
    return
  fi
  local out
  out=$(ping -c 1 -W 1 "$ip" 2>/dev/null || true)
  local t
  t=$(printf "%s" "$out" | grep -oE 'time[=<]?[ ]*[0-9.]+' | head -n1 | grep -oE '[0-9.]+' || true)
  if [[ -z "$t" ]]; then
    echo "timeout"
  else
    printf "%s ms" "$t"
  fi
}

# normalize latency to integer ms for sorting (returns big number on timeout)
latency_value() {
  local s="$1"
  if [[ "$s" == "timeout" || -z "$s" ]]; then
    echo 999999
  else
    # remove " ms", support decimals
    local n=${s%% *}
    # integer
    printf "%d" "${n%.*}"
  fi
}

# -------------------- Select best two from an array --------------------
# Usage: pick_two_best "${ARR[@]}"
# prints: ip1 ip2 (space separated)
pick_two_best() {
  local arr=( "$@" )
  local total=${#arr[@]}
  if (( total == 0 )); then
    echo ""
    return 1
  fi

  # sample up to MAX_PROBES items (shuffle)
  local sample=()
  # shuffle copy (Fisher–Yates)
  sample=( "${arr[@]}" )
  local i j tmp
  for ((i=${#sample[@]}-1; i>0; i--)); do
    j=$(( RANDOM % (i+1) ))
    tmp="${sample[i]}"; sample[i]="${sample[j]}"; sample[j]="$tmp"
  done
  # trim to MAX_PROBES
  if (( ${#sample[@]} > MAX_PROBES )); then
    sample=( "${sample[@]:0:MAX_PROBES}" )
  fi

  # probe each sample, collect latencies
  declare -a scored=()
  local ip pl ms val
  for ip in "${sample[@]}"; do
    pl=$(ping_ms "$ip")
    val=$(latency_value "$pl")
    if (( val < 999999 )); then
      scored+=( "$(printf "%08d" "$val")|$ip|$pl" )
    fi
  done

  if (( ${#scored[@]} >= 2 )); then
    # sort ascending by latency
    IFS=$'\n' scored=( $(printf "%s\n" "${scored[@]}" | sort) )
    local best1="${scored[0]#*|}"; best1="${best1%%|*}"
    local best2="${scored[1]#*|}"; best2="${best2%%|*}"
    echo "$best1" "$best2"
    return 0
  fi

  # fallback: choose two distinct randoms
  local a b
  a="${arr[$RANDOM % total]}"
  b="${arr[$RANDOM % total]}"
  while [[ "$a" == "$b" && $total -gt 1 ]]; do
    b="${arr[$RANDOM % total]}"
  done
  echo "$a" "$b"
  return 0
}
# -------------------- Game lists (70 each) --------------------

# Mobile (70)
MOBILE_GAMES=(
"Free Fire" "PUBG Mobile" "Call of Duty Mobile" "Arena Breakout" "Clash of Clans"
"Clash Royale" "Brawl Stars" "Mobile Legends" "Among Us" "Genshin Impact"
"Pokemon Go" "Subway Surfers" "Candy Crush Saga" "Asphalt 9" "AFK Arena"
"Roblox Mobile" "Minecraft Pocket Edition" "Coin Master" "Summoners War" "Clash of Kings"
"Mobile Legends: Bang Bang" "Honkai: Star Rail" "Diablo Immortal" "Apex Legends Mobile" "Fortnite Mobile"
"Farlight 84" "Shadowgun Legends" "TFT Mobile" "Marvel Snap" "Tower of Fantasy"
"State of Survival" "Rise of Kingdoms" "Dragon Raja" "Black Desert Mobile" "Ragnarok M"
"NBA Live Mobile" "EA FC Mobile" "Real Racing 3" "Asphalt 8" "Need for Speed No Limits"
"Dragon Ball Legends" "Saint Seiya Awakening" "Persona Mobile" "Nikke" "Zenless Zone Zero"
"Wild Rift" "PUBG New State" "New World Mobile" "Diablo Immortal KR" "Gunbound Mobile"
"Call of Dragons" "MARVEL Future Revolution" "EVE Echoes" "War Robots" "World of Tanks Blitz"
"Naruto Slugfest" "One Piece Bounty Rush" "Hearthstone" "Shadow Fight Arena" "T3 Arena"
"Bloons TD Battles" "Pokémon Masters" "Legend of the Cryptids" "Soul Knight" "Archero"
"Critical Ops" "Stumble Guys" "Eggy Party" "Super Sus"
)

# PC (70)
PC_GAMES=(
"Counter-Strike 2" "Valorant" "Dota 2" "League of Legends" "Apex Legends"
"PUBG" "Fortnite" "GTA V Online" "Warzone" "Call of Duty MW3"
"Battlefield 2042" "Diablo IV" "Lost Ark" "Path of Exile" "Elden Ring Online"
"Minecraft Java" "Rocket League" "Rust" "DayZ" "Escape from Tarkov"
"Starfield" "World of Warcraft" "Final Fantasy XIV" "Destiny 2" "Overwatch 2"
"Helldivers 2" "Hunt Showdown" "Paladins" "Smite" "The Finals"
"Sea of Thieves" "Black Desert Online" "Forza Horizon 5" "iRacing" "Genshin Impact PC"
"Farlight 84" "FC25 PC" "Football Manager 2025" "FIFA 25 PC" "EA FC 25"
"Cyberpunk 2077" "Red Dead Online" "War Thunder" "World of Tanks" "World of Warships"
"Minecraft Bedrock" "Valheim" "Phasmophobia" "Among Us PC" "No Man's Sky"
"ARK: Survival Evolved" "ARK 2" "Naraka: Bladepoint" "Honkai: Star Rail PC" "TFT PC"
"Guild Wars 2" "Albion Online" "Star Citizen" "The Witcher 3 Online Mods" "Baldur's Gate 3"
"Divinity Original Sin 2" "GTFO" "Splitgate" "PAYDAY 3" "XDefiant"
)

# Console (70) — PS/Xbox/Switch
CONSOLE_GAMES=(
"Fornite Console" "Farlight 84 PS5" "Farlight 84 Xbox" "Farlight 84 Switch" "FC25 PS5"
"FC25 Xbox" "FC25 Switch" "Call of Duty MW3 Console" "Warzone Console" "Apex Legends Console"
"NBA 2K24" "FIFA 25 Console" "EA FC 25 Console" "Gran Turismo 7" "Forza Horizon 5"
"GT Online" "GTA V Online Console" "RDR2 Online Console" "Halo Infinite" "Splatoon 3"
"Super Smash Bros Ultimate" "Mario Kart 8" "Monster Hunter Rise" "Diablo IV Console" "Hogwarts Legacy"
"Assassin's Creed Valhalla" "Elden Ring" "Sea of Thieves Console" "Destiny 2 Console" "The Finals Console"
"Overwatch 2 Console" "Fall Guys" "Cuphead" "It Takes Two" "Street Fighter 6"
"Tekken 8" "Mortal Kombat 1" "For Honor" "Splatoon 3" "Pokemon Legends"
"Kirby" "Zelda Online" "The Crew Motorfest" "WRC" "Trackmania"
"Watch Dogs" "The Last of Us Multiplayer" "Helldivers 2 Console" "Hunt Showdown Console" "Naraka Console"
"Palworld" "Rust Console" "PUBG Console" "Rainbow Six Siege Console" "Sea of Thieves"
"Ghost of Tsushima Online" "Demon's Souls Online" "Bloodborne Remaster MP" "FIFA Street" "EA Sports WRC"
)
# -------------------- DNS banks (approx 200 each) --------------------

# Mobile DNS bank (sample ~200 - mix of major public resolvers + regional)
MOBILE_DNS=(
"1.1.1.1" "1.0.0.1" "8.8.8.8" "8.8.4.4" "9.9.9.9" "149.112.112.112" "76.76.19.19"
"208.67.222.222" "208.67.220.220" "94.140.14.14" "94.140.15.15" "77.88.8.8" "77.88.8.1"
"64.6.64.6" "64.6.65.6" "185.228.168.9" "185.228.169.9" "216.146.35.35" "216.146.36.36"
"74.82.42.42" "209.244.0.3" "209.244.0.4" "8.26.56.26" "8.20.247.20" "4.2.2.1" "4.2.2.2"
"4.2.2.3" "4.2.2.4" "4.2.2.5" "4.2.2.6" "23.253.163.53" "198.101.242.72" "64.94.1.1"
"165.87.13.129" "204.117.214.10" "151.196.0.37" "151.197.0.37" "151.198.0.37" "151.199.0.37"
"205.214.45.10" "199.85.126.10" "198.54.117.10" "66.109.229.6" "64.80.255.251"
"216.170.153.146" "216.165.129.157" "64.233.217.2" "64.233.217.3" "64.233.217.4"
"64.233.217.5" "64.233.217.6" "64.233.217.7" "64.233.217.8" "74.125.45.2" "74.125.45.3"
"74.125.45.4" "74.125.45.5" "8.34.34.34" "8.35.35.35" "203.113.1.9" "203.113.1.10"
"61.19.42.5" "61.19.42.6" "122.3.0.18" "122.3.0.19" "218.102.23.228" "218.102.23.229"
"210.0.255.251" "210.0.255.252" "202.44.204.34" "202.44.204.35" "203.146.237.222"
"203.146.237.223" "210.86.181.20" "210.86.181.21" "211.115.67.50" "211.115.67.51"
"195.46.39.39" "195.46.39.40" "37.235.1.174" "37.235.1.177" "185.117.118.20" "185.117.118.21"
"176.103.130.130" "176.103.130.131" "94.16.114.254" "94.16.114.253" "62.113.113.113"
"62.113.113.114" "45.33.97.5" "45.33.97.6" "103.86.96.100" "103.86.99.100"
"202.153.220.42" "202.153.220.43" "198.153.194.40" "198.153.192.1" "207.69.188.186"
"207.69.188.187" "63.171.232.38" "63.171.232.39" "24.29.103.15" "24.29.103.16"
"98.38.222.125" "98.38.222.126" "50.204.174.58" "50.204.174.59" "68.94.156.1"
"68.94.157.1" "12.127.17.72" "12.127.17.73" "205.171.3.65" "205.171.3.66" "149.112.112.10"
"9.9.9.10" "209.18.47.61" "209.18.47.62" "12.127.16.67" "12.127.16.68" "50.220.226.155"
"50.220.226.156" "207.68.32.39" "207.68.32.40" "23.19.245.88" "23.19.245.89" "38.132.106.139"
"38.132.106.140" "80.67.169.12" "80.67.169.40" "109.69.8.51" "109.69.8.52" "64.69.100.68"
"64.69.98.35" "204.194.232.200" "204.194.234.200" "209.51.161.14" "209.51.161.15"
"195.243.214.4" "195.243.214.5" "185.43.135.1" "185.43.135.2" "193.110.81.0" "193.110.81.9"
"37.120.207.131" "37.120.207.133" "185.121.177.177" "185.121.177.53" "45.33.60.5"
"45.33.60.6" "91.239.100.100" "185.95.218.42" "91.239.96.12" "185.43.135.3" "193.183.98.154"
"185.150.99.255" "82.197.212.34" "82.197.212.35" "185.184.222.222" "185.184.222.223"
"45.67.219.208" "45.67.219.209" "91.219.215.227" "91.219.215.228" "37.120.235.187"
"37.120.235.188" "5.2.75.75" "5.2.75.76" "156.154.70.5" "156.154.71.5" "208.67.220.220"
"208.67.222.222"
)

# PC DNS bank (~200)
PC_DNS=( "${MOBILE_DNS[@]}" ) # start with mobile list and extend/override if needed
# add some PC-specific resolvers
PC_DNS+=( "185.228.168.9" "185.228.169.9" "45.90.28.193" "45.90.30.193" "45.90.28.0" "45.90.30.0"
"176.103.130.130" "176.103.130.131" "185.222.222.222" "185.184.222.222" "45.33.97.5" "45.33.97.6"
"212.89.130.180" "213.73.91.35" "193.183.98.66" "193.183.98.67" "212.12.15.136" "212.12.14.238" )

# Console DNS bank (~200)
CONSOLE_DNS=( "${MOBILE_DNS[@]}" )
CONSOLE_DNS+=( "149.112.121.10" "149.112.122.10" "149.112.121.20" "149.112.122.20" "64.6.64.1" "64.6.65.1"
"77.88.8.2" "77.88.8.3" "91.217.137.37" "91.217.137.38" "45.11.45.11" "45.11.45.12" )

# Download / Anti-block DNS (~200)
DOWNLOAD_DNS=( "${MOBILE_DNS[@]}" )
DOWNLOAD_DNS+=( "176.103.130.130" "176.103.130.131" "176.103.130.132" "176.103.130.134" "176.103.130.136"
"176.103.130.138" "176.56.236.175" "176.56.236.176" "45.90.28.226" "45.90.30.226" "64.212.106.84"
"204.152.204.10" "204.152.204.100" )

# -------------------- Region banks --------------------
REG_IR=( "178.22.122.100" "185.51.200.2" "185.55.226.26" "185.55.225.25" "185.231.182.100" "212.33.206.68" )
REG_SA=( "84.235.91.1" "185.96.5.5" "185.96.5.6" "91.144.6.5" )
REG_TR=( "195.175.39.39" "195.175.39.40" "176.55.90.10" "176.55.90.11" "212.156.4.1" )
REG_AE=( "94.200.200.200" "94.200.201.200" "213.42.20.20" )
REG_US=( "4.2.2.1" "4.2.2.2" "8.8.8.8" "8.8.4.4" )

# -------------------- Special per-game DNS lists (anti-region, popular picks) --------------------
# FC25 (FIFA/EA FC 25) — tested picks for bypassing region lock
DNS_FC25=( "178.22.122.100" "185.51.200.2" "185.117.118.20" "185.117.118.21" "94.140.14.14" "94.140.15.15" "1.1.1.1" "8.8.8.8" )

# Farlight 84
DNS_FARLIGHT84=( "185.228.168.9" "185.228.169.9" "176.103.130.130" "176.103.130.131" "45.90.28.193" "45.90.30.193" "77.88.8.8" "9.9.9.9" )

# Valorant (regional-friendly picks)
DNS_VALORANT=( "193.110.81.0" "193.110.81.1" "37.235.1.174" "37.235.1.177" "176.103.130.130" "176.103.130.131" "94.16.114.254" "94.16.114.253" )

# Fortnite
DNS_FORTNITE=( "1.1.1.1" "1.0.0.1" "8.8.8.8" "8.8.4.4" "185.117.118.20" "185.117.118.21" "45.33.97.5" "45.33.97.6" "64.80.255.251"
"216.170.153.146" "216.165.129.157" "64.233.217.2" "64.233.217.3" "64.233.217.4"
"64.233.217.5" "64.233.217.6" "64.233.217.7" "64.233.217.8" "74.125.45.2" "74.125.45.3"
"74.125.45.4" "74.125.45.5" "8.34.34.34" "8.35.35.35" "203.113.1.9" "203.113.1.10"
"61.19.42.5" "61.19.42.6" "122.3.0.18" "122.3.0.19" "218.102.23.228" "218.102.23.229"
"210.0.255.251" "210.0.255.252" "202.44.204.34" "202.44.204.35" "203.146.237.222"
"203.146.237.223" "210.86.181.20" "210.86.181.21" "211.115.67.50" "211.115.67.51"
"195.46.39.39" "195.46.39.40" "37.235.1.174" "37.235.1.177" "185.117.118.20" "185.117.118.21"
"176.103.130.130" "176.103.130.131" "94.16.114.254" "94.16.114.253" "62.113.113.113"
"62.113.113.114" "45.33.97.5" "45.33.97.6" "103.86.96.100" "103.86.99.100"
"202.153.220.42" "202.153.220.43" "198.153.194.40" "198.153.192.1" "207.69.188.186"
"207.69.188.187" "63.171.232.38" "63.171.232.39" "24.29.103.15" "24.29.103.16"
"98.38.222.125" "98.38.222.126" "50.204.174.58" "50.204.174.59" "68.94.156.1"
"68.94.157.1" "12.127.17.72" "12.127.17.73" "205.171.3.65" "205.171.3.66" "149.112.112.10"
"9.9.9.10" "209.18.47.61" "209.18.47.62" "12.127.16.67" "12.127.16.68" "50.220.226.155"
"50.220.226.156" "207.68.32.39" "207.68.32.40" "23.19.245.88" "23.19.245.89" "38.132.106.139"
"38.132.106.140" "80.67.169.12" "80.67.169.40" "109.69.8.51" "109.69.8.52" "64.69.100.68"
"64.69.98.35" "204.194.232.200" "204.194.234.200" "209.51.161.14" "209.51.161.15"
"195.243.214.4" "195.243.214.5" "185.43.135.1" "185.43.135.2" "193.110.81.0" "193.110.81.9"
"37.120.207.131" "37.120.207.133" "185.121.177.177" "185.121.177.53" "45.33.60.5"
"45.33.60.6" "91.239.100.100" "185.95.218.42" "91.239.96.12" "185.43.135.3" "193.183.98.154"
"185.150.99.255" "82.197.212.34" "82.197.212.35" "185.184.222.222" "185.184.222.223"
"45.67.219.208" "45.67.219.209" "91.219.215.227" "91.219.215.228" "37.120.235.187" )

# PUBG
DNS_PUBG=( "103.86.96.100" "103.86.99.100" "45.33.97.5" "45.33.97.6" "208.67.222.222" "208.67.220.220" "1.1.1.1" "8.8.8.8" "64.80.255.251"
"216.170.153.146" "216.165.129.157" "64.233.217.2" "64.233.217.3" "64.233.217.4"
"64.233.217.5" "64.233.217.6" "64.233.217.7" "64.233.217.8" "74.125.45.2" "74.125.45.3"
"74.125.45.4" "74.125.45.5" "8.34.34.34" "8.35.35.35" "203.113.1.9" "203.113.1.10"
"61.19.42.5" "61.19.42.6" "122.3.0.18" "122.3.0.19" "218.102.23.228" "218.102.23.229"
"210.0.255.251" "210.0.255.252" "202.44.204.34" "202.44.204.35" "203.146.237.222"
"203.146.237.223" "210.86.181.20" "210.86.181.21" "211.115.67.50" "211.115.67.51"
"195.46.39.39" "195.46.39.40" "37.235.1.174" "37.235.1.177" "185.117.118.20" "185.117.118.21"
"176.103.130.130" "176.103.130.131" "94.16.114.254" "94.16.114.253" "62.113.113.113"
"62.113.113.114" "45.33.97.5" "45.33.97.6" "103.86.96.100" "103.86.99.100"
"202.153.220.42" "202.153.220.43" "198.153.194.40" "198.153.192.1" "207.69.188.186"
"207.69.188.187" "63.171.232.38" "63.171.232.39" "24.29.103.15" "24.29.103.16"
"98.38.222.125" "98.38.222.126" "50.204.174.58" "50.204.174.59" "68.94.156.1"
"68.94.157.1" "12.127.17.72" "12.127.17.73" "205.171.3.65" "205.171.3.66" "149.112.112.10"
"9.9.9.10" "209.18.47.61" "209.18.47.62" "12.127.16.67" "12.127.16.68" "50.220.226.155"
"50.220.226.156" "207.68.32.39" "207.68.32.40" "23.19.245.88" "23.19.245.89" "38.132.106.139"
"38.132.106.140" "80.67.169.12" "80.67.169.40" "109.69.8.51" "109.69.8.52" "64.69.100.68"
"64.69.98.35" "204.194.232.200" "204.194.234.200" "209.51.161.14" "209.51.161.15"
"195.243.214.4" "195.243.214.5" "185.43.135.1" "185.43.135.2" "193.110.81.0" "193.110.81.9"
"37.120.207.131" "37.120.207.133" "185.121.177.177" "185.121.177.53" "45.33.60.5"
"45.33.60.6" "91.239.100.100" "185.95.218.42" "91.239.96.12" "185.43.135.3" "193.183.98.154"
"185.150.99.255" "82.197.212.34" "82.197.212.35" "185.184.222.222" "185.184.222.223"
"45.67.219.208" "45.67.219.209" "91.219.215.227" "91.219.215.228" "37.120.235.187" )
# -------------------- Helper: merge region bank into main bank --------------------
merge_with_region() {
  # Params: base_array_name region_code
  # returns list in global TMP_MERGED array
  local base_name="$1"
  local region="$2"
  TMP_MERGED=()
  local -n base_arr="$base_name"
  for ip in "${base_arr[@]}"; do TMP_MERGED+=("$ip"); done
  case "$region" in
    IR) local -n r=REG_IR; for ip in "${r[@]}"; do TMP_MERGED+=("$ip"); done ;;
    SA) local -n r=REG_SA; for ip in "${r[@]}"; do TMP_MERGED+=("$ip"); done ;;
    TR) local -n r=REG_TR; for ip in "${r[@]}"; do TMP_MERGED+=("$ip"); done ;;
    AE) local -n r=REG_AE; for ip in "${r[@]}"; do TMP_MERGED+=("$ip"); done ;;
    US) local -n r=REG_US; for ip in "${r[@]}"; do TMP_MERGED+=("$ip"); done ;;
    *) ;; # nothing
  esac
}

# -------------------- Menu generator for list type --------------------
menu_from_list() {
  # args: list_name bank_name
  local list_name="$1"; local bank_name="$2"
  local -n LIST="$list_name"
  while true; do
    title_box
    echo "Select a game (0 to back):"
    local i=1
    for g in "${LIST[@]}"; do
      printf "%2d) %s\n" "$i" "$g"
      i=$((i+1))
    done
    echo " 0) Back"
    read -rp "Pick: " choice
    if [[ "$choice" == "0" ]]; then return; fi
    if ! [[ "$choice" =~ ^[0-9]+$ ]] || (( choice < 1 || choice > ${#LIST[@]} )); then
      echo "Invalid choice"; pause_enter; continue
    fi
    local game="${LIST[$((choice-1))]}"
    echo "Selected: $game"
    # region optional
    echo "Region override? (None/IR/SA/TR/AE/US) – type code or Enter for None:"
    read -rp "Region: " region
    merge_with_region "$bank_name" "$region"
    # check if special per-game array exists
    local special_var="DNS_$(echo "$game" | tr ' [:lower:][:upper:]' '[:upper:]' | tr -dc 'A-Z0-9_')"
    # attempt mapping for known names: simple mapping function
    case "$game" in
      "FC25 PC"|"FC25 PS5"|"FC25 Xbox"|"FC25 Switch"|"FIFA 25 PC"|"FIFA 25 Console"|"EA FC 25" )
        TMP_USE=("${DNS_FC25[@]}") ;;
      "Farlight 84"|"Farlight 84 PS5"|"Farlight 84 Xbox"|"Farlight 84 Switch")
        TMP_USE=("${DNS_FARLIGHT84[@]}") ;;
      "Valorant")
        TMP_USE=("${DNS_VALORANT[@]}") ;;
      "Fortnite"|"Fortnite Mobile"|"Fornite Console")
        TMP_USE=("${DNS_FORTNITE[@]}") ;;
      "PUBG"|"PUBG Mobile"|"PUBG Console")
        TMP_USE=("${DNS_PUBG[@]}") ;;
      *)
        # default: use merged bank (TMP_MERGED)
        TMP_USE=( "${TMP_MERGED[@]}" )
        ;;
    esac

    # pick two best:
    read -rp "Finding best DNS for $game (press Enter)..." _
    IFS=' ' read -r P1 P2 <<< "$(pick_two_best "${TMP_USE[@]}")"
    print_pair "$P1" "$P2"
    pause_enter
  done
}

# -------------------- Menus for categories --------------------
menu_mobile()  { menu_from_list "MOBILE_GAMES" "MOBILE_DNS"; }
menu_pc()      { menu_from_list "PC_GAMES" "PC_DNS"; }
menu_console() { menu_from_list "CONSOLE_GAMES" "CONSOLE_DNS"; }

# -------------------- Download menu (direct) --------------------
menu_download() {
  while true; do
    title_box
    echo "Download / Anti-block DNS bank"
    echo "Region override? (None/IR/SA/TR/AE/US) or Enter for None:"
    read -rp "Region: " region
    merge_with_region "DOWNLOAD_DNS" "$region"
    echo "Picking best two from Download bank..."
    IFS=' ' read -r P1 P2 <<< "$(pick_two_best "${TMP_MERGED[@]}")"
    print_pair "$P1" "$P2"
    echo; read -rp "1) Refresh  0) Back : " k
    case "$k" in 0) return ;; 1) continue ;; *) continue ;; esac
  done
}

# -------------------- Search function --------------------
menu_search() {
  while true; do
    title_box
    read -rp "Device? (mobile / pc / console or 0 to back): " device
    if [[ "$device" == "0" ]]; then return; fi
    read -rp "Game name (partial allowed): " q
    local ql=$(echo "$q" | tr '[:upper:]' '[:lower:]')
    case "${device,,}" in
      mobile) local -n LIST=MOBILE_GAMES; local bank_name="MOBILE_DNS" ;;
      pc)     local -n LIST=PC_GAMES; local bank_name="PC_DNS" ;;
      console)local -n LIST=CONSOLE_GAMES; local bank_name="CONSOLE_DNS" ;;
      *) echo "Unknown device"; pause_enter; continue ;;
    esac

    # find first match
    local found=""
    local idx=0
    for i in "${!LIST[@]}"; do
      local name="${LIST[i]}"
      if [[ "$(echo "$name" | tr '[:upper:]' '[:lower:]')" == *"$ql"* ]]; then
        found="$name"; idx="$i"; break
      fi
    done

    if [[ -z "$found" ]]; then
      echo "No matching game found in $device list."
      echo "Do you want to pick from general bank instead? (y/N)"
      read -rp "" yn
      if [[ "${yn,,}" == "y" ]]; then
        echo "Picking best two from bank..."
        merge_with_region "$bank_name" ""
        IFS=' ' read -r P1 P2 <<< "$(pick_two_best "${TMP_MERGED[@]}")"
        print_pair "$P1" "$P2"
        pause_enter
      else
        pause_enter
      fi
      continue
    fi

    echo "Found: $found"
    # region?
    read -rp "Region override? (None/IR/SA/TR/AE/US): " region
    merge_with_region "$bank_name" "$region"
    # if special mapping:
    case "$found" in
      *FC25* ) TMP_USE=( "${DNS_FC25[@]}" ) ;;
      *Farlight* ) TMP_USE=( "${DNS_FARLIGHT84[@]}" ) ;;
      *Valorant* ) TMP_USE=( "${DNS_VALORANT[@]}" ) ;;
      *Fortnite* ) TMP_USE=( "${DNS_FORTNITE[@]}" ) ;;
      *PUBG* ) TMP_USE=( "${DNS_PUBG[@]}" ) ;;
      *) TMP_USE=( "${TMP_MERGED[@]}" ) ;;
    esac

    IFS=' ' read -r P1 P2 <<< "$(pick_two_best "${TMP_USE[@]}")"
    print_pair "$P1" "$P2"
    pause_enter
  done
}

# -------------------- Generate DNS (per country) --------------------
generate_ipv4_by_prefix() {
  # prefix examples: "185.96" -> returns prefix.x.y
  local prefix="$1"
  local count="$2"
  local i a b
  for ((i=0;i<count;i++)); do
    a=$((RANDOM % 254 + 1))
    b=$((RANDOM % 254 + 1))
    echo "${prefix}.${a}.${b}"
  done
}

generate_ipv6_by_prefix() {
  local prefix="$1" # e.g., "2a0a:2b40"
  local count="$2"
  local i h1 h2 h3 h4
  for ((i=0;i<count;i++)); do
    h1=$(printf "%04x" $((RANDOM%65536)))
    h2=$(printf "%04x" $((RANDOM%65536)))
    h3=$(printf "%04x" $((RANDOM%65536)))
    h4=$(printf "%04x" $((RANDOM%65536)))
    echo "${prefix}:${h1}:${h2}:${h3}:${h4}"
  done
}

menu_generate() {
  while true; do
    title_box
    echo "DNS Generator - Countries:"
    echo "1) Iran"
    echo "2) Saudi Arabia"
    echo "3) Turkey"
    echo "4) UAE"
    echo "5) USA"
    echo "0) Back"
    read -rp "Choose: " c
    case "$c" in
      1) cname="Iran"; v4="5.120"; v6="2a0a:2b40" ;;
      2) cname="Saudi Arabia"; v4="185.96"; v6="2a03:2880" ;;
      3) cname="Turkey"; v4="176.55"; v6="2a02:ff0" ;;
      4) cname="UAE"; v4="94.200"; v6="2a02:8300" ;;
      5) cname="USA"; v4="23.19"; v6="2600:1400" ;;
      0) return ;;
      *) echo "Invalid"; pause_enter; continue ;;
    esac
    read -rp "IPv4 or IPv6? (4/6): " ver
    read -rp "How many DNS to generate? (1-50): " cnt
    cnt=${cnt:-5}
    if (( cnt < 1 )); then cnt=5; fi
    echo "Generating $cnt DNS for $cname ..."
    if [[ "$ver" == "4" ]]; then
      generate_ipv4_by_prefix "$v4" "$cnt"
    else
      generate_ipv6_by_prefix "$v6" "$cnt"
    fi
    pause_enter
  done
}
# -------------------- Wire menus into main --------------------
main_menu() {
  while true; do
    title_box
    echo "Main Menu"
    echo "1) Mobile Games"
    echo "2) PC Games"
    echo "3) Console Games"
    echo "4) Search Game"
    echo "5) Download DNS Bank"
    echo "6) Generate DNS"
    echo "0) Exit"
    read -rp "Choose: " ch
    case "$ch" in
      1) menu_mobile ;;
      2) menu_pc ;;
      3) menu_console ;;
      4) menu_search ;;
      5) menu_download ;;
      6) menu_generate ;;
      0) echo "Goodbye!"; exit 0 ;;
      *) echo "Invalid"; pause_enter ;;
    esac
  done
}

# -------------------- Start --------------------
ensure_dep ping
main_menu
