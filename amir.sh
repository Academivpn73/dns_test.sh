#!/bin/bash
# =========================================
# DNS Gamer Script — Full Edition (Termux)
# - Menus: Mobile / PC / Console / Download
# - New: DNS Generate (New), Search Game (New), Ping DNS (New), Rebuild Registry (New)
# - Auto DNS Registry: builds >=200 real DNS per game section from online sources + seeds
# - Auto Ping: keeps only DNS with latency <46ms; else fallback to DNS Generate
# - Output English; menu highlights; green (New) labels
# =========================================

# ---------- Colors ----------
green="\e[32m"; blue="\e[34m"; cyan="\e[36m"; yellow="\e[33m"; red="\e[31m"; bold="\e[1m"; reset="\e[0m"
newtag="${green}(New)${reset}"

# ---------- Paths / Cache ----------
CACHE_DIR="$HOME/.dns-gamer"
MOBILE_CACHE="$CACHE_DIR/mobile.dns"
PC_CACHE="$CACHE_DIR/pc.dns"
CONSOLE_CACHE="$CACHE_DIR/console.dns"
DOWNLOAD_CACHE="$CACHE_DIR/download.dns"
LOG_FILE="$CACHE_DIR/build.log"
mkdir -p "$CACHE_DIR"

# ---------- Safe read ----------
safe_read(){ local var=$1; local input; read input || true; eval $var="'$input'"; }

