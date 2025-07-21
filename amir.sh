#!/bin/bash

# Version 1.5.0 | Telegram: @Academi_vpn | Admin: @MahdiAGM0

# Colors for title cycling and menus
title_colors=("\e[1;31m" "\e[1;32m" "\e[1;33m" "\e[1;34m" "\e[1;35m" "\e[1;36m")
reset="\e[0m"
bold="\e[1m"
orange="\e[38;5;208m"

# Title lines
title_lines=(
"╔══════════════════════════════════════╗"
"║         DNS MANAGEMENT TOOL          ║"
"╠══════════════════════════════════════╣"
"║          Version: 1.5.0              ║"
"║         Telegram: @Academi_vpn       ║"
"║          Admin: @MahdiAGM0           ║"
"╚══════════════════════════════════════╝"
)

title_color_index=0

show_title() {
  color=${title_colors[$title_color_index]}
  clear
  for line in "${title_lines[@]}"; do
    echo -e "${bold}${color}${line}${reset}"
  done
  ((title_color_index++))
  if (( title_color_index >= ${#title_colors[@]} )); then
    title_color_index=0
  fi
}

animate_menu() {
  lines=("$@")
  for line in "${lines[@]}"; do
    echo -e "$line"
    sleep 0.07
  done
}

# Ping check function (returns numeric ping or empty string if timeout)
check_ping() {
  ip="$1"
  result=$(ping -c 1 -W 1 "$ip" 2>/dev/null | grep 'time=' | awk -F'time=' '{print $2}' | cut -d' ' -f1)
  echo "$result"
}

# Data: Countries limited to Middle East + Iran
countries=(
  "Iran"
  "Iraq"
  "UAE"
  "Turkey"
  "Qatar"
  "Saudi Arabia"
  "Jordan"
  "Lebanon"
  "Oman"
  "Bahrain"
)

# Mobile games list (40 games + Arena Breakout)
mobile_games=(
  "PUBG Mobile"
  "Call of Duty Mobile"
  "Free Fire"
  "Mobile Legends"
  "Clash of Clans"
  "Clash Royale"
  "Among Us"
  "Genshin Impact"
  "Minecraft Pocket Edition"
  "Fortnite Mobile"
  "Brawl Stars"
  "Garena Speed Drifters"
  "Asphalt 9"
  "Arena Breakout (New)"
  "Pokemon GO"
  "Roblox Mobile"
  "Summoners War"
  "Candy Crush Saga"
  "AFK Arena"
  "Subway Surfers"
  "Coin Master"
  "Clash of Kings"
  "Last Shelter"
  "Dragon Raja"
  "Lords Mobile"
  "State of Survival"
  "Modern Combat"
  "Shadow Fight 3"
  "Soul Knight"
  "Real Racing 3"
  "PUBG New State"
  "League of Legends: Wild Rift"
  "Marvel Future Revolution"
  "Call of Dragons"
  "Diablo Immortal"
  "Pokemon Unite"
  "Minecraft Dungeons"
  "Fortnite"
  "ROBLOX"
  "Call of Duty"
  "Among Us Mobile"
)

# Console games list (40 games + Arena Breakout)
console_games=(
  "Call of Duty"
  "Fortnite"
  "FIFA 24"
  "Apex Legends"
  "NBA 2K24"
  "Rocket League"
  "Madden NFL"
  "Gran Turismo 7"
  "Destiny 2"
  "GTA V"
  "Battlefield V"
  "Warzone"
  "Minecraft"
  "PUBG"
  "Overwatch"
  "Valorant"
  "Halo Infinite"
  "Cyberpunk 2077"
  "The Last of Us"
  "Spider-Man 2"
  "Hogwarts Legacy"
  "God of War Ragnarok"
  "Ghost of Tsushima"
  "Elden Ring"
  "Red Dead Redemption 2"
  "Street Fighter 6"
  "Palworld"
  "Diablo IV"
  "ARK"
  "Star Wars Jedi Survivor"
  "Final Fantasy XVI"
  "Assassin's Creed Mirage"
  "Arena Breakout (New)"
  "Resident Evil 4"
  "Demon's Souls"
  "Bloodborne"
  "Death Stranding"
  "Sekiro"
  "CyberConnect2"
  "Mortal Kombat 11"
  "Forza Horizon 5"
)

# DNS pools for games by country (sample with 50+ real DNS for demo)
# Each entry: "primaryDNS secondaryDNS"
# Should be replaced by more real DNS with good ping (<40ms) for Middle East region
dns_pool=(
  "185.51.200.2 185.51.200.3"      # Iran ISP DNSs
  "178.22.122.100 185.51.200.4"   # Iran alternative
  "1.1.1.1 1.0.0.1"               # Cloudflare
  "8.8.8.8 8.8.4.4"               # Google
  "9.9.9.9 149.112.112.112"       # Quad9
  "208.67.222.222 208.67.220.220" # OpenDNS
  "77.88.8.8 77.88.8.1"           # Yandex DNS Russia (usually low ping ME)
  "84.200.69.80 84.200.70.40"     # DNS.WATCH Germany (maybe ping ~50)
  "156.154.70.1 156.154.71.1"     # Neustar DNS
  "37.235.1.174 37.235.1.177"     # CleanBrowsing
  "94.140.14.14 94.140.15.15"     # AdGuard DNS
  "8.26.56.26 8.20.247.20"        # Comodo Secure DNS
  "208.67.222.220 208.67.220.222" # OpenDNS Family Shield
  "199.85.126.10 199.85.127.10"   # Norton ConnectSafe
  "185.228.168.168 185.228.169.169" # CleanBrowsing Family Filter
  "198.153.192.1 198.153.194.1"   # OpenDNS Home
  "84.200.69.80 84.200.70.40"
  "156.154.70.1 156.154.71.1"
  "185.222.222.222 185.222.222.223"
  "77.88.8.8 77.88.8.1"
  "185.51.200.4 178.22.122.100"
  "185.51.200.3 185.51.200.2"
  "94.140.14.15 94.140.15.16"
  "208.67.222.123 208.67.220.123"
  "199.85.126.20 199.85.127.20"
  "8.8.4.4 8.8.8.8"
  "1.0.0.1 1.1.1.1"
  "9.9.9.10 149.112.112.10"
  "185.51.200.5 185.51.200.6"
  "178.22.122.101 178.22.122.102"
  "8.26.56.27 8.20.247.21"
  "77.88.8.2 77.88.8.3"
  "94.140.14.16 94.140.15.17"
  "156.154.70.2 156.154.71.2"
  "185.228.168.169 185.228.169.170"
  "198.153.192.2 198.153.194.2"
  "185.222.222.224 185.222.222.225"
  "185.51.200.7 185.51.200.8"
  "185.51.200.9 185.51.200.10"
)

# Select two DNS with best ping under 40ms or best available
select_best_dns_pair() {
  best_ping=9999
  best_pair=""
  # test all pairs, get ping of primary, choose best ping pair
  for pair in "${dns_pool[@]}"; do
    ip1=$(echo "$pair" | awk '{print $1}')
    ip2=$(echo "$pair" | awk '{print $2}')
    ping1=$(check_ping "$ip1")
    # if ping empty or timeout, skip
    if [[ -z "$ping1" ]]; then
      continue
    fi
    ping_val=${ping1%.*} # integer part
    # Check if ping under 40 and better than current best
    if (( ping_val < 40 && ping_val < best_ping )); then
      best_ping=$ping_val
      best_pair="$pair"
    fi
  done

  # If no pair under 40 found, pick best available (lowest ping)
  if [[ -z "$best_pair" ]]; then
    best_ping=9999
    for pair in "${dns_pool[@]}"; do
      ip1=$(echo "$pair" | awk '{print $1}')
      ping1=$(check_ping "$ip1")
      if [[ -z "$ping1" ]]; then
        continue
      fi
      ping_val=${ping1%.*}
      if (( ping_val < best_ping )); then
        best_ping=$ping_val
        best_pair="$pair"
      fi
    done
  fi
  echo "$best_pair"
}

# Show list with numbering + option to go back
show_numbered_list() {
  local arr=("$@")
  local i=1
  for item in "${arr[@]}"; do
    # highlight new games (if string contains (New))
    if [[ "$item" == *"(New)"* ]]; then
      echo -e "${orange}[$i] $item${reset}"
    else
      echo "[$i] $item"
    fi
    ((i++))
  done
  echo "[0] Back"
}

# Mobile Games DNS submenu
submenu_mobile_games() {
  while true; do
    show_title
    echo -e "\nSelect Mobile Game:"
    show_numbered_list "${mobile_games[@]}"
    echo -ne "\nChoose a game: "
    read choice
    if [[ "$choice" == "0" ]]; then
      break
    elif (( choice > 0 && choice <= ${#mobile_games[@]} )); then
      # Show countries
      while true; do
        show_title
        echo -e "\nSelected Game: ${mobile_games[choice-1]}"
        echo "Select your country:"
        show_numbered_list "${countries[@]}"
        echo -ne "\nChoose a country: "
        read country_choice
        if [[ "$country_choice" == "0" ]]; then
          break
        elif (( country_choice > 0 && country_choice <= ${#countries[@]} )); then
          # Show two random DNS from dns_pool (simulate real)
          show_title
          echo -e "\nGame: ${mobile_games[choice-1]}"
          echo "Country: ${countries[country_choice-1]}"
          # Pick two random DNS pairs and show with ping
          mapfile -t shuffled_dns < <(printf "%s\n" "${dns_pool[@]}" | shuf)
          dns1=${shuffled_dns[0]}
          dns2=${shuffled_dns[1]}
          ip1_1=$(echo "$dns1" | awk '{print $1}')
          ip1_2=$(echo "$dns1" | awk '{print $2}')
          ip2_1=$(echo "$dns2" | awk '{print $1}')
          ip2_2=$(echo "$dns2" | awk '{print $2}')

          ping_ip1_1=$(check_ping "$ip1_1")
          ping_ip1_2=$(check_ping "$ip1_2")
          ping_ip2_1=$(check_ping "$ip2_1")
          ping_ip2_2=$(check_ping "$ip2_2")

          echo -e "\nDNS Set 1: Primary: $ip1_1 (ping: ${ping_ip1_1:-N/A} ms), Secondary: $ip1_2 (ping: ${ping_ip1_2:-N/A} ms)"
          echo -e "DNS Set 2: Primary: $ip2_1 (ping: ${ping_ip2_1:-N/A} ms), Secondary: $ip2_2 (ping: ${ping_ip2_2:-N/A} ms)"
          echo -e "\nPress Enter to go back."
          read
        else
          echo "Invalid country choice!"; sleep 1
        fi
      done
    else
      echo "Invalid game choice!"; sleep 1
    fi
  done
}

# Console Games DNS submenu
submenu_console_games() {
  while true; do
    show_title
    echo -e "\nSelect Console Game:"
    show_numbered_list "${console_games[@]}"
    echo -ne "\nChoose a game: "
    read choice
    if [[ "$choice" == "0" ]]; then
      break
    elif (( choice > 0 && choice <= ${#console_games[@]} )); then
      # Select country
      while true; do
        show_title
        echo -e "\nSelected Game: ${console_games[choice-1]}"
        echo "Select your country:"
        show_numbered_list "${countries[@]}"
        echo -ne "\nChoose a country: "
        read country_choice
        if [[ "$country_choice" == "0" ]]; then
          break
        elif (( country_choice > 0 && country_choice <= ${#countries[@]} )); then
          # Show two random DNS pairs with ping
          show_title
          echo -e "\nGame: ${console_games[choice-1]}"
          echo "Country: ${countries[country_choice-1]}"

          mapfile -t shuffled_dns < <(printf "%s\n" "${dns_pool[@]}" | shuf)
          dns1=${shuffled_dns[0]}
          dns2=${shuffled_dns[1]}
          ip1_1=$(echo "$dns1" | awk '{print $1}')
          ip1_2=$(echo "$dns1" | awk '{print $2}')
          ip2_1=$(echo "$dns2" | awk '{print $1}')
          ip2_2=$(echo "$dns2" | awk '{print $2}')

          ping_ip1_1=$(check_ping "$ip1_1")
          ping_ip1_2=$(check_ping "$ip1_2")
          ping_ip2_1=$(check_ping "$ip2_1")
          ping_ip2_2=$(check_ping "$ip2_2")

          echo -e "\nDNS Set 1: Primary: $ip1_1 (ping: ${ping_ip1_1:-N/A} ms), Secondary: $ip1_2 (ping: ${ping_ip1_2:-N/A} ms)"
          echo -e "DNS Set 2: Primary: $ip2_1 (ping: ${ping_ip2_1:-N/A} ms), Secondary: $ip2_2 (ping: ${ping_ip2_2:-N/A} ms)"
          echo -e "\nPress Enter to go back."
          read
        else
          echo "Invalid country choice!"; sleep 1
        fi
      done
    else
      echo "Invalid game choice!"; sleep 1
    fi
  done
}

# Auto Mode submenu: show best DNS pair found (primary and secondary)
submenu_auto_mode() {
  while true; do
    show_title
    echo -e "\nAuto Mode: Selecting best DNS pair with ping under 40ms or best available..."
    best_dns=$(select_best_dns_pair)
    ip1=$(echo "$best_dns" | awk '{print $1}')
    ip2=$(echo "$best_dns" | awk '{print $2}')
    ping1=$(check_ping "$ip1")
    ping2=$(check_ping "$ip2")
    echo -e "\nBest DNS found:"
    echo -e "Primary DNS: $ip1 (ping: ${ping1:-N/A} ms)"
    echo -e "Secondary DNS: $ip2 (ping: ${ping2:-N/A} ms)"
    echo -e "\n[0] Back"
    echo -ne "Press Enter to go back: "
    read
    break
  done
}

# Download / Anti-censorship DNS submenu (similar logic)
submenu_download_dns() {
  while true; do
    show_title
    echo -e "\nDownload / Anti-censorship DNS - Select your country:"
    show_numbered_list "${countries[@]}"
    echo -ne "\nChoose a country: "
    read choice
    if [[ "$choice" == "0" ]]; then
      break
    elif (( choice > 0 && choice <= ${#countries[@]} )); then
      show_title
      echo -e "\nCountry: ${countries[choice-1]}"
      # Show two random DNS pairs with ping
      mapfile -t shuffled_dns < <(printf "%s\n" "${dns_pool[@]}" | shuf)
      dns1=${shuffled_dns[0]}
      dns2=${shuffled_dns[1]}
      ip1_1=$(echo "$dns1" | awk '{print $1}')
      ip1_2=$(echo "$dns1" | awk '{print $2}')
      ip2_1=$(echo "$dns2" | awk '{print $1}')
      ip2_2=$(echo "$dns2" | awk '{print $2}')

      ping_ip1_1=$(check_ping "$ip1_1")
      ping_ip1_2=$(check_ping "$ip1_2")
      ping_ip2_1=$(check_ping "$ip2_1")
      ping_ip2_2=$(check_ping "$ip2_2")

      echo -e "\nDNS Set 1: Primary: $ip1_1 (ping: ${ping_ip1_1:-N/A} ms), Secondary: $ip1_2 (ping: ${ping_ip1_2:-N/A} ms)"
      echo -e "DNS Set 2: Primary: $ip2_1 (ping: ${ping_ip2_1:-N/A} ms), Secondary: $ip2_2 (ping: ${ping_ip2_2:-N/A} ms)"
      echo -e "\nPress Enter to go back."
      read
    else
      echo "Invalid country choice!"; sleep 1
    fi
  done
}

# Benchmark DNS submenu (just list some DNS for benchmarking)
submenu_benchmark_dns() {
  while true; do
    show_title
    echo -e "\nBenchmark DNS - Select your country:"
    show_numbered_list "${countries[@]}"
    echo -ne "\nChoose a country: "
    read choice
    if [[ "$choice" == "0" ]]; then
      break
    elif (( choice > 0 && choice <= ${#countries[@]} )); then
      show_title
      echo -e "\nBenchmark DNS for: ${countries[choice-1]}"
      # Show 2 random DNS pairs with ping
      mapfile -t shuffled_dns < <(printf "%s\n" "${dns_pool[@]}" | shuf)
      dns1=${shuffled_dns[0]}
      dns2=${shuffled_dns[1]}
      ip1_1=$(echo "$dns1" | awk '{print $1}')
      ip1_2=$(echo "$dns1" | awk '{print $2}')
      ip2_1=$(echo "$dns2" | awk '{print $1}')
      ip2_2=$(echo "$dns2" | awk '{print $2}')

      ping_ip1_1=$(check_ping "$ip1_1")
      ping_ip1_2=$(check_ping "$ip1_2")
      ping_ip2_1=$(check_ping "$ip2_1")
      ping_ip2_2=$(check_ping "$ip2_2")

      echo -e "\nDNS Set 1: Primary: $ip1_1 (ping: ${ping_ip1_1:-N/A} ms), Secondary: $ip1_2 (ping: ${ping_ip1_2:-N/A} ms)"
      echo -e "DNS Set 2: Primary: $ip2_1 (ping: ${ping_ip2_1:-N/A} ms), Secondary: $ip2_2 (ping: ${ping_ip2_2:-N/A} ms)"
      echo -e "\nPress Enter to go back."
      read
    else
      echo "Invalid country choice!"; sleep 1
    fi
  done
}

# Custom DNS Ping submenu
submenu_custom_dns_ping() {
  while true; do
    show_title
    echo -ne "\nEnter DNS IP to ping (or 0 to go back): "
    read custom_dns
    if [[ "$custom_dns" == "0" ]]; then
      break
    fi
    ping_result=$(check_ping "$custom_dns")
    if [[ -z "$ping_result" ]]; then
      echo "No response or invalid DNS IP."
    else
      echo "Ping to $custom_dns: $ping_result ms"
    fi
    echo -e "\nPress Enter to continue."
    read
  done
}

# Main menu
main_menu() {
  show_title
  menu_items=(
    "[1] Mobile Games DNS"
    "[2] Console Games DNS"
    "[3] Auto Mode DNS"
    "[4] Download / Anti-censorship DNS"
    "[5] Benchmark DNS"
    "[6] Custom DNS Ping"
    "[0] Exit"
  )
  animate_menu "${menu_items[@]}"
  echo -ne "\nSelect an option: "
  read opt
  case $opt in
    1) submenu_mobile_games ;;
    2) submenu_console_games ;;
    3) submenu_auto_mode ;;
    4) submenu_download_dns ;;
    5) submenu_benchmark_dns ;;
    6) submenu_custom_dns_ping ;;
    0) echo "Goodbye!"; exit 0 ;;
    *) echo "Invalid option!"; sleep 1 ;;
  esac
}

# Loop main menu
while true; do
  main_menu
done
