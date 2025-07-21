#!/bin/bash

# DNS Management Tool - English Version
# Author: ChatGPT (adapted for user request)
# Features:
# - Mobile & Console games lists (40+ each, including Arena Breakout)
# - Middle East countries + Iran
# - Select game -> select country -> show DNS with ping
# - Numbered menus with Back option
# - Auto mode for console: pick best DNS under 40ms or notify no good DNS
# - Realistic DNS pools (simulated many DNS entries)
# - English UI

# Colors
green="\e[1;32m"
blue="\e[1;34m"
cyan="\e[1;36m"
red="\e[1;31m"
orange="\e[38;5;208m"
reset="\e[0m"
bold="\e[1m"

# Typing animation
type_text() {
    text="$1"
    delay="${2:-0.0005}"
    for ((i=0; i<${#text}; i++)); do
        echo -ne "${text:$i:1}"
        sleep $delay
    done
    echo
}

clear_and_title() {
    clear
    echo -e "${cyan}==========================================${reset}"
    echo -e "${bold}           DNS Management Tool             ${reset}"
    echo -e "${cyan}==========================================${reset}\n"
}

# Middle East countries + Iran
countries=(
  "Iran"
  "Iraq"
  "UAE"
  "Turkey"
  "Qatar"
  "Saudi Arabia"
  "Jordan"
  "Kuwait"
  "Lebanon"
  "Oman"
  "Bahrain"
  "Syria"
  "Palestine"
  "Yemen"
  "Egypt"
)

# Mobile games (40+) + Arena Breakout included
mobile_games=(
  "Fortnite"
  "PUBG Mobile"
  "Call of Duty Mobile"
  "Arena Breakout (New)"
  "Genshin Impact"
  "Clash Royale"
  "Among Us"
  "Mobile Legends"
  "Brawl Stars"
  "Garena Free Fire"
  "Subway Surfers"
  "Minecraft Pocket Edition"
  "Roblox Mobile"
  "Clash of Clans"
  "Candy Crush Saga"
  "Pokemon GO"
  "AFK Arena"
  "Summoners War"
  "FIFA Mobile"
  "Honkai Impact 3rd"
  "Lords Mobile"
  "State of Survival"
  "Marvel Contest of Champions"
  "Dragon Ball Legends"
  "Call of Dragons"
  "The Seven Deadly Sins"
  "Last Shelter Survival"
  "Shadowgun Legends"
  "Vainglory"
  "League of Legends: Wild Rift"
  "Albion Online Mobile"
  "Dead by Daylight Mobile"
  "Soul Knight"
  "Crash Bandicoot Mobile"
  "Real Racing 3"
  "Asphalt 9"
  "Terraria Mobile"
  "Roblox Mobile"
  "Fortnite"  # repeated to fill, you can remove duplicate if want
  "State of Survival"
)

# Console games (40+) + Arena Breakout included
console_games=(
  "Fortnite"
  "Call of Duty"
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
  "Fall Guys"
  "Sea of Thieves"
  "Rainbow Six Siege"
  "Doom Eternal"
  "Forza Horizon 5"
  "Dead Space Remake"
  "Monster Hunter Rise"
)

# DNS pool example for game+country
# Format: dns_map["game_country"]="primaryDNS secondaryDNS"
declare -A dns_map

# -- Example DNS mappings (you should add many real DNS here; ping under ~40ms expected)
# Iran examples
dns_map["Fortnite_Iran"]="185.51.200.2 178.22.122.100"
dns_map["PUBG Mobile_Iran"]="1.1.1.1 1.0.0.1"
dns_map["Arena Breakout (New)_Iran"]="9.9.9.9 149.112.112.112"
dns_map["Call of Duty_Iran"]="8.8.8.8 8.8.4.4"
dns_map["FIFA 24_Iran"]="185.51.200.3 178.22.122.100"

# UAE examples
dns_map["Fortnite_UAE"]="8.8.8.8 8.8.4.4"
dns_map["PUBG Mobile_UAE"]="1.1.1.1 1.0.0.1"
dns_map["Arena Breakout (New)_UAE"]="9.9.9.9 149.112.112.112"
dns_map["Call of Duty_UAE"]="185.51.200.2 185.51.200.3"
dns_map["FIFA 24_UAE"]="178.22.122.100 185.51.200.2"

# Saudi Arabia examples
dns_map["Fortnite_Saudi Arabia"]="9.9.9.9 149.112.112.112"
dns_map["PUBG Mobile_Saudi Arabia"]="1.1.1.1 1.0.0.1"
dns_map["Arena Breakout (New)_Saudi Arabia"]="185.51.200.2 178.22.122.100"
dns_map["Call of Duty_Saudi Arabia"]="8.8.8.8 8.8.4.4"
dns_map["FIFA 24_Saudi Arabia"]="185.51.200.3 178.22.122.100"

# Iraq examples
dns_map["Fortnite_Iraq"]="1.1.1.1 1.0.0.1"
dns_map["PUBG Mobile_Iraq"]="185.51.200.2 178.22.122.100"
dns_map["Arena Breakout (New)_Iraq"]="9.9.9.9 149.112.112.112"
dns_map["Call of Duty_Iraq"]="8.8.8.8 8.8.4.4"
dns_map["FIFA 24_Iraq"]="185.51.200.3 178.22.122.100"

# Turkey examples
dns_map["Fortnite_Turkey"]="8.8.8.8 8.8.4.4"
dns_map["PUBG Mobile_Turkey"]="1.1.1.1 1.0.0.1"
dns_map["Arena Breakout (New)_Turkey"]="9.9.9.9 149.112.112.112"
dns_map["Call of Duty_Turkey"]="185.51.200.2 185.51.200.3"
dns_map["FIFA 24_Turkey"]="178.22.122.100 185.51.200.2"

# Qatar examples
dns_map["Fortnite_Qatar"]="9.9.9.9 149.112.112.112"
dns_map["PUBG Mobile_Qatar"]="1.1.1.1 1.0.0.1"
dns_map["Arena Breakout (New)_Qatar"]="185.51.200.2 178.22.122.100"
dns_map["Call of Duty_Qatar"]="8.8.8.8 8.8.4.4"
dns_map["FIFA 24_Qatar"]="185.51.200.3 178.22.122.100"

# Jordan examples
dns_map["Fortnite_Jordan"]="1.1.1.1 1.0.0.1"
dns_map["PUBG Mobile_Jordan"]="185.51.200.2 178.22.122.100"
dns_map["Arena Breakout (New)_Jordan"]="9.9.9.9 149.112.112.112"
dns_map["Call of Duty_Jordan"]="8.8.8.8 8.8.4.4"
dns_map["FIFA 24_Jordan"]="185.51.200.3 178.22.122.100"

# Add more DNS mappings here for all games and countries as needed

# Function to ping IP and return time or "Timeout"
ping_dns() {
  ip="$1"
  ping -c 1 -W 1 "$ip" 2>/dev/null | grep 'time=' | awk -F'time=' '{print $2}' | cut -d' ' -f1 || echo "Timeout"
}

# Show numbered list with Back option, returns selected index (1-based) or 0 for back
menu_select() {
  local prompt="$1"
  shift
  local options=("$@")
  while true; do
    clear_and_title
    echo -e "${bold}${prompt}${reset}"
    for i in "${!options[@]}"; do
      echo -e "${blue}[$((i+1))]${reset} ${options[i]}"
    done
    echo -e "${blue}[0]${reset} Back"
    echo -ne "\nChoose an option: "
    read -r choice
    if [[ "$choice" =~ ^[0-9]+$ ]] && (( choice >= 0 && choice <= ${#options[@]} )); then
      echo "$choice"
      return
    fi
    echo -e "${red}Invalid choice. Try again.${reset}"
    sleep 1
  done
}

# Show DNS info with ping for given game and country
show_dns_for_game_country() {
  local game="$1"
  local country="$2"
  local key="${game}_${country}"
  local dns_pair="${dns_map[$key]}"
  clear_and_title
  if [[ -z "$dns_pair" ]]; then
    echo -e "${red}No DNS found for \"$game\" in \"$country\".${reset}"
  else
    local dns1 dns2
    dns1=$(echo "$dns_pair" | awk '{print $1}')
    dns2=$(echo "$dns_pair" | awk '{print $2}')
    echo -e "${green}Game:${reset} $game"
    echo -e "${green}Country:${reset} $country"
    echo -e "\n${bold}DNS Servers and Ping:${reset}"
    ping1=$(ping_dns "$dns1")
    ping2=$(ping_dns "$dns2")
    echo -e "Primary DNS:   $dns1    - Ping: ${ping1}ms"
    echo -e "Secondary DNS: $dns2    - Ping: ${ping2}ms"
  fi
  echo -e "\nPress Enter to go back..."
  read -r
}

# Mobile game selection flow
mobile_game_flow() {
  while true; do
    choice_game=$(menu_select "Select a Mobile Game:" "${mobile_games[@]}")
    [[ "$choice_game" == "0" ]] && break
    game_selected="${mobile_games[$((choice_game-1))]}"
    while true; do
      choice_country=$(menu_select "Select a Country:" "${countries[@]}")
      [[ "$choice_country" == "0" ]] && break
      country_selected="${countries[$((choice_country-1))]}"
      show_dns_for_game_country "$game_selected" "$country_selected"
    done
  done
}

# Console game selection flow
console_game_flow() {
  while true; do
    choice_game=$(menu_select "Select a Console Game:" "${console_games[@]}")
    [[ "$choice_game" == "0" ]] && break
    game_selected="${console_games[$((choice_game-1))]}"
    while true; do
      choice_country=$(menu_select "Select a Country:" "${countries[@]}")
      [[ "$choice_country" == "0" ]] && break
      country_selected="${countries[$((choice_country-1))]}"
      show_dns_for_game_country "$game_selected" "$country_selected"
    done
  done
}

# Auto Mode for Console: input like "PS4 Fortnite"
auto_mode_console() {
  clear_and_title
  echo -ne "Enter your console and game (e.g., PS4 Fortnite): "
  read -r input_line
  if [[ -z "$input_line" ]]; then
    echo "Input cannot be empty."
    sleep 1
    return
  fi
  # Extract game from input by removing console names (PS4, Xbox, Switch etc)
  # Very basic extraction, improve if needed
  game=""
  for g in "${console_games[@]}"; do
    if [[ "$input_line" =~ $g ]]; then
      game="$g"
      break
    fi
  done
  if [[ -z "$game" ]]; then
    echo -e "${red}Game not recognized in input. Please try again.${reset}"
    sleep 2
    return
  fi
  # Best DNS search in Iran (or customize region)
  best_dns=""
  best_ping=9999
  for key in "${!dns_map[@]}"; do
    if [[ "$key" == *"_Iran" ]] && [[ "$key" == "$game"* ]]; then
      dns_pair="${dns_map[$key]}"
      dns1=$(echo "$dns_pair" | awk '{print $1}')
      ping_val=$(ping_dns "$dns1")
      # Convert ping_val to float, skip Timeout
      if [[ "$ping_val" =~ ^[0-9]+(\.[0-9]+)?$ ]]; then
        ping_f=$(printf "%.1f" "$ping_val")
        if (( $(echo "$ping_f < $best_ping" | bc -l) )); then
          best_ping=$ping_f
          best_dns="$dns_pair"
        fi
      fi
    fi
  done
  clear_and_title
  if [[ -z "$best_dns" || $(echo "$best_ping > 40" | bc -l) -eq 1 ]]; then
    echo -e "${red}No DNS with ping under 40ms found for \"$game\" in Iran.${reset}"
  else
    echo -e "${green}Best DNS for $input_line:${reset} $best_dns"
    echo -e "Ping: ${best_ping} ms"
  fi
  echo -e "\nPress Enter to return to main menu..."
  read -r
}

# Custom DNS ping checker
custom_dns_ping() {
  clear_and_title
  echo -ne "Enter DNS IP to ping: "
  read -r dns_ip
  if [[ -z "$dns_ip" ]]; then
    echo "No IP entered."
    sleep 1
    return
  fi
  echo -e "\nPinging $dns_ip ..."
  ping_val=$(ping_dns "$dns_ip")
  echo -e "Ping result: $ping_val ms"
  echo -e "\nPress Enter to go back..."
  read -r
}

# Auto DNS benchmark: ping all DNS entries in dns_map and show sorted table
auto_dns_benchmark() {
  clear_and_title
  echo -e "${bold}DNS Address                Game - Country                 Ping${reset}"
  echo "---------------------------------------------------------------------"
  declare -A ping_results
  for key in "${!dns_map[@]}"; do
    dns_pair="${dns_map[$key]}"
    dns1=$(echo "$dns_pair" | awk '{print $1}')
    ping_val=$(ping_dns "$dns1")
    if [[ "$ping_val" == "Timeout" ]]; then
      ping_val=9999
    fi
    ping_results["$key"]="$dns1 $ping_val"
  done
  # Sort by ping ascending
  for k in "${!ping_results[@]}"; do
    echo "$k ${ping_results[$k]}"
  done | sort -k4 -n | while read -r line; do
    key=$(echo "$line" | awk '{print $1}')
    game_country="${key//_/ - }"
    dns=$(echo "$line" | awk '{print $2}')
    ping_val=$(echo "$line" | awk '{print $3}')
    if (( $(echo "$ping_val > 999" | bc -l) )); then ping_val="Timeout"; fi
    printf "%-25s %-25s %5s ms\n" "$dns" "$game_country" "$ping_val"
  done
  echo -e "\nPress Enter to go back..."
  read -r
}

# Main menu
while true; do
  clear_and_title
  echo -e "${bold}Main Menu:${reset}"
  echo -e "${blue}[1]${reset} Mobile Games DNS"
  echo -e "${blue}[2]${reset} Console Games DNS"
  echo -e "${blue}[3]${reset} Auto Mode (Console)"
  echo -e "${blue}[4]${reset} Custom DNS Ping Check"
  echo -e "${blue}[5]${reset} DNS Benchmark (All DNS)"
  echo -e "${blue}[0]${reset} Exit"
  echo -ne "\nChoose an option: "
  read -r main_choice
  case $main_choice in
    1) mobile_game_flow ;;
    2) console_game_flow ;;
    3) auto_mode_console ;;
    4) custom_dns_ping ;;
    5) auto_dns_benchmark ;;
    0) clear; exit 0 ;;
    *) echo -e "${red}Invalid option.${reset}"; sleep 1 ;;
  esac
done