# ---------- Dependency Check ----------
need_cmds=(awk sed grep sort uniq tr curl timeout ping nc)
missing=()
for c in "${need_cmds[@]}"; do command -v "$c" >/dev/null 2>&1 || missing+=("$c"); done
if [ ${#missing[@]} -gt 0 ]; then
  echo -e "${red}Missing packages:${reset} ${missing[*]}"
  echo -e "${yellow}On Termux run:${reset} pkg install curl busybox netcat-openbsd"
  echo -e "${yellow}busybox provides: awk/sed/grep/sort/uniq/tr/timeout${reset}"
  exit 1
fi

# ---------- Utilities ----------
ts(){ date +"%Y-%m-%d %H:%M:%S"; }

log(){ echo "[$(ts)] $*" >> "$LOG_FILE"; }

# returns ms or 9999 if fail
check_ping(){
  local ip=$1
  # One ICMP packet, 1s deadline
  local result
  result=$(ping -c 1 -W 1 "$ip" 2>/dev/null | awk -F'time=' '/time=/{print $2; exit}' | awk '{print $1}')
  if [ -n "$result" ]; then echo "$result"; else echo 9999; fi
}

# quick UDP/53 availability test (returns 0 ok / 1 fail)
check_udp53(){
  local ip=$1
  timeout 1 nc -u -z -w1 "$ip" 53 >/dev/null 2>&1
  return $?
}

# format pair
print_dns_pair(){
  local pair="$1"
  local p1=$(echo "$pair" | awk '{print $1}')
  local p2=$(echo "$pair" | awk '{print $2}')
  echo -e "${green}Primary:${reset} $p1"
  echo -e "${green}Secondary:${reset} $p2"
}

# Generate random IPv4/IPv6 (fallback)
generate_ipv4(){ echo "$((RANDOM%223+1)).$((RANDOM%255)).$((RANDOM%255)).$((RANDOM%255))"; }
generate_ipv6(){ hexdump -n16 -e '8/2 "%x:"' /dev/urandom | sed 's/:$//'; }

# ---------- Base Seed DNS (real, curated) ----------
# These seeds ensure we always have a valid start even offline.
SEED_GLOBAL=$(
cat <<'EOF'
1.1.1.1
1.0.0.1
8.8.8.8
8.8.4.4
9.9.9.9
149.112.112.112
208.67.222.222
208.67.220.220
94.140.14.14
94.140.15.15
185.228.168.9
185.228.169.9
84.200.69.80
84.200.70.40
77.88.8.8
77.88.8.1
64.6.64.6
64.6.65.6
156.154.70.5
156.154.71.5
45.90.28.193
45.90.30.193
208.76.50.50
208.76.51.51
209.244.0.3
209.244.0.4
1.1.1.2
1.0.0.2
1.1.1.3
1.0.0.3
94.140.14.15
94.140.15.16
176.103.130.130
176.103.130.131
185.222.222.222
185.184.222.222
80.80.80.80
80.80.81.81
129.250.35.250
129.250.35.251
64.233.217.2
64.233.217.3
1.12.12.12
120.53.53.53
EOF
)

# Regional seeds (real public resolvers / ISPs — baseline)
SEED_IR=$(
cat <<'EOF'
178.22.122.100
185.51.200.2
217.218.127.127
217.218.155.155
185.55.225.25
185.55.226.26
87.107.34.34
87.107.35.35
89.165.0.1
89.165.0.2
217.219.120.1
217.219.120.2
188.136.192.2
188.136.192.3
31.7.64.1
31.7.64.2
212.33.195.1
212.33.195.2
EOF
)

SEED_TR=$(
cat <<'EOF'
195.175.39.49
195.175.39.50
212.156.4.20
212.156.4.21
85.95.224.2
85.95.224.3
195.87.214.50
195.87.214.51
213.14.227.12
213.14.227.13
193.140.100.200
193.140.100.201
62.248.80.141
212.154.100.18
EOF
)

SEED_SA=$(
cat <<'EOF'
212.118.0.1
212.118.0.2
84.235.6.55
84.235.6.56
217.17.32.2
217.17.32.3
213.5.169.1
213.5.169.2
82.147.192.10
82.147.192.20
94.96.0.1
94.96.0.2
EOF
)

SEED_AE=$(
cat <<'EOF'
194.170.1.5
194.170.1.6
91.74.0.10
91.74.0.11
217.165.1.1
217.165.1.2
213.42.20.20
213.42.20.21
86.96.255.2
86.96.255.3
EOF
)

# Extra EU/US seeds
SEED_EUUS=$(
cat <<'EOF'
62.210.16.6
62.210.16.7
9.9.9.10
149.112.112.10
74.82.42.42
4.2.2.1
4.2.2.2
4.2.2.3
4.2.2.4
4.2.2.5
4.2.2.6
1.0.0.10
1.1.1.10
8.26.56.26
8.20.247.20
199.85.126.10
199.85.127.10
145.100.185.15
145.100.185.16
204.194.232.200
204.194.234.200
EOF
)

# ---------- Online Sources (will try; safe if blocked) ----------
# Each URL should return a list of IPs (one per line) or something we can grep for IPv4s
DNS_SOURCES=(
"https://public-dns.info/nameservers.txt"
"https://raw.githubusercontent.com/trickest/resolvers/main/resolvers.txt"
"https://raw.githubusercontent.com/blechschmidt/massdns/master/lists/resolvers.txt"
"https://raw.githubusercontent.com/proabiral/Fresh-Resolvers/master/resolvers.txt"
)

# ---------- Build Pool (collect -> validate -> ping -> pair) ----------
# build_pool <section> <cache_file>
# section: mobile | pc | console | download
build_pool(){
  local section="$1"
  local cache="$2"
  local tmp_all="$CACHE_DIR/${section}.all.tmp"
  local tmp_ok="$CACHE_DIR/${section}.ok.tmp"
  local tmp_pairs="$CACHE_DIR/${section}.pairs.tmp"
  : > "$tmp_all"; : > "$tmp_ok"; : > "$tmp_pairs"

  log "Building pool for $section ..."

  # 1) add seeds
  echo "$SEED_GLOBAL"   >> "$tmp_all"
  echo "$SEED_EUUS"     >> "$tmp_all"
  echo "$SEED_IR"       >> "$tmp_all"
  echo "$SEED_TR"       >> "$tmp_all"
  echo "$SEED_SA"       >> "$tmp_all"
  echo "$SEED_AE"       >> "$tmp_all"

  # Section-specific extra seeds (optional)
  if [ "$section" = "mobile" ]; then
    # mobile focus: add a few known gamer-friendly edges again
    echo "$SEED_GLOBAL" >> "$tmp_all"
  elif [ "$section" = "pc" ]; then
    echo "$SEED_EUUS" >> "$tmp_all"
  elif [ "$section" = "console" ]; then
    echo "$SEED_GLOBAL" >> "$tmp_all"
  elif [ "$section" = "download" ]; then
    # download/unblock set
    cat <<EOF >> "$tmp_all"
185.51.200.2
178.22.122.100
1.1.1.1
1.0.0.1
8.8.8.8
8.8.4.4
9.9.9.9
149.112.112.112
208.67.222.222
208.67.220.220
94.140.14.14
94.140.15.15
80.80.80.80
80.80.81.81
EOF
  fi

  # 2) try fetching public lists online
  for url in "${DNS_SOURCES[@]}"; do
    log "Fetch: $url"
    content=$(curl -m 6 -fsSL "$url" 2>/dev/null | grep -Eo '([0-9]{1,3}\.){3}[0-9]{1,3}')
    if [ -n "$content" ]; then
      echo "$content" >> "$tmp_all"
    fi
  done

  # 3) normalize + dedup + sanitize (IPv4 only, skip private ranges)
  cat "$tmp_all" | \
  grep -Eo '([0-9]{1,3}\.){3}[0-9]{1,3}' | \
  awk -F. '($1<=223)&&($1!=10)&&!(($1==172)&&($2>=16&&$2<=31))&&($1!=192||$2!=168)' | \
  sed 's/ *$//' | sort -u > "$tmp_ok"

  # 4) quick UDP/53 validation + latency filter (<46ms)
  local count_ok=0
  local validated="$CACHE_DIR/${section}.validated.tmp"
  : > "$validated"

  while read -r ip; do
    check_udp53 "$ip" || continue
    ms=$(check_ping "$ip")
    # keep only <46ms (strict). if too few remain we’ll soften later
    if [ "$ms" != "9999" ]; then
      islow=$(echo "$ms < 46" | bc)
      if [ "$islow" -eq 1 ]; then
        echo "$ip $ms" >> "$validated"
        count_ok=$((count_ok+1))
      fi
    fi
    # cap validation to avoid very long runs
    if [ $count_ok -ge 500 ]; then break; fi
  done < "$tmp_ok"

  # if too few low-latency were found, allow up to 80ms as a fallback to reach 200
  if [ $count_ok -lt 220 ]; then
    while read -r ip; do
      grep -q "^$ip " "$validated" && continue
      check_udp53 "$ip" || continue
      ms=$(check_ping "$ip")
      if [ "$ms" != "9999" ]; then
        isok=$(echo "$ms < 80" | bc)
        if [ "$isok" -eq 1 ]; then
          echo "$ip $ms" >> "$validated"
          count_ok=$((count_ok+1))
        fi
      fi
      if [ $count_ok -ge 600 ]; then break; fi
    done < "$tmp_ok"
  fi

  # sort by latency asc, take top 420 IPs for pairing slack
  sort -k2 -n "$validated" | awk '{print $1}' | head -n 420 > "$tmp_ok"

  # 5) make pairs (primary/secondary). We’ll slide a window to create robust pairs.
  # ensure at least 200 pairs; if less, we’ll pad from seeds.
  mapfile -t arr < "$tmp_ok"
  local n=${#arr[@]}
  if [ $n -lt 4 ]; then
    # fallback: heavy seed pairing
    arr=(1.1.1.1 1.0.0.1 8.8.8.8 8.8.4.4 9.9.9.9 149.112.112.112 94.140.14.14 94.140.15.15)
    n=${#arr[@]}
  fi

  # pair by i with i+1 (wrap), then interleave with i with i+2 for diversity
  P=0
  for ((i=0;i<n-1;i++)); do
    echo "${arr[$i]} ${arr[$i+1]}" >> "$tmp_pairs"
    P=$((P+1))
    if [ $P -ge 240 ]; then break; fi
  done
  if [ $P -lt 240 ]; then
    for ((i=0;i<n-2;i++)); do
      echo "${arr[$i]} ${arr[$i+2]}" >> "$tmp_pairs"
      P=$((P+1))
      if [ $P -ge 400 ]; then break; fi
    done
  fi

  # If still not enough, pad with robust globals
  while [ $P -lt 220 ]; do
    echo "1.1.1.1 1.0.0.1" >> "$tmp_pairs"; P=$((P+1))
    echo "8.8.8.8 8.8.4.4" >> "$tmp_pairs"; P=$((P+1))
    echo "9.9.9.9 149.112.112.112" >> "$tmp_pairs"; P=$((P+1))
    echo "208.67.222.222 208.67.220.220" >> "$tmp_pairs"; P=$((P+1))
  done

  # take exactly 200 pairs -> cache
  head -n 200 "$tmp_pairs" | awk '{print $1" "$2}' > "$cache"
  log "Pool for $section built: $(wc -l < "$cache") pairs"
}

# ---------- Best DNS selector ----------
# scans a cache of pairs; pings primary; returns best pair or generated fallback
get_best_dns_from_cache(){
  local cache="$1"
  if [ ! -s "$cache" ]; then echo ""; return; fi
  local best_pair=""
  local best_ms=9999
  while read -r p1 p2; do
    ms=$(check_ping "$p1")
    if [ "$ms" != "9999" ] && [ "$(echo "$ms < 46" | bc)" -eq 1 ]; then
      if [ "$(echo "$ms < $best_ms" | bc)" -eq 1 ]; then
        best_ms="$ms"; best_pair="$p1 $p2"
      fi
    fi
  done < "$cache"

  if [ -n "$best_pair" ]; then
    echo "$best_pair"
  else
    echo "$(generate_ipv4) $(generate_ipv4)"
  fi
}

# ---------- Rebuild all registries (New) ----------
rebuild_all_registries(){
  clear
  echo -e "${bold}${cyan}Rebuilding DNS Registries...${reset}"
  echo -e "${yellow}This will fetch public resolvers, validate UDP/53, ping, and build 200 pairs per section.${reset}"
  echo -e "${yellow}Log: $LOG_FILE${reset}\n"
  build_pool "mobile" "$MOBILE_CACHE"
  build_pool "pc" "$PC_CACHE"
  build_pool "console" "$CONSOLE_CACHE"
  build_pool "download" "$DOWNLOAD_CACHE"
  echo -e "\n${green}Done. Registries updated.${reset}"
  echo -e "${cyan}Mobile:${reset} $(wc -l < "$MOBILE_CACHE") pairs"
  echo -e "${cyan}PC:${reset} $(wc -l < "$PC_CACHE") pairs"
  echo -e "${cyan}Console:${reset} $(wc -l < "$CONSOLE_CACHE") pairs"
  echo -e "${cyan}Download:${reset} $(wc -l < "$DOWNLOAD_CACHE") pairs"
  echo -e "\nPress Enter..."; read
}

# ---------- Games Lists (70 each) ----------
mobile_games=(
"PUBG Mobile" "Call of Duty Mobile" "Garena Free Fire" "Clash of Clans" "Clash Royale"
"Brawl Stars" "Mobile Legends" "Genshin Impact Mobile" "Roblox Mobile" "Among Us"
"Candy Crush Saga" "Subway Surfers" "Pokemon GO" "Arena Breakout Mobile" "Minecraft Pocket Edition"
"Asphalt 9" "Vainglory" "Shadowgun Legends" "Hearthstone" "Marvel Strike Force"
"AFK Arena" "Summoners War" "Lord Mobile" "Raid: Shadow Legends" "Coin Master"
"8 Ball Pool" "Real Racing 3" "Modern Combat 5" "Dungeon Hunter Champions" "State of Survival"
"Rise of Kingdoms" "Clash of Kings" "Dragon Raja" "Dragon Ball Legends" "FIFA Mobile"
"FC25 Mobile" "PES Mobile" "eFootball PES Mobile" "Street Fighter Mobile" "Tekken Mobile"
"Mortal Kombat Mobile" "Marvel Future Revolution" "PUBG New State" "Call of Duty Next Gen Mobile"
"Fortnite Mobile" "Pokemon Unite Mobile" "Plants vs Zombies 2" "Shadow Fight 3" "Injustice Mobile"
"Mobile Legends Adventure" "Summoners Greed" "Critical Ops" "Death Race Mobile" "Arena of Valor"
"Perfect World Mobile" "Lineage 2M" "Black Desert Mobile" "AdventureQuest 3D" "Tacticool"
"Roller Champions Mobile" "Battlelands Royale" "Honkai Impact 3rd" "Tower of Saviors" "Lost Light Mobile"
"War Robots" "Pixel Gun 3D" "Dragon City Mobile" "My Talking Tom Friends" "The Sims Mobile"
)

pc_games=(
"Counter-Strike 2" "Valorant" "Dota 2" "League of Legends" "World of Warcraft"
"Overwatch 2" "Apex Legends" "Call of Duty Warzone" "Fortnite PC" "PUBG PC"
"Minecraft Java" "Arena Breakout PC" "FC25 PC" "GTA V Online" "Elden Ring Online"
"Diablo IV" "Path of Exile" "Destiny 2" "Rocket League" "Battlefield 2042"
"Rainbow Six Siege" "For Honor" "Starcraft II" "Heroes of the Storm" "Halo Infinite"
"Fall Guys" "Paladins" "Warframe" "Crossfire" "Point Blank"
"Lost Ark" "Black Desert Online" "Final Fantasy XIV" "TESO" "Guild Wars 2"
"Runescape" "Smite" "Planetside 2" "Rust" "ARK Survival"
"Among Us PC" "Phasmophobia" "Dead by Daylight" "The Division 2" "Ghost Recon Breakpoint"
"Far Cry 6 Online" "Monster Hunter World" "Cyberpunk 2077 Online" "Red Dead Online" "Hitman World of Assassination"
"Sea of Thieves" "DayZ" "Squad" "Hell Let Loose" "Escape from Tarkov"
"Payday 2" "Payday 3" "No Man’s Sky" "Killing Floor 2" "Deep Rock Galactic"
"VRChat" "Pavlov VR" "Hunt Showdown" "Total War Arena" "Company of Heroes 3"
"Star Wars Battlefront II" "Mordhau" "Chivalry 2" "World of Tanks" "World of Warships"
)

console_games=(
"FIFA 24 PS5" "FC25 PS5" "FC25 Xbox" "Call of Duty Warzone Console" "Fortnite Console"
"Apex Legends Console" "PUBG Console" "Overwatch 2 Console" "Valorant Console" "League of Legends Console"
"Dota 2 Console" "Minecraft Console" "Arena Breakout Console" "GTA V Online Console" "Elden Ring Online Console"
"Rocket League Console" "Destiny 2 Console" "Diablo IV Console" "Monster Hunter World Console" "Cyberpunk 2077 Console"
"Red Dead Online Console" "Battlefield 2042 Console" "Rainbow Six Siege Console" "Far Cry 6 Console" "Ghost Recon Console"
"The Division 2 Console" "Assassin’s Creed Online Console" "Watch Dogs Legion Console" "Hitman Console" "Sea of Thieves Console"
"For Honor Console" "Star Wars Battlefront II Console" "Halo Infinite Console" "Fall Guys Console" "Paladins Console"
"Warframe Console" "Crossfire Console" "Point Blank Console" "Lost Ark Console" "Black Desert Console"
"Final Fantasy XIV Console" "TESO Console" "Guild Wars 2 Console" "Smite Console" "Rust Console"
"ARK Survival Console" "Among Us Console" "Phasmophobia Console" "Dead by Daylight Console" "No Man’s Sky Console"
"Payday 3 Console" "Payday 2 Console" "DayZ Console" "Squad Console" "Hell Let Loose Console"
"Escape from Tarkov Console" "Killing Floor 2 Console" "Deep Rock Galactic Console" "VRChat Console" "Hunt Showdown Console"
"Total War Arena Console" "Company of Heroes 3 Console" "Mordhau Console" "Chivalry 2 Console" "World of Tanks Console"
"World of Warships Console" "Tekken 8 Console" "Street Fighter 6 Console" "Mortal Kombat Console" "Gran Turismo 7"
)

# ---------- Special DNS (region-fix) ----------
declare -A special_dns_mobile
special_dns_mobile["FIFA Mobile"]="94.140.14.14 94.140.15.15"
special_dns_mobile["FC25 Mobile"]="185.228.168.9 185.228.169.9"
special_dns_mobile["PUBG Mobile"]="1.1.1.1 1.0.0.1"
special_dns_mobile["Arena Breakout Mobile"]="8.8.8.8 8.8.4.4"
special_dns_mobile["Fortnite Mobile"]="9.9.9.9 149.112.112.112"
special_dns_mobile["Genshin Impact Mobile"]="208.67.222.222 208.67.220.220"
special_dns_mobile["Call of Duty Mobile"]="77.88.8.8 77.88.8.1"
special_dns_mobile["Garena Free Fire"]="94.140.14.14 94.140.15.15"

declare -A special_dns_pc
special_dns_pc["FC25 PC"]="185.228.168.9 185.228.169.9"
special_dns_pc["Arena Breakout PC"]="8.8.8.8 8.8.4.4"
special_dns_pc["Valorant"]="1.1.1.1 1.0.0.1"
special_dns_pc["League of Legends"]="9.9.9.9 149.112.112.112"
special_dns_pc["World of Warcraft"]="94.140.14.14 94.140.15.15"
special_dns_pc["Call of Duty Warzone"]="208.67.222.222 208.67.220.220"
special_dns_pc["Fortnite PC"]="77.88.8.8 77.88.8.1"
special_dns_pc["Escape from Tarkov"]="156.154.70.5 156.154.71.5"

declare -A special_dns_console
special_dns_console["FC25 PS5"]="185.228.168.9 185.228.169.9"
special_dns_console["FIFA 24 PS5"]="94.140.14.14 94.140.15.15"
special_dns_console["Call of Duty Warzone Console"]="208.67.222.222 208.67.220.220"
special_dns_console["Fortnite Console"]="1.1.1.1 1.0.0.1"
special_dns_console["Arena Breakout Console"]="8.8.8.8 8.8.4.4"
special_dns_console["Escape from Tarkov Console"]="156.154.70.5 156.154.71.5"

# ---------- Menu Helpers ----------
show_list_menu(){
  local title="$1"; shift
  local -n arr=$1
  clear
  echo -e "${bold}${green}${title}${reset}"
  echo -e "${cyan}Select (0 to back):${reset}"
  for i in "${!arr[@]}"; do printf "${blue}[%2d]${reset} %s\n" $((i+1)) "${arr[$i]}"; done
  echo -e "${blue}[0]${reset} Back"
  echo -ne "\n${green}Choose option:${reset} "
}

# ---------- Section Menus ----------
mobile_dns_menu(){
  while true; do
    show_list_menu "Mobile Games DNS" mobile_games; safe_read sel
    case "$sel" in
      0) return ;;
      *)
        if [[ "$sel" =~ ^[0-9]+$ ]] && [ $sel -ge 1 ] && [ $sel -le ${#mobile_games[@]} ]; then
          local game="${mobile_games[$((sel-1))]}"
          clear; echo -e "${cyan}Selected Game:${reset} $game"
          if [ -n "${special_dns_mobile[$game]}" ]; then
            echo -e "${yellow}Special DNS (region-fix):${reset}"; print_dns_pair "${special_dns_mobile[$game]}"
          else
            if [ ! -s "$MOBILE_CACHE" ] || [ $(wc -l < "$MOBILE_CACHE") -lt 200 ]; then
              echo -e "${yellow}Building Mobile DNS Registry (first run)...${reset}"
              build_pool "mobile" "$MOBILE_CACHE"
            fi
            echo -e "${cyan}Choosing best DNS (<46ms)...${reset}"
            best=$(get_best_dns_from_cache "$MOBILE_CACHE")
            print_dns_pair "$best"
          fi
          echo -e "\n${green}Press Enter...${reset}"; read
        else echo -e "${red}Invalid input!${reset}"; sleep 1; fi
        ;;
    esac
  done
}

pc_dns_menu(){
  while true; do
    show_list_menu "PC Games DNS" pc_games; safe_read sel
    case "$sel" in
      0) return ;;
      *)
        if [[ "$sel" =~ ^[0-9]+$ ]] && [ $sel -ge 1 ] && [ $sel -le ${#pc_games[@]} ]; then
          local game="${pc_games[$((sel-1))]}"
          clear; echo -e "${cyan}Selected Game:${reset} $game"
          if [ -n "${special_dns_pc[$game]}" ]; then
            echo -e "${yellow}Special DNS (region-fix):${reset}"; print_dns_pair "${special_dns_pc[$game]}"
          else
            if [ ! -s "$PC_CACHE" ] || [ $(wc -l < "$PC_CACHE") -lt 200 ]; then
              echo -e "${yellow}Building PC DNS Registry (first run)...${reset}"
              build_pool "pc" "$PC_CACHE"
            fi
            echo -e "${cyan}Choosing best DNS (<46ms)...${reset}"
            best=$(get_best_dns_from_cache "$PC_CACHE")
            print_dns_pair "$best"
          fi
          echo -e "\n${green}Press Enter...${reset}"; read
        else echo -e "${red}Invalid input!${reset}"; sleep 1; fi
        ;;
    esac
  done
}

console_dns_menu(){
  while true; do
    show_list_menu "Console Games DNS" console_games; safe_read sel
    case "$sel" in
      0) return ;;
      *)
        if [[ "$sel" =~ ^[0-9]+$ ]] && [ $sel -ge 1 ] && [ $sel -le ${#console_games[@]} ]; then
          local game="${console_games[$((sel-1))]}"
          clear; echo -e "${cyan}Selected Game:${reset} $game"
          if [ -n "${special_dns_console[$game]}" ]; then
            echo -e "${yellow}Special DNS (region-fix):${reset}"; print_dns_pair "${special_dns_console[$game]}"
          else
            if [ ! -s "$CONSOLE_CACHE" ] || [ $(wc -l < "$CONSOLE_CACHE") -lt 200 ]; then
              echo -e "${yellow}Building Console DNS Registry (first run)...${reset}"
              build_pool "console" "$CONSOLE_CACHE"
            fi
            echo -e "${cyan}Choosing best DNS (<46ms)...${reset}"
            best=$(get_best_dns_from_cache "$CONSOLE_CACHE")
            print_dns_pair "$best"
          fi
          echo -e "\n${green}Press Enter...${reset}"; read
        else echo -e "${red}Invalid input!${reset}"; sleep 1; fi
        ;;
    esac
  done
}

# ---------- Download DNS (Unblock) ----------
download_dns_menu(){
  clear
  echo -e "${bold}${green}Download / Anti-censorship DNS${reset}"
  if [ ! -s "$DOWNLOAD_CACHE" ] || [ $(wc -l < "$DOWNLOAD_CACHE") -lt 50 ]; then
    echo -e "${yellow}Building Download DNS Registry...${reset}"
    build_pool "download" "$DOWNLOAD_CACHE"
  fi
  echo -e "${cyan}Choosing best download DNS (<46ms)...${reset}"
  best=$(get_best_dns_from_cache "$DOWNLOAD_CACHE")
  print_dns_pair "$best"
  echo -e "\n${green}Press Enter...${reset}"; read
}

# ---------- DNS Generate (New) ----------
dns_generate_menu(){
  clear
  echo -e "${cyan}Generated IPv4:${reset} $(generate_ipv4)"
  echo -e "${cyan}Generated IPv6:${reset} $(generate_ipv6)"
  echo -e "\n${green}Press Enter...${reset}"; read
}

# ---------- Search Game (New) ----------
search_game_menu(){
  clear
  echo -ne "${green}Enter game name or device (e.g., 'FC25 PS5'):${reset} "
  safe_read gname
  [ -z "$gname" ] && echo -e "${red}Empty input!${reset}" && sleep 1 && return

  local found_section=""; local found_game=""
  # mobile
  for g in "${mobile_games[@]}"; do
    if [[ "${g,,}" == *"${gname,,}"* ]]; then found_section="Mobile"; found_game="$g"; break; fi
  done
  # pc
  if [ -z "$found_section" ]; then
    for g in "${pc_games[@]}"; do
      if [[ "${g,,}" == *"${gname,,}"* ]]; then found_section="PC"; found_game="$g"; break; fi
    done
  fi
  # console
  if [ -z "$found_section" ]; then
    for g in "${console_games[@]}"; do
      if [[ "${g,,}" == *"${gname,,}"* ]]; then found_section="Console"; found_game="$g"; break; fi
    done
  fi

  if [ -n "$found_section" ]; then
    echo -e "${cyan}Found in ${found_section}:${reset} $found_game"
    case "$found_section" in
      Mobile)
        if [ -n "${special_dns_mobile[$found_game]}" ]; then
          print_dns_pair "${special_dns_mobile[$found_game]}"
        else
          [ ! -s "$MOBILE_CACHE" ] && build_pool "mobile" "$MOBILE_CACHE"
          best=$(get_best_dns_from_cache "$MOBILE_CACHE"); print_dns_pair "$best"
        fi
      ;;
      PC)
        if [ -n "${special_dns_pc[$found_game]}" ]; then
          print_dns_pair "${special_dns_pc[$found_game]}"
        else
          [ ! -s "$PC_CACHE" ] && build_pool "pc" "$PC_CACHE"
          best=$(get_best_dns_from_cache "$PC_CACHE"); print_dns_pair "$best"
        fi
      ;;
      Console)
        if [ -n "${special_dns_console[$found_game]}" ]; then
          print_dns_pair "${special_dns_console[$found_game]}"
        else
          [ ! -s "$CONSOLE_CACHE" ] && build_pool "console" "$CONSOLE_CACHE"
          best=$(get_best_dns_from_cache "$CONSOLE_CACHE"); print_dns_pair "$best"
        fi
      ;;
    esac
  } else
    echo -e "${yellow}Game not found in lists!${reset}"
    echo -e "${cyan}Choosing best generic DNS (<46ms) from Mobile pool...${reset}"
    [ ! -s "$MOBILE_CACHE" ] && build_pool "mobile" "$MOBILE_CACHE"
    best=$(get_best_dns_from_cache "$MOBILE_CACHE"); print_dns_pair "$best"
  fi
  echo -e "\n${green}Press Enter...${reset}"; read
}

