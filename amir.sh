#!/bin/bash

# ============== Clear Screen Function ===============
clear_screen() {
  command -v clear >/dev/null 2>&1 && clear || printf "\033c"
}

# ============== Pause Function (wait for Enter) =======
pause() {
  echo
  read -rp "Press Enter to return to the main menu..."
}

# ============== Print Colored Title ===================
print_title() {
  clear_screen
  local colors=("\033[91m" "\033[92m" "\033[93m" "\033[94m" "\033[95m" "\033[96m")
  local color=${colors[$RANDOM % ${#colors[@]}]}
  echo -e "${color}╔════════════════════════════════════════════════════════════╗"
  echo -e "║             Gaming DNS Management Tool                     ║"
  echo -e "║     Telegram: @Academi_vpn   Admin By: @MahdiAGM0          ║"
  echo -e "║                      Version : 1.2.6                        ║"
  echo -e "╚════════════════════════════════════════════════════════════╝\033[0m"
  echo
}

# ============== Simple animation from top to bottom =======
simple_animation() {
  for i in {1..10}; do
    clear_screen
    for ((j=1; j<=i; j++)); do
      echo
    done
    echo "Loading... Please wait"
    sleep 0.05
  done
}

# ============== Lists ==============

# Countries list
countries=(
  "Iran"
  "USA"
  "UK"
  "Germany"
  "France"
  "Canada"
  "Australia"
  "Japan"
  "South Korea"
  "Russia"
  "Brazil"
  "India"
  "China"
  "Turkey"
  "United Arab Emirates"
  "Saudi Arabia"
  "Netherlands"
  "Sweden"
  "Norway"
  "Singapore"
  "Mexico"
)

# PC games (40 items)
pc_games=(
  "Valorant" "Call of Duty" "Minecraft" "Fortnite" "League of Legends"
  "Counter-Strike" "Overwatch" "Dota 2" "Apex Legends" "Rainbow Six Siege"
  "PUBG PC" "Cyberpunk 2077" "GTA V" "FIFA 22" "Rocket League"
  "Among Us" "Terraria" "Skyrim" "Fall Guys" "Dead by Daylight"
  "The Witcher 3" "Assassin's Creed" "Battlefield V" "Hades" "Dark Souls"
  "Star Wars Jedi" "Minecraft Dungeons" "Rust" "Ark Survival" "Warframe"
  "Half-Life Alyx" "Sea of Thieves" "Destiny 2" "The Sims 4" "Metro Exodus"
  "Civilization VI" "Stardew Valley" "Monster Hunter" "Diablo III" "Path of Exile"
)

# Mobile games (40 items)
mobile_games=(
  "PUBG Mobile" "Call of Duty Mobile" "Free Fire" "Genshin Impact" "Clash Royale"
  "Clash of Clans" "Mobile Legends" "Among Us" "Arena Breakout" "Brawl Stars"
  "Pokemon Go" "Candy Crush" "Minecraft Pocket Edition" "Subway Surfers" "Roblox Mobile"
  "AFK Arena" "Garena Speed Drifters" "League of Legends Wild Rift" "State of Survival" "Mobile Legends Bang Bang"
  "Summoners War" "Call of Dragons" "Mortal Kombat Mobile" "Lords Mobile" "Rise of Kingdoms"
  "World War Heroes" "Shadowgun Legends" "Black Desert Mobile" "Dragon Raja" "Last Shelter"
  "VainGlory" "MARVEL Future Fight" "Dead Trigger 2" "Farmville 2" "Modern Combat 5"
  "Rules of Survival" "PUBG New State" "Knives Out" "GTA Mobile" "Dragon Ball Legends"
)

# Console games (40 items)
console_games=(
  "The Last of Us" "God of War" "Spider-Man" "Halo Infinite" "Forza Horizon"
  "Ghost of Tsushima" "Animal Crossing" "Cyberpunk 2077" "Red Dead Redemption 2" "Gran Turismo"
  "Super Mario Odyssey" "FIFA 22" "Call of Duty" "Mortal Kombat 11" "Minecraft"
  "Destiny 2" "Fortnite" "Assassin's Creed Valhalla" "Battlefield 2042" "Overwatch"
  "Rocket League" "Death Stranding" "Gears 5" "Persona 5" "NBA 2K22"
  "Resident Evil Village" "Cuphead" "Apex Legends" "Metro Exodus" "Sekiro"
  "Final Fantasy VII" "Monster Hunter World" "Bayonetta" "Tetris Effect" "Yakuza 7"
  "Marvel's Avengers" "Control" "Dark Souls III" "Watch Dogs Legion" "Dishonored 2"
)

# DNS lists (realistic examples, you can expand them)
declare -A dns_pc=(
  ["USA"]="8.8.8.8|8.8.4.4"
  ["Iran"]="185.51.200.2|185.51.200.3"
  ["Germany"]="9.9.9.9|149.112.112.112"
  ["Japan"]="1.1.1.1|1.0.0.1"
  ["South Korea"]="223.130.195.95|223.130.195.91"
  ["Saudi Arabia"]="188.165.196.154|188.165.196.152"
  ["UK"]="77.88.8.8|77.88.8.1"
)

declare -A dns_mobile=(
  ["USA"]="8.8.8.8|8.8.4.4"
  ["Iran"]="185.51.200.2|185.51.200.3"
  ["Germany"]="9.9.9.9|149.112.112.112"
  ["Japan"]="1.1.1.1|1.0.0.1"
  ["South Korea"]="223.130.195.95|223.130.195.91"
  ["Saudi Arabia"]="188.165.196.154|188.165.196.152"
  ["UK"]="77.88.8.8|77.88.8.1"
)

declare -A dns_console=(
  ["USA"]="8.8.8.8|8.8.4.4"
  ["Iran"]="185.51.200.2|185.51.200.3"
  ["Germany"]="9.9.9.9|149.112.112.112"
  ["Japan"]="1.1.1.1|1.0.0.1"
  ["South Korea"]="223.130.195.95|223.130.195.91"
  ["Saudi Arabia"]="188.165.196.154|188.165.196.152"
  ["UK"]="77.88.8.8|77.88.8.1"
)

declare -A dns_download=(
  ["Global"]="8.8.8.8|8.8.4.4"
  ["Iran"]="185.51.200.2|185.51.200.3"
  ["VPN"]="209.222.18.222|209.222.18.218"
  ["ShadowDNS"]="104.223.91.95|104.223.91.96"
)

# ============== Functions ==============

# Show list of countries, let user select, return selected country
choose_country() {
  echo "Select a country:"
  local i=1
  for c in "${countries[@]}"; do
    echo "  $i) $c"
    ((i++))
  done
  echo "  0) Back"
  echo
  while true; do
    read -rp "Enter number: " num
    if [[ "$num" =~ ^[0-9]+$ ]]; then
      if (( num == 0 )); then
        return 1 # signal to go back
      elif (( num >= 1 && num <= ${#countries[@]} )); then
        country="${countries[num-1]}"
        return 0
      else
        echo "Invalid choice, try again."
      fi
    else
      echo "Please enter a valid number."
    fi
  done
}

# Show DNS for given country & game type
show_dns() {
  local -n dns_arr=$1
  echo
  echo "Country: $country"
  IFS='|' read -r primary secondary <<<"${dns_arr[$country]}"
  echo "1. Primary: $primary | Secondary: $secondary"
  echo "2. Ping: (use ping command to measure)"
  echo
  pause
}

# List PC games, choose one
pc_games_menu() {
  while true; do
    clear_screen
    print_title
    echo "PC Games:"
    local i=1
    for g in "${pc_games[@]}"; do
      echo "  $i) $g"
      ((i++))
    done
    echo "  0) Back"
    echo
    read -rp "Choose a game number: " choice
    if [[ "$choice" =~ ^[0-9]+$ ]]; then
      if (( choice == 0 )); then
        break
      elif (( choice >= 1 && choice <= ${#pc_games[@]} )); then
        selected_game="${pc_games[choice-1]}"
        # select country
        choose_country || continue
        show_dns dns_pc
      else
        echo "Invalid selection"
        pause
      fi
    else
      echo "Enter a valid number"
      pause
    fi
  done
}

# List Mobile games
mobile_games_menu() {
  while true; do
    clear_screen
    print_title
    echo "Mobile Games:"
    local i=1
    for g in "${mobile_games[@]}"; do
      echo "  $i) $g"
      ((i++))
    done
    echo "  0) Back"
    echo
    read -rp "Choose a game number: " choice
    if [[ "$choice" =~ ^[0-9]+$ ]]; then
      if (( choice == 0 )); then
        break
      elif (( choice >= 1 && choice <= ${#mobile_games[@]} )); then
        selected_game="${mobile_games[choice-1]}"
        choose_country || continue
        show_dns dns_mobile
      else
        echo "Invalid selection"
        pause
      fi
    else
      echo "Enter a valid number"
      pause
    fi
  done
}

# List Console games
console_games_menu() {
  while true; do
    clear_screen
    print_title
    echo "Console Games:"
    local i=1
    for g in "${console_games[@]}"; do
      echo "  $i) $g"
      ((i++))
    done
    echo "  0) Back"
    echo
    read -rp "Choose a game number: " choice
    if [[ "$choice" =~ ^[0-9]+$ ]]; then
      if (( choice == 0 )); then
        break
      elif (( choice >= 1 && choice <= ${#console_games[@]} )); then
        selected_game="${console_games[choice-1]}"
        choose_country || continue
        show_dns dns_console
      else
        echo "Invalid selection"
        pause
      fi
    else
      echo "Enter a valid number"
      pause
    fi
  done
}

# Download DNS menu
download_dns_menu() {
  while true; do
    clear_screen
    print_title
    echo "Download DNS Options:"
    local keys=("${!dns_download[@]}")
    local i=1
    for k in "${keys[@]}"; do
      echo "  $i) $k"
      ((i++))
    done
    echo "  0) Back"
    echo
    read -rp "Choose an option: " choice
    if [[ "$choice" =~ ^[0-9]+$ ]]; then
      if (( choice == 0 )); then
        break
      elif (( choice >= 1 && choice <= ${#keys[@]} )); then
        key="${keys[choice-1]}"
        clear_screen
        print_title
        echo "$key DNS:"
        IFS='|' read -r primary secondary <<<"${dns_download[$key]}"
        echo "1. Primary: $primary | Secondary: $secondary"
        echo "2. Ping: (use ping command to measure)"
        pause
      else
        echo "Invalid selection"
        pause
      fi
    else
      echo "Enter a valid number"
      pause
    fi
  done
}

# Saudi Arabia DNS Generator (IPv4 & IPv6)
generate_ipv4_saudi() {
  echo "188.$((RANDOM % 256)).$((RANDOM % 256)).$((RANDOM % 256))"
}

generate_ipv6_saudi() {
  printf "2a03:%04x:%04x::%04x:%04x\n" $((RANDOM % 65536)) $((RANDOM % 65536)) $((RANDOM % 65536)) $((RANDOM % 65536))
}

saudi_dns_generator_menu() {
  while true; do
    clear_screen
    print_title
    echo "Saudi Arabia DNS Generator"
    echo
    read -rp "Choose IP version (4 or 6) or 0 to go back: " ipver
    if [[ "$ipver" == "0" ]]; then
      break
    elif [[ "$ipver" != "4" && "$ipver" != "6" ]]; then
      echo "Invalid input, enter 4 or 6."
      pause
      continue
    fi
    read -rp "How many DNS addresses do you want? " count
    if ! [[ "$count" =~ ^[0-9]+$ ]]; then
      echo "Please enter a valid number."
      pause
      continue
    fi
    echo
    echo "Generating $count DNS addresses for Saudi Arabia (IPv$ipver):"
    for ((i=1; i<=count; i++)); do
      if [[ "$ipver" == "4" ]]; then
        dns=$(generate_ipv4_saudi)
      else
        dns=$(generate_ipv6_saudi)
      fi
      echo "$i. $dns"
    done
    pause
  done
}

# ============== Main Menu ==============

main_menu() {
  while true; do
    simple_animation
    print_title
    echo "Main Menu:"
    echo " 1) PC Games"
    echo " 2) Mobile Games"
    echo " 3) Console Games"
    echo " 4) Download DNS"
    echo " 5) Saudi Arabia DNS Generator"
    echo " 0) Exit"
    echo
    read -rp "Enter your choice: " choice
    case $choice in
      1) pc_games_menu ;;
      2) mobile_games_menu ;;
      3) console_games_menu ;;
      4) download_dns_menu ;;
      5) saudi_dns_generator_menu ;;
      0) echo "Goodbye!"; exit 0 ;;
      *) echo "Invalid option, try again."; pause ;;
    esac
  done
}

# ============== Run Program ==============
main_menu
