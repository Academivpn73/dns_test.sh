#!/bin/bash

# Random Colors
colors=("\e[91m" "\e[92m" "\e[93m" "\e[94m" "\e[95m" "\e[96m")
rand_color=${colors[$RANDOM % ${#colors[@]}]}

# Title
clear
echo -e "${rand_color}"
echo "╔════════════════════════════════════════════════════════════╗"
echo "║            Gaming DNS Management Tool                      ║"
echo "║    Telegram: @Academi_vpn   Admin By: @MahdiAGM0          ║"
echo "║                    Version : 1.2.5                         ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo -e "\e[0m"

sleep 1

main_menu() {
  echo ""
  echo "1. 🎮 Mobile Games"
  echo "2. 🖥️  PC Games"
  echo "3. 🎮 Console Games"
  echo "4. 🌐 Download / Anti-Censorship DNS"
  echo "5. 🔁 Auto Mode"
  echo "0. Exit"
  echo ""
  read -p "Select an option: " opt

  case $opt in
    1) game_menu "Mobile" ;;
    2) game_menu "PC" ;;
    3) game_menu "Console" ;;
    4) show_download_dns ;;
    5) auto_mode ;;
    0) exit ;;
    *) echo "Invalid"; main_menu ;;
  esac
}

game_menu() {
  game_type=$1
  games=(
    "PUBG Mobile"
    "Free Fire"
    "Arena Breakout"
    "Call of Duty Mobile"
    "Clash Royale"
    "Clash of Clans"
    "Mobile Legends"
    "Fortnite Mobile"
    # Add 32+ more
  )
  echo "Select a $game_type Game:"
  for i in "${!games[@]}"; do
    echo "$((i+1)). ${games[$i]}"
  done
  read -p "Select: " gopt
  selected_game="${games[$((gopt-1))]}"
  select_country "$selected_game" "$game_type"
}

select_country() {
  game=$1
  game_type=$2
  countries=("USA" "Germany" "Netherlands" "France" "Iran" "India" "UK" "Japan" "Singapore" "Russia" "Canada" "Brazil" "Australia" "UAE" "Turkey" "Sweden" "Italy" "Spain" "China" "South Korea")
  echo "Select a country:"
  for i in "${!countries[@]}"; do
    echo "$((i+1)). ${countries[$i]}"
  done
  read -p "Country: " copt
  country="${countries[$((copt-1))]}"
  show_dns "$game" "$country" "$game_type"
}

show_dns() {
  game=$1
  country=$2
  type=$3
  key="${game}-${country}"
  echo ""
  echo "Game: $game"
  echo "Country: $country"
  echo "1. Primary: 1.1.1.1 | Secondary: 1.0.0.1"
  echo "2. Ping: 34 ms"
  # Randomize DNS here based on a predefined database
}

show_download_dns() {
  echo ""
  echo "Country:"
  echo "1. Primary: 8.8.8.8 | Secondary: 8.8.4.4"
  echo "2. Ping: 26 ms"
  # Add more DNS for download/anti-censorship
}

auto_mode() {
  # Future implementation
  echo "Auto DNS Mode Coming Soon!"
  sleep 1
  main_menu
}

main_menu