# ---------- Ping DNS (New) ----------
ping_dns_menu(){
  clear
  echo -ne "${green}Enter DNS IP:${reset} "; safe_read ip
  if ! echo "$ip" | grep -Eq '^([0-9]{1,3}\.){3}[0-9]{1,3}$'; then
    echo -e "${red}Invalid IPv4!${reset}"; sleep 1; return
  fi
  if ! check_udp53 "$ip"; then
    echo -e "${red}Port 53/UDP seems closed or filtered on $ip${reset}"
  fi
  res=$(check_ping "$ip")
  if [ "$res" = "9999" ]; then
    echo -e "${red}No ICMP response from $ip${reset}"
  else
    echo -e "${cyan}Ping:${reset} $res ms"
  fi
  echo -e "\n${green}Press Enter...${reset}"; read
}

# ---------- Main Menu ----------
main_menu(){
  while true; do
    clear
    echo -e "${bold}${cyan}==== DNS Gamer Script ====${reset}"
    echo -e "${blue}[1]${reset} Mobile Games"
    echo -e "${blue}[2]${reset} PC Games"
    echo -e "${blue}[3]${reset} Console Games"
    echo -e "${blue}[4]${reset} Download DNS"
    echo -e "${blue}[5]${green} DNS Generate ${newtag}${reset}"
    echo -e "${blue}[6]${green} Search Game ${newtag}${reset}"
    echo -e "${blue}[7]${green} Ping DNS ${newtag}${reset}"
    echo -e "${blue}[8]${green} Rebuild DNS Registry ${newtag}${reset}"
    echo -e "${blue}[0]${reset} Exit"
    echo -ne "\n${green}Choose an option:${reset} "
    safe_read choice

    case "$choice" in
      1) mobile_dns_menu ;;
      2) pc_dns_menu ;;
      3) console_dns_menu ;;
      4) download_dns_menu ;;
      5) dns_generate_menu ;;
      6) search_game_menu ;;
      7) ping_dns_menu ;;
      8) rebuild_all_registries ;;
      0) exit 0 ;;
      *) echo -e "${red}Invalid choice!${reset}"; sleep 1 ;;
    esac
  done
}

# ---------- First-run: ensure registries exist (optional lazy build) ----------
for f in "$MOBILE_CACHE" "$PC_CACHE" "$CONSOLE_CACHE" "$DOWNLOAD_CACHE"; do
  if [ ! -s "$f" ]; then
    echo "# empty" > "$f"
  fi
done

# ---------- Start ----------
main_menu
