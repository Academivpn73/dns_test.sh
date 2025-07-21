#!/bin/bash

reset="\e[0m"
green="\e[1;32m"
blue="\e[1;34m"
cyan="\e[1;36m"
red="\e[1;31m"
yellow="\e[1;33m"
purple="\e[1;35m"
orange="\e[0;33m"

title_colors=("\e[1;31m" "\e[1;32m" "\e[1;33m" "\e[1;34m" "\e[1;35m" "\e[1;36m")

show_title() {
  clear
  local color=${title_colors[$RANDOM % ${#title_colors[@]}]}
  echo -e "${color}╔════════════════════════════════════════════════════╗"
  echo -e "║              Telegram: @Academi_vpn               ║"
  echo -e "║              Admin By: @MahdiAGM0                  ║"
  echo -e "║              Version : 1.2.5                        ║"
  echo -e "╚════════════════════════════════════════════════════╝${reset}"
  echo
}

countries=("Iran" "Iraq" "UAE" "Turkey" "Qatar" "Saudi Arabia" "Jordan" "Kuwait" "Oman" "Bahrain")

pc_games=("Valorant" "Fortnite" "CS:GO" "Dota 2" "League of Legends" "Overwatch 2" "Apex Legends")
console_games=("FIFA 24" "Call of Duty MW3" "Rocket League" "GTA Online" "Elden Ring")
mobile_games=("PUBG Mobile" "Call of Duty Mobile" "Arena Breakout" "Free Fire" "Wild Rift")

dns_pool_pc=("1.1.1.1 1.0.0.1" "8.8.8.8 8.8.4.4" "9.9.9.9 149.112.112.112")
dns_pool_console=("45.90.28.0 45.90.28.1" "185.121.177.177 185.121.177.178")
dns_pool_mobile=("1.1.1.1 1.0.0.1" "8.8.8.8 8.8.4.4")
dns_pool_download=("208.67.222.222 208.67.220.220")
dns_pool_vpn=("185.228.168.168 185.228.169.168")

check_ping() {
  ip=$1
  result=$(ping -c 1 -W 1 "$ip" 2>/dev/null | grep 'time=' | awk -F'time=' '{print $2}' | cut -d' ' -f1)
  if [[ -z "$result" ]]; then
    echo "Timeout"
  else
    echo "$result ms"
  fi
}

print_dns_format() {
  local game="$1"
  local country="$2"
  local dns1="$3"
  local dns2="$4"
  local ping1=$(check_ping "$dns1")
  local ping2=$(check_ping "$dns2")

  echo -e "\n${green}Game:${reset} $game"
  echo -e "${green}Country:${reset} $country"
  echo -e "\n${cyan}DNS Set 1:${reset}"
  echo -e "  Primary: $dns1"
  echo -e "  Secondary: $dns2"
  echo -e "${blue}Ping DNS:${reset}"
  echo -e "  Primary: $ping1"
  echo -e "  Secondary: $ping2"
}

select_dns_for_type() {
  local type="$1"

  if [[ "$type" == "pc" ]]; then
    games=("${pc_games[@]}")
    dns_pool=("${dns_pool_pc[@]}")
  elif [[ "$type" == "console" ]]; then
    games=("${console_games[@]}")
    dns_pool=("${dns_pool_console[@]}")
  elif [[ "$type" == "mobile" ]]; then
    games=("${mobile_games[@]}")
    dns_pool=("${dns_pool_mobile[@]}")
  else
    echo "Unknown type"
    return
  fi

  while true; do
    show_title
    echo -e "${green}Select your game:${reset}"
    for i in "${!games[@]}"; do
      printf "${blue}[%d]${reset} %s\n" $((i+1)) "${games[$i]}"
    done
    read -p "Choose number (or 0 to return to main menu): " gopt
    if [[ "$gopt" == "0" ]]; then
      return
    fi
    if ! [[ "$gopt" =~ ^[0-9]+$ ]] || (( gopt < 1 || gopt > ${#games[@]} )); then
      echo -e "${red}Invalid choice. Try again.${reset}"
      sleep 1
      continue
    fi
    game="${games[$((gopt-1))]}"

    echo -e "\n${green}Select your country:${reset}"
    for i in "${!countries[@]}"; do
      printf "${blue}[%d]${reset} %s\n" $((i+1)) "${countries[$i]}"
    done
    read -p "Choose number (or 0 to return to main menu): " copt
    if [[ "$copt" == "0" ]]; then
      return
    fi
    if ! [[ "$copt" =~ ^[0-9]+$ ]] || (( copt < 1 || copt > ${#countries[@]} )); then
      echo -e "${red}Invalid choice. Try again.${reset}"
      sleep 1
      continue
    fi
    country="${countries[$((copt-1))]}"

    pick="${dns_pool[$RANDOM % ${#dns_pool[@]}]}"
    dns1=$(echo "$pick" | awk '{print $1}')
    dns2=$(echo "$pick" | awk '{print $2}')

    print_dns_format "$game" "$country" "$dns1" "$dns2"
    read -p $'\nPress Enter to return to game selection...'
  done
}

main_menu() {
  while true; do
    show_title
    echo -e "${green}MAIN MENU:${reset}"
    echo -e "${blue}[1]${reset} DNS for PC Games"
    echo -e "${blue}[2]${reset} DNS for Console Games"
    echo -e "${blue}[3]${reset} DNS for Mobile Games"
    echo -e "${blue}[4]${reset} DNS for Download (Speed-up)"
    echo -e "${blue}[5]${reset} DNS for VPN / Anti-Censorship"
    echo -e "${blue}[0]${reset} Exit"
    read -p "Select an option: " choice
    case "$choice" in
      1) select_dns_for_type "pc" ;;
      2) select_dns_for_type "console" ;;
      3) select_dns_for_type "mobile" ;;
      4)
        show_title
        pick="${dns_pool_download[$RANDOM % ${#dns_pool_download[@]}]}"
        dns1=$(echo "$pick" | awk '{print $1}')
        dns2=$(echo "$pick" | awk '{print $2}')
        print_dns_format "Download Optimizer" "Auto" "$dns1" "$dns2"
        read -p $'\nPress Enter to return to menu...'
        ;;
      5)
        show_title
        pick="${dns_pool_vpn[$RANDOM % ${#dns_pool_vpn[@]}]}"
        dns1=$(echo "$pick" | awk '{print $1}')
        dns2=$(echo "$pick" | awk '{print $2}')
        print_dns_format "Anti-Censorship / VPN" "Global" "$dns1" "$dns2"
        read -p $'\nPress Enter to return to menu...'
        ;;
      0) exit ;;
      *) echo -e "${red}Invalid choice. Try again.${reset}" && sleep 1 ;;
    esac
  done
}

main_menu
