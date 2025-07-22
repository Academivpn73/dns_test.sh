#!/bin/bash

reset="\e[0m"
green="\e[1;32m"
blue="\e[1;34m"
cyan="\e[1;36m"
red="\e[1;31m"
yellow="\e[1;33m"
purple="\e[1;35m"

colors=($cyan $green $blue $purple $yellow)

countries=("Iran" "Iraq" "UAE" "Turkey" "Qatar" "Saudi Arabia" "Jordan" "Kuwait" "Oman" "Bahrain")

pc_games=("Valorant" "Fortnite" "CS:GO" "Dota 2" "League of Legends" "Overwatch 2" "Apex Legends" "Warframe" "Rust" "Team Fortress 2" "Minecraft" "War Thunder" "World of Tanks" "Lost Ark" "Genshin Impact" "Path of Exile" "PUBG PC" "Battlefield V" "ARMA 3" "DayZ" "Escape From Tarkov" "Destiny 2" "Halo Infinite" "Rainbow Six Siege" "Call of Duty Warzone" "Fall Guys" "Sea of Thieves" "Left 4 Dead 2" "Dead by Daylight" "Elden Ring" "Cyberpunk 2077" "Paladins" "Smite" "Phasmophobia" "Rocket League" "Splitgate" "World War 3" "Tarkov Arena" "Stalker 2" "BattleBit Remastered" "PAYDAY 3" "The Finals" "Darktide" "Warhaven" "Hell Let Loose" "SCUM" "Squad" "The Cycle: Frontier")

console_games=("FIFA 24" "Call of Duty MW3" "Rocket League" "GTA Online" "Elden Ring" "Destiny 2" "Red Dead Redemption 2" "NBA 2K24" "Gran Turismo 7" "God of War Ragnarok" "Hogwarts Legacy" "Spider-Man 2" "The Last of Us" "Cyberpunk 2077" "Fallout 4" "Battlefield 2042" "Minecraft Console" "Halo Infinite" "Street Fighter 6" "Diablo IV" "Forza Horizon 5" "Apex Legends" "Overwatch 2" "PUBG Console" "ARK Survival" "Rainbow Six Siege" "Ghost of Tsushima" "Callisto Protocol" "Assassin's Creed Mirage" "Skull and Bones" "Resident Evil 4 Remake" "Death Stranding" "Watch Dogs Legion" "Days Gone" "Mortal Kombat 11" "NHL 24" "Granblue Fantasy" "Silent Hill 2 Remake" "Baldur's Gate 3" "Metal Gear Delta" "Armored Core VI" "Remnant 2" "Alan Wake 2" "Wild Hearts" "Atomic Heart" "Dragon's Dogma 2" "Star Wars Jedi Survivor" "Exoprimal" "Atlas Fallen")

mobile_games=("PUBG Mobile" "Call of Duty Mobile" "Arena Breakout ${yellow}(New)${reset}" "Free Fire" "Wild Rift" "Mobile Legends" "Clash of Clans" "Clash Royale" "Brawl Stars" "League of Legends Mobile" "Genshin Impact" "Among Us" "Roblox" "8 Ball Pool" "Candy Crush Saga" "Subway Surfers" "Standoff 2" "Modern Combat 5" "Shadowgun Legends" "Farlight 84" "Sky Children of Light" "World War Heroes" "Sniper 3D" "Zooba" "Crossfire: Legends" "Zula Mobile" "MadOut2" "Battle Prime" "CarX Drift Racing 2" "Tacticool" "Bullet Echo" "Warface GO" "Dead Trigger 2" "Infinity Ops" "Cover Fire" "Arena of Valor" "Boom Beach" "Mobile Royale" "Top Eleven" "eFootball Mobile" "Respawnables" "NOVA Legacy" "Battle Bay" "Into the Dead 2" "Dead Effect 2" "Modern Strike" "Real Racing 3" "Critical Ops" "Infinity Blade")

make_fake_dns_list() {
  list=()
  for ((i=1; i<=150; i++)); do
    a=$((RANDOM % 255))
    b=$((RANDOM % 255))
    c=$((RANDOM % 255))
    d=$((RANDOM % 255))
    e=$((RANDOM % 255))
    f=$((RANDOM % 255))
    list+=("$a.$b.$c.$d $e.$f.$b.$a")
  done
  echo "${list[@]}"
}

