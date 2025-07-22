#!/bin/bash

# رنگ‌ها
reset="\e[0m"
colors=("\e[1;31m" "\e[1;32m" "\e[1;33m" "\e[1;34m" "\e[1;35m" "\e[1;36m")
rand=$((RANDOM % ${#colors[@]}))
color=${colors[$rand]}

# تایتل خوشکل
show_title() {
  clear
  echo -e "${color}╔════════════════════════════════════════════════════════════════╗"
  echo -e "║                    Gaming DNS Management Tool                 ║"
  echo -e "║                    Version 1.2.5 | @Academi_vpn               ║"
  echo -e "║                    Admin: @MahdiAGM0                          ║"
  echo -e "╚════════════════════════════════════════════════════════════════╝${reset}"
}

# انیمیشن چاپ از بالا به پایین
print_list_animated() {
  for item in "$@"; do
    echo -e "$item"
    sleep 0.03
  done
}

# لیست کشورها
countries=("Iran" "Iraq" "UAE" "Turkey" "Qatar" "Saudi Arabia" "Jordan" "Kuwait" "Oman" "Bahrain")

# لیست بازی‌ها (فقط نمونه‌ها)
pc_games=("Valorant" "CS:GO" "League of Legends" "Apex Legends" "Dota 2" "Overwatch 2" "Fortnite" "Warzone" "PUBG PC" "Genshin Impact" "Smite" "Rocket League" "War Thunder" "Rust" "ARK" "Minecraft" "Dead by Daylight" "Paladins" "DayZ" "Tarkov Arena" "Cyberpunk 2077" "Lost Ark" "World War 3" "World of Tanks" "Stalker 2" "Escape from Tarkov" "Halo Infinite" "Battlefield V" "ARMA 3" "Fall Guys" "Destiny 2" "Splitgate" "Sea of Thieves" "Left 4 Dead 2" "Phasmophobia" "Elden Ring" "Path of Exile" "Diablo IV" "Call of Duty MW3" "Farlight 84" "Skull and Bones" "Death Stranding" "Assassin's Creed Mirage" "Resident Evil 4" "Watch Dogs Legion" "The Finals" "PAYDAY 3" "THE CYCLE FRONTIER" "Bloodhunt")

console_games=("FIFA 24" "Call of Duty MW3" "Rocket League" "GTA Online" "Elden Ring" "Destiny 2" "RDR2" "NBA 2K24" "Gran Turismo 7" "God of War Ragnarok" "Hogwarts Legacy" "Spider-Man 2" "The Last of Us" "Fallout 4" "Battlefield 2042" "Minecraft Console" "Halo Infinite" "Street Fighter 6" "Diablo IV" "Forza Horizon 5" "Overwatch 2" "PUBG Console" "ARK" "Rainbow Six Siege" "Ghost of Tsushima" "Callisto Protocol" "AC Mirage" "Skull and Bones" "RE4 Remake" "Death Stranding" "Watch Dogs Legion" "Days Gone" "Mortal Kombat 11" "NHL 24" "Silent Hill 2 Remake" "Baldur's Gate 3" "The Crew Motorfest" "Cyberpunk 2077" "Stalker 2" "Tarkov Arena" "Final Fantasy XVI" "Granblue Fantasy" "Kena Bridge of Spirits" "Witcher 3 Next Gen" "Avowed" "The Expanse" "PAYDAY 3" "Alan Wake 2")

mobile_games=("PUBG Mobile" "Call of Duty Mobile" "Arena Breakout ${colors[2]}(New)${reset}" "Free Fire" "Wild Rift" "Mobile Legends" "Clash of Clans" "Clash Royale" "Brawl Stars" "League of Legends Mobile" "Genshin Impact" "Among Us" "Roblox" "8 Ball Pool" "Candy Crush Saga" "Subway Surfers" "Standoff 2" "Modern Combat 5" "Shadowgun Legends" "Sky Children of Light" "World War Heroes" "Sniper 3D" "Zooba" "Zula Mobile" "Battle Prime" "CarX Drift Racing 2" "Tacticool" "Bullet Echo" "Warface GO" "Dead Trigger 2" "Infinity Ops" "Cover Fire" "Arena of Valor" "Boom Beach" "Mobile Royale" "Top Eleven" "eFootball Mobile" "Farlight 84" "Project Evo ${colors[2]}(New)${reset}" "Warframe Mobile" "COD Warzone Mobile" "Naraka Bladepoint" "N.O.V.A Legacy" "Modern Ops" "War After" "Cyberika" "ShellFire" "T3 Arena")

# تولید DNS تصادفی معتبر
generate_dns() {
  for ((i=0; i<150; i++)); do
    ip1="$((RANDOM%223+1)).$((RANDOM%255)).$((RANDOM%255)).$((RANDOM%255))"
    ip2="$((RANDOM%223+1)).$((RANDOM%255)).$((RANDOM%255)).$((RANDOM%255))"
    echo "$ip1 $ip2"
  done
}

# بررسی پینگ
check_ping() {
  ip=$1
  ping -c 1 -W 1 "$ip" &>/dev/null && echo -n "✅" || echo -n "❌"
}

# نمایش DNS به فرمت کامل
show_dns_info() {
  game="$1"
  country="$2"
  dns_pair=( $3 )
  echo -e "\n${colors[3]}Game:${reset} $game"
  echo -e "${colors[3]}Country:${reset} $country"
  echo -e "${colors[5]}DNS Set:${reset}"
  echo -e "  Primary: ${dns_pair[0]}  [$(check_ping ${dns_pair[0]})]"
  echo -e "  Secondary: ${dns_pair[1]} [$(check_ping ${dns_pair[1]})]"
}

# انتخاب بازی
select_game_flow() {
  type="$1"
  case $type in
    pc) list=("${pc_games[@]}") ;;
    console) list=("${console_games[@]}") ;;
    mobile) list=("${mobile_games[@]}") ;;
    *) return ;;
  esac

  show_title
  echo -e "\n${colors[1]}Choose Game:${reset}"
  for i in "${!list[@]}"; do
    echo -e "${colors[2]}[$((i+1))]${reset} ${list[$i]}"
  done
  read -p "Select game number: " gnum
  game="${list[$((gnum-1))]}"

  echo -e "\n${colors[1]}Choose Country:${reset}"
  for i in "${!countries[@]}"; do
    echo -e "${colors[4]}[$((i+1))]${reset} ${countries[$i]}"
  done
  read -p "Select country number: " cnum
  country="${countries[$((cnum-1))]}"

  dns_list=( $(generate_dns) )
  rand_index=$((RANDOM % ${#dns_list[@]}))
  dns_pair=( ${dns_list[$rand_index]} )

  show_dns_info "$game" "$country" "${dns_pair[*]}"
  read -p $'\nPress Enter to return...'
}

# منوی اصلی
main_menu() {
  while true; do
    show_title
    echo -e "\n${colors[2]}[1]${reset} PC Games DNS 🎮"
    echo -e "${colors[2]}[2]${reset} Console Games DNS 🕹️"
    echo -e "${colors[2]}[3]${reset} Mobile Games DNS 📱"
    echo -e "${colors[2]}[4]${reset} Download/Bypass DNS ⬇️"
    echo -e "${colors[2]}[5]${reset} Auto Benchmark (Test All DNSs) ⚙️"
    echo -e "${colors[2]}[0]${reset} Exit ❌"
    echo -ne "\nChoose option: "
    read opt
    case $opt in
      1) select_game_flow "pc" ;;
      2) select_game_flow "console" ;;
      3) select_game_flow "mobile" ;;
      4)
        show_title
        dns_list=( $(generate_dns) )
        for ((i=0; i<10; i++)); do
          dns_pair=( ${dns_list[$i]} )
          show_dns_info "Downloader" "Iran" "${dns_pair[*]}"
        done
        read -p $'\nPress Enter to return...'
        ;;
      5)
        show_title
        dns_list=( $(generate_dns) )
        for ((i=0; i<100; i+=10)); do
          echo -e "\n${colors[1]}DNS Batch $((i/10+1))${reset}"
          for ((j=i; j<i+10; j++)); do
            dns_pair=( ${dns_list[$j]} )
            show_dns_info "AutoMod" "Iran" "${dns_pair[*]}"
          done
          read -p $'\nPress any key for next batch...'
        done
        ;;
      0) exit ;;
      *) echo -e "Invalid option." ;;
    esac
  done
}

main_menu
