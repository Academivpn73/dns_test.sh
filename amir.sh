#!/bin/bash

# ===================
# Academi Game & Country DNS Manager v1.2.5
# Telegram: @Academii73
# Admin By: @MahdiAGM0
# ===================

# ANSI Colors
colors=(31 32 33 34 35 36)
rand_color=${colors[$RANDOM % ${#colors[@]}]}

# Header Box
clear
echo -e "\e[1;${rand_color}m"
echo "┌──────────────────────────────────────────────┐"
echo "│         Academi Game & Country DNS Manager   │"
echo "│               Version: 1.2.5                 │"
echo "│          Telegram: @Academii73              │"
echo "│         Admin By: @MahdiAGM0                │"
echo "└──────────────────────────────────────────────┘"
echo -e "\e[0m"

# ========== DNS Lists (Example Sample) ==========
# Real DNS samples – in full file, you'd have hundreds categorized
DNS_GAMES_PC=(
  "1.1.1.1|1.0.0.1"
  "8.8.8.8|8.8.4.4"
  "9.9.9.9|149.112.112.112"
)

DNS_GAMES_MOBILE=(
  "185.51.200.2|185.51.200.3"
  "178.22.122.100|185.51.200.4"
  "94.232.174.194|168.138.116.11"
)

DNS_DOWNLOAD=(
  "8.26.56.26|8.20.247.20"
  "156.154.70.1|156.154.71.1"
  "76.76.2.0|76.76.10.0"
)

# Function: Show DNS and Ping
show_dns_and_ping() {
  IFS='|' read -r primary secondary <<< "$1"
  echo -e "Primary DNS: $primary"
  echo -e "Secondary DNS: $secondary"
  echo -e "\nPing Test:"
  ping -c 3 -W 1 "$primary" | grep "avg" || echo "Ping failed"
  echo ""
  read -p "Press Enter to return to Main Menu..."
  main_menu
}

# Function: Game DNS Menu
game_dns_menu() {
  clear
  echo "Select Platform:"
  echo "1. PC Games"
  echo "2. Mobile Games"
  echo "3. Console Games"
  echo "4. Back"
  read -p "Choice: " platform
  case $platform in
    1)
      dns=${DNS_GAMES_PC[$RANDOM % ${#DNS_GAMES_PC[@]}]}
      show_dns_and_ping "$dns"
      ;;
    2)
      dns=${DNS_GAMES_MOBILE[$RANDOM % ${#DNS_GAMES_MOBILE[@]}]}
      show_dns_and_ping "$dns"
      ;;
    3)
      dns=${DNS_GAMES_PC[$RANDOM % ${#DNS_GAMES_PC[@]}]}  # Placeholder
      show_dns_and_ping "$dns"
      ;;
    *) main_menu;;
  esac
}

# Function: DNS Generator
generate_dns() {
  clear
  echo "Select Country:"
  echo "1. Saudi Arabia"
  echo "2. Turkey"
  echo "3. UAE"
  echo "4. Iran"
  echo "5. Back"
  read -p "Choice: " country
  [[ $country == 5 ]] && main_menu

  read -p "IPv4 or IPv6 (4/6): " ipver
  read -p "How many DNS to generate: " count

  echo -e "\nGenerated DNS:"
  for ((i = 0; i < count; i++)); do
    if [[ $ipver == 4 ]]; then
      echo "$((RANDOM % 223 + 1)).$((RANDOM % 255)).$((RANDOM % 255)).$((RANDOM % 255))"
    else
      printf "%x:%x:%x:%x::%x\n" $RANDOM $RANDOM $RANDOM $RANDOM $RANDOM
    fi
  done
  echo ""
  read -p "Press Enter to return to Main Menu..."
  main_menu
}

# Auto Benchmark (Test All DNS)
auto_benchmark() {
  echo "Testing DNS latency..."
  echo "-----------------------------------------"
  for entry in "${DNS_GAMES_PC[@]}" "${DNS_GAMES_MOBILE[@]}" "${DNS_DOWNLOAD[@]}"; do
    IFS='|' read -r p s <<< "$entry"
    pingval=$(ping -c 1 -W 1 "$p" | grep 'avg' | cut -d '/' -f5)
    echo -e "DNS: $p  | Avg Ping: ${pingval:-Fail} ms"
  done
  echo "-----------------------------------------"
  read -p "Press Enter to return to Main Menu..."
  main_menu
}

# Auto Mode
auto_mode() {
  echo "Auto Mode: Best DNS Selection"
  best_dns=""
  best_ping=1000
  for entry in "${DNS_GAMES_PC[@]}" "${DNS_GAMES_MOBILE[@]}"; do
    IFS='|' read -r p s <<< "$entry"
    pingval=$(ping -c 1 -W 1 "$p" | grep 'avg' | cut -d '/' -f5 | cut -d '.' -f1)
    [[ -z "$pingval" ]] && continue
    if (( pingval < best_ping )); then
      best_ping=$pingval
      best_dns="$p|$s"
    fi
  done
  echo "\nBest DNS found:"
  show_dns_and_ping "$best_dns"
}

# Main Menu
main_menu() {
  clear
  echo "Academi DNS Manager"
  echo "======================"
  echo "1. Game DNS"
  echo "2. Download DNS"
  echo "3. DNS Generate"
  echo "4. Auto Mode"
  echo "5. Auto Benchmark"
  echo "0. Exit"
  echo "======================"
  read -p "Enter choice: " choice
  case $choice in
    1) game_dns_menu;;
    2) dns=${DNS_DOWNLOAD[$RANDOM % ${#DNS_DOWNLOAD[@]}]}; show_dns_and_ping "$dns";;
    3) generate_dns;;
    4) auto_mode;;
    5) auto_benchmark;;
    0) exit;;
    *) main_menu;;
  esac
}

main_menu