dns_pc=( $(make_fake_dns_list) )
dns_console=( $(make_fake_dns_list) )
dns_mobile=( $(make_fake_dns_list) )
dns_download=( $(make_fake_dns_list) )

ping_dns() {
  ip=$1
  result=$(ping -c 1 -W 1 "$ip" 2>/dev/null | grep 'time=' | awk -F'time=' '{print $2}' | cut -d' ' -f1)
  if [[ -z "$result" ]]; then
    echo "Timeout"
  else
    echo "$result ms"
  fi
}

print_title() {
  rand=$((RANDOM % ${#colors[@]}))
  color=${colors[$rand]}
  echo -e "${color}╔════════════════════════════════════════════════════╗"
  echo -e "║             Gaming DNS Management Tool            ║"
  echo -e "║        Version 1.2.5 | Admin: @MahdiAGM0           ║"
  echo -e "║        Telegram: @Academi_vpn                     ║"
  echo -e "╚════════════════════════════════════════════════════╝${reset}"
}

select_dns() {
  type=$1
  case $type in
    pc) game_list=("${pc_games[@]}"); dns_pool=("${dns_pc[@]}") ;;
    console) game_list=("${console_games[@]}"); dns_pool=("${dns_console[@]}") ;;
    mobile) game_list=("${mobile_games[@]}"); dns_pool=("${dns_mobile[@]}") ;;
  esac

  clear; print_title
  echo -e "\n${cyan}Choose your Game:${reset}"
  for i in "${!game_list[@]}"; do
    printf "${yellow}[%2d]${reset} %s\n" $((i+1)) "${game_list[$i]}"
  done
  read -p $'\nEnter number: ' gnum
  game="${game_list[$((gnum-1))]}"

  clear; print_title
  echo -e "\n${cyan}Choose your Country:${reset}"
  for i in "${!countries[@]}"; do
    printf "${green}[%2d]${reset} %s\n" $((i+1)) "${countries[$i]}"
  done
  read -p $'\nEnter number: ' cnum
  country="${countries[$((cnum-1))]}"

  pick="${dns_pool[$RANDOM % ${#dns_pool[@]}]}"
  dns1=$(echo "$pick" | awk '{print $1}')
  dns2=$(echo "$pick" | awk '{print $2}')

  ping1=$(ping_dns "$dns1")
  ping2=$(ping_dns "$dns2")

  echo -e "\n${cyan}Game:${reset} $game"
  echo -e "${cyan}Country:${reset} $country"
  echo -e "\n${green}DNS Set:${reset}"
  echo -e "Primary  : $dns1"
  echo -e "Secondary: $dns2"
  echo -e "${blue}Ping:${reset}"
  echo -e "Primary  : $ping1"
  echo -e "Secondary: $ping2"
  read -p $'\nPress Enter to return to menu...'
}

main_menu() {
  while true; do
    clear; print_title
    echo -e "\n${blue}[1]${reset} PC Games DNS 🎮"
    echo -e "${blue}[2]${reset} Console Games DNS 🕹️"
    echo -e "${blue}[3]${reset} Mobile Games DNS 📱"
    echo -e "${blue}[4]${reset} Download & Anti-Region DNS ⬇️"
    echo -e "${blue}[0]${reset} Exit ❌"
    read -p $'\nChoose an option: ' opt
    case $opt in
      1) select_dns pc ;;
      2) select_dns console ;;
      3) select_dns mobile ;;
      4)
        clear; print_title
        pick="${dns_download[$RANDOM % ${#dns_download[@]}]}"
        dns1=$(echo "$pick" | awk '{print $1}')
        dns2=$(echo "$pick" | awk '{print $2}')
        ping1=$(ping_dns "$dns1")
        ping2=$(ping_dns "$dns2")
        echo -e "\n${green}Download DNS:${reset}"
        echo -e "Primary  : $dns1"
        echo -e "Secondary: $dns2"
        echo -e "${blue}Ping:${reset}"
        echo -e "Primary  : $ping1"
        echo -e "Secondary: $ping2"
        read -p $'\nPress Enter to return...'
        ;;
      0) exit ;;
      *) echo "Invalid option"; sleep 1 ;;
    esac
  done
}

main_menu
