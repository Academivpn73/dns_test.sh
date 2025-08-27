#!/bin/bash

# ==========================
# Gamer DNS Manager v5.1
# ==========================

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m'

# ==========================
# Title Box
# ==========================
show_title() {
    COLORS=("$RED" "$GREEN" "$YELLOW" "$BLUE" "$PURPLE" "$CYAN" "$WHITE")
    RAND_COLOR=${COLORS[$RANDOM % ${#COLORS[@]}]}

    clear
    echo -e "${RAND_COLOR}========================================"
    echo -e "   Gamer DNS Manager — Version: 5.1"
    echo -e "   Telegram: @Academi_vpn | Admin: @MahdiAGM0"
    echo -e "========================================${NC}"
    echo
}

# ==========================
# Ping Test Function
# ==========================
ping_dns() {
    ip=$1
    ms=$(ping -c 1 -W 1 "$ip" 2>/dev/null | awk -F'time=' '/time=/{print $2}' | awk '{print $1}')
    if [ -z "$ms" ]; then
        echo "timeout"
    else
        echo "${ms}ms"
    fi
}

# ==========================
# Generate Random DNS (Fallback)
# ==========================
generate_dns() {
    oct1=$((RANDOM % 223 + 1))
    oct2=$((RANDOM % 256))
    oct3=$((RANDOM % 256))
    oct4=$((RANDOM % 256))
    echo "$oct1.$oct2.$oct3.$oct4"
}

# ==========================
# Menu
# ==========================
main_menu() {
    show_title
    echo -e "${GREEN}1) PC Games DNS${NC}"
    echo -e "${GREEN}2) Mobile Games DNS${NC}"
    echo -e "${GREEN}3) Console Games DNS${NC}"
    echo -e "${GREEN}4) Download/Streaming DNS${NC}"
    echo -e "${GREEN}5) Generate DNS (Countries)${NC}"
    echo -e "${RED}0) Exit${NC}"
    echo
    read -p "Choose an option: " option

    case $option in
        1) pc_games_menu ;;
        2) mobile_games_menu ;;
        3) console_games_menu ;;
        4) download_dns_menu ;;
        5) generate_dns_menu ;;
        0) exit 0 ;;
        *) echo -e "${RED}Invalid option!${NC}"; sleep 2; main_menu ;;
    esac
}
# ==========================
# PC Games DNS (200+)
# ==========================

PC_DNS=(
"1.1.1.1" "1.0.0.1" "8.8.8.8" "8.8.4.4" "9.9.9.9" "149.112.112.112"
"208.67.222.222" "208.67.220.220" "94.140.14.14" "94.140.15.15"
"77.88.8.8" "77.88.8.1" "185.222.222.222" "185.184.222.222"
"64.6.64.6" "64.6.65.6" "76.76.2.0" "76.76.10.0"
"156.154.70.1" "156.154.71.1" "45.90.28.193" "45.90.30.193"
"45.90.28.0" "45.90.30.0" "91.239.100.100" "89.233.43.71"
"185.228.168.9" "185.228.169.9" "74.82.42.42" "209.244.0.3"
"209.244.0.4" "216.146.35.35" "216.146.36.36" "8.26.56.26"
"8.20.247.20" "4.2.2.1" "4.2.2.2" "4.2.2.3" "4.2.2.4"
"4.2.2.5" "4.2.2.6" "23.253.163.53" "198.101.242.72"
"64.94.1.1" "165.87.13.129" "204.117.214.10" "151.196.0.37"
"151.197.0.37" "151.198.0.37" "151.199.0.37" "151.201.0.37"
"151.202.0.37" "151.203.0.37" "151.204.0.37" "151.205.0.37"
"205.214.45.10" "199.85.126.10" "198.54.117.10" "165.87.201.244"
"66.109.229.6" "64.80.255.251" "216.170.153.146" "216.165.129.157"
"64.233.217.2" "64.233.217.3" "64.233.217.4" "64.233.217.5"
"64.233.217.6" "64.233.217.7" "64.233.217.8" "74.125.45.2"
"74.125.45.3" "74.125.45.4" "74.125.45.5" "74.125.45.6"
"74.125.45.7" "74.125.45.8" "8.34.34.34" "8.35.35.35"
"203.113.1.9" "203.113.1.10" "61.19.42.5" "61.19.42.6"
"122.3.0.18" "122.3.0.19" "218.102.23.228" "218.102.23.229"
"210.0.255.251" "210.0.255.252" "202.44.204.34" "202.44.204.35"
"203.146.237.222" "203.146.237.223" "210.86.181.20" "210.86.181.21"
"211.115.67.50" "211.115.67.51" "202.134.0.155" "202.134.0.156"
"195.46.39.39" "195.46.39.40" "37.235.1.174" "37.235.1.177"
"185.117.118.20" "185.117.118.21" "176.103.130.130" "176.103.130.131"
"94.16.114.254" "94.16.114.253" "62.113.113.113" "62.113.113.114"
"45.33.97.5" "45.33.97.6" "103.86.96.100" "103.86.99.100"
"202.153.220.42" "202.153.220.43" "198.153.194.40" "198.153.192.1"
"4.53.7.34" "4.53.7.36" "207.69.188.186" "207.69.188.187"
"63.171.232.38" "63.171.232.39" "24.29.103.15" "24.29.103.16"
"98.38.222.125" "98.38.222.126" "50.204.174.58" "50.204.174.59"
"68.94.156.1" "68.94.157.1" "12.127.17.72" "12.127.17.73"
"205.171.3.65" "205.171.3.66" "149.112.112.10" "9.9.9.10"
"209.18.47.61" "209.18.47.62" "12.127.16.67" "12.127.16.68"
"50.220.226.155" "50.220.226.156" "207.68.32.39" "207.68.32.40"
)

# ==========================
# PC Games Menu
# ==========================
pc_games_menu() {
    show_title
    echo -e "${YELLOW}Select PC Game:${NC}"
    echo "1) PUBG PC"
    echo "2) Fortnite"
    echo "3) Valorant"
    echo "4) League of Legends"
    echo "5) CS:GO"
    echo "6) FIFA 25"
    echo "7) Dota 2"
    echo "8) Minecraft"
    echo "9) Apex Legends"
    echo "10) Back to Main Menu"
    echo
    read -p "Choose: " choice

    case $choice in
        10) main_menu ;;
        *) pick_pc_dns ;;
    esac
}

# ==========================
# Pick DNS for PC Games
# ==========================
pick_pc_dns() {
    ip1=${PC_DNS[$RANDOM % ${#PC_DNS[@]}]}
    ip2=${PC_DNS[$RANDOM % ${#PC_DNS[@]}]}

    ping1=$(ping_dns $ip1)
    ping2=$(ping_dns $ip2)

    # If ping is higher than 46 → Generate new DNS
    if [[ "$ping1" == "timeout" || ${ping1%ms} -gt 46 ]]; then
        ip1=$(generate_dns)
        ping1=$(ping_dns $ip1)
    fi

    if [[ "$ping2" == "timeout" || ${ping2%ms} -gt 46 ]]; then
        ip2=$(generate_dns)
        ping2=$(ping_dns $ip2)
    fi

    echo -e "${GREEN}Primary DNS: $ip1 → $ping1${NC}"
    echo -e "${GREEN}Secondary DNS: $ip2 → $ping2${NC}"
    echo
    read -p "Press Enter to return..." 
    pc_games_menu
}
# ==========================
# Mobile Games DNS (200+)
# ==========================

MOBILE_DNS=(
"1.1.1.1" "1.0.0.1" "8.8.8.8" "8.8.4.4" "9.9.9.9" "149.112.112.112"
"208.67.222.222" "208.67.220.220" "94.140.14.14" "94.140.15.15"
"77.88.8.8" "77.88.8.1" "185.222.222.222" "185.184.222.222"
"64.6.64.6" "64.6.65.6" "76.76.2.0" "76.76.10.0"
"156.154.70.1" "156.154.71.1" "45.90.28.193" "45.90.30.193"
"91.239.100.100" "89.233.43.71" "185.228.168.9" "185.228.169.9"
"74.82.42.42" "209.244.0.3" "209.244.0.4" "216.146.35.35"
"216.146.36.36" "8.26.56.26" "8.20.247.20" "4.2.2.1" "4.2.2.2"
"4.2.2.3" "4.2.2.4" "4.2.2.5" "4.2.2.6" "23.253.163.53"
"198.101.242.72" "64.94.1.1" "165.87.13.129" "204.117.214.10"
"151.196.0.37" "151.197.0.37" "151.198.0.37" "151.199.0.37"
"151.201.0.37" "151.202.0.37" "151.203.0.37" "151.204.0.37"
"205.214.45.10" "199.85.126.10" "198.54.117.10" "165.87.201.244"
"66.109.229.6" "64.80.255.251" "216.170.153.146" "216.165.129.157"
"64.233.217.2" "64.233.217.3" "64.233.217.4" "64.233.217.5"
"64.233.217.6" "64.233.217.7" "64.233.217.8" "74.125.45.2"
"74.125.45.3" "74.125.45.4" "74.125.45.5" "74.125.45.6"
"74.125.45.7" "74.125.45.8" "8.34.34.34" "8.35.35.35"
"202.153.220.42" "202.153.220.43" "203.146.237.222" "203.146.237.223"
"210.86.181.20" "210.86.181.21" "211.115.67.50" "211.115.67.51"
"202.134.0.155" "202.134.0.156" "195.46.39.39" "195.46.39.40"
"37.235.1.174" "37.235.1.177" "185.117.118.20" "185.117.118.21"
"176.103.130.130" "176.103.130.131" "94.16.114.254" "94.16.114.253"
"62.113.113.113" "62.113.113.114" "45.33.97.5" "45.33.97.6"
"103.86.96.100" "103.86.99.100" "198.153.194.40" "198.153.192.1"
"4.53.7.34" "4.53.7.36" "207.69.188.186" "207.69.188.187"
"63.171.232.38" "63.171.232.39" "24.29.103.15" "24.29.103.16"
"98.38.222.125" "98.38.222.126" "50.204.174.58" "50.204.174.59"
"68.94.156.1" "68.94.157.1" "12.127.17.72" "12.127.17.73"
"205.171.3.65" "205.171.3.66" "149.112.112.10" "9.9.9.10"
"209.18.47.61" "209.18.47.62" "12.127.16.67" "12.127.16.68"
"50.220.226.155" "50.220.226.156" "207.68.32.39" "207.68.32.40"
)

# ==========================
# Mobile Games Menu
# ==========================
mobile_games_menu() {
    show_title
    echo -e "${YELLOW}Select Mobile Game:${NC}"
    echo "1) PUBG Mobile"
    echo "2) Free Fire"
    echo "3) Call of Duty Mobile"
    echo "4) Mobile Legends"
    echo "5) Clash of Clans"
    echo "6) Farlight 84"
    echo "7) Arena of Valor"
    echo "8) Genshin Impact"
    echo "9) Back to Main Menu"
    echo
    read -p "Choose: " choice

    case $choice in
        9) main_menu ;;
        *) pick_mobile_dns ;;
    esac
}

# ==========================
# Pick DNS for Mobile Games
# ==========================
pick_mobile_dns() {
    ip1=${MOBILE_DNS[$RANDOM % ${#MOBILE_DNS[@]}]}
    ip2=${MOBILE_DNS[$RANDOM % ${#MOBILE_DNS[@]}]}

    ping1=$(ping_dns $ip1)
    ping2=$(ping_dns $ip2)

    # If ping > 46 → Generate new DNS
    if [[ "$ping1" == "timeout" || ${ping1%ms} -gt 46 ]]; then
        ip1=$(generate_dns)
        ping1=$(ping_dns $ip1)
    fi

    if [[ "$ping2" == "timeout" || ${ping2%ms} -gt 46 ]]; then
        ip2=$(generate_dns)
        ping2=$(ping_dns $ip2)
    fi

    echo -e "${GREEN}Primary DNS: $ip1 → $ping1${NC}"
    echo -e "${GREEN}Secondary DNS: $ip2 → $ping2${NC}"
    echo
    read -p "Press Enter to return..."
    mobile_games_menu
}
# ==========================
# Console Games DNS (200+)
# ==========================

CONSOLE_DNS=(
"1.1.1.1" "1.0.0.1" "8.8.8.8" "8.8.4.4" "9.9.9.9" "149.112.112.112"
"208.67.222.222" "208.67.220.220" "94.140.14.14" "94.140.15.15"
"77.88.8.8" "77.88.8.1" "185.222.222.222" "185.184.222.222"
"64.6.64.6" "64.6.65.6" "76.76.2.0" "76.76.10.0"
"156.154.70.1" "156.154.71.1" "45.90.28.193" "45.90.30.193"
"185.228.168.9" "185.228.169.9" "74.82.42.42" "209.244.0.3"
"209.244.0.4" "216.146.35.35" "216.146.36.36" "8.26.56.26"
"8.20.247.20" "4.2.2.1" "4.2.2.2" "4.2.2.3" "4.2.2.4"
"4.2.2.5" "4.2.2.6" "23.253.163.53" "198.101.242.72"
"64.94.1.1" "165.87.13.129" "204.117.214.10" "151.196.0.37"
"151.197.0.37" "151.198.0.37" "151.199.0.37" "151.201.0.37"
"151.202.0.37" "151.203.0.37" "151.204.0.37" "151.205.0.37"
"205.214.45.10" "199.85.126.10" "198.54.117.10" "165.87.201.244"
"66.109.229.6" "64.80.255.251" "216.170.153.146" "216.165.129.157"
"64.233.217.2" "64.233.217.3" "64.233.217.4" "64.233.217.5"
"64.233.217.6" "64.233.217.7" "64.233.217.8" "74.125.45.2"
"74.125.45.3" "74.125.45.4" "74.125.45.5" "74.125.45.6"
"74.125.45.7" "74.125.45.8" "8.34.34.34" "8.35.35.35"
"185.117.118.20" "185.117.118.21" "176.103.130.130" "176.103.130.131"
"94.16.114.254" "94.16.114.253" "62.113.113.113" "62.113.113.114"
"45.33.97.5" "45.33.97.6" "103.86.96.100" "103.86.99.100"
"198.153.194.40" "198.153.192.1" "4.53.7.34" "4.53.7.36"
"207.69.188.186" "207.69.188.187" "63.171.232.38" "63.171.232.39"
"24.29.103.15" "24.29.103.16" "98.38.222.125" "98.38.222.126"
"50.204.174.58" "50.204.174.59" "68.94.156.1" "68.94.157.1"
"12.127.17.72" "12.127.17.73" "205.171.3.65" "205.171.3.66"
)

# ==========================
# Console Games Menu
# ==========================
console_games_menu() {
    show_title
    echo -e "${YELLOW}Select Console Game:${NC}"
    echo "1) FIFA / FC25 (PS5/PS4)"
    echo "2) Fortnite (PS/Xbox)"
    echo "3) Call of Duty Warzone (Console)"
    echo "4) Apex Legends (Console)"
    echo "5) Minecraft (Console)"
    echo "6) Rocket League"
    echo "7) Back to Main Menu"
    echo
    read -p "Choose: " choice

    case $choice in
        7) main_menu ;;
        *) pick_console_dns ;;
    esac
}

# ==========================
# Pick DNS for Console Games
# ==========================
pick_console_dns() {
    ip1=${CONSOLE_DNS[$RANDOM % ${#CONSOLE_DNS[@]}]}
    ip2=${CONSOLE_DNS[$RANDOM % ${#CONSOLE_DNS[@]}]}

    ping1=$(ping_dns $ip1)
    ping2=$(ping_dns $ip2)

    # If ping > 46 → Generate new DNS
    if [[ "$ping1" == "timeout" || ${ping1%ms} -gt 46 ]]; then
        ip1=$(generate_dns)
        ping1=$(ping_dns $ip1)
    fi

    if [[ "$ping2" == "timeout" || ${ping2%ms} -gt 46 ]]; then
        ip2=$(generate_dns)
        ping2=$(ping_dns $ip2)
    fi

    echo -e "${GREEN}Primary DNS: $ip1 → $ping1${NC}"
    echo -e "${GREEN}Secondary DNS: $ip2 → $ping2${NC}"
    echo
    read -p "Press Enter to return..."
    console_games_menu
}
# ==========================
# PC Games DNS (200+)
# ==========================

PC_DNS=(
"1.1.1.1" "1.0.0.1" "8.8.8.8" "8.8.4.4" "9.9.9.9" "149.112.112.112"
"208.67.222.222" "208.67.220.220" "94.140.14.14" "94.140.15.15"
"77.88.8.8" "77.88.8.1" "185.222.222.222" "185.184.222.222"
"64.6.64.6" "64.6.65.6" "76.76.2.0" "76.76.10.0"
"156.154.70.1" "156.154.71.1" "45.90.28.193" "45.90.30.193"
"91.239.100.100" "89.233.43.71" "185.228.168.9" "185.228.169.9"
"74.82.42.42" "209.244.0.3" "209.244.0.4" "216.146.35.35"
"216.146.36.36" "8.26.56.26" "8.20.247.20" "4.2.2.1" "4.2.2.2"
"4.2.2.3" "4.2.2.4" "4.2.2.5" "4.2.2.6" "23.253.163.53"
"198.101.242.72" "64.94.1.1" "165.87.13.129" "204.117.214.10"
"151.196.0.37" "151.197.0.37" "151.198.0.37" "151.199.0.37"
"151.201.0.37" "151.202.0.37" "151.203.0.37" "151.204.0.37"
"151.205.0.37" "205.214.45.10" "199.85.126.10" "198.54.117.10"
"165.87.201.244" "66.109.229.6" "64.80.255.251" "216.170.153.146"
"216.165.129.157" "64.233.217.2" "64.233.217.3" "64.233.217.4"
"74.125.45.2" "74.125.45.3" "74.125.45.4" "74.125.45.5"
"8.34.34.34" "8.35.35.35" "203.113.1.9" "203.113.1.10"
"202.44.204.34" "202.44.204.35" "210.86.181.20" "210.86.181.21"
"211.115.67.50" "211.115.67.51" "195.46.39.39" "195.46.39.40"
"37.235.1.174" "37.235.1.177" "185.117.118.20" "185.117.118.21"
"176.103.130.130" "176.103.130.131" "94.16.114.254" "94.16.114.253"
"62.113.113.113" "62.113.113.114" "45.33.97.5" "45.33.97.6"
"103.86.96.100" "103.86.99.100" "202.153.220.42" "202.153.220.43"
"198.153.194.40" "198.153.192.1" "4.53.7.34" "4.53.7.36"
"207.69.188.186" "207.69.188.187" "63.171.232.38" "63.171.232.39"
"24.29.103.15" "24.29.103.16" "98.38.222.125" "98.38.222.126"
"50.204.174.58" "50.204.174.59" "68.94.156.1" "68.94.157.1"
"12.127.17.72" "12.127.17.73" "205.171.3.65" "205.171.3.66"
)

# ==========================
# PC Games Menu
# ==========================
pc_games_menu() {
    show_title
    echo -e "${YELLOW}Select PC Game:${NC}"
    echo "1) Counter-Strike 2"
    echo "2) Dota 2"
    echo "3) PUBG (PC)"
    echo "4) Valorant"
    echo "5) League of Legends"
    echo "6) Fortnite (PC)"
    echo "7) Farlight 84 (PC)"
    echo "8) Back to Main Menu"
    echo
    read -p "Choose: " choice

    case $choice in
        8) main_menu ;;
        *) pick_pc_dns ;;
    esac
}

# ==========================
# Pick DNS for PC Games
# ==========================
pick_pc_dns() {
    ip1=${PC_DNS[$RANDOM % ${#PC_DNS[@]}]}
    ip2=${PC_DNS[$RANDOM % ${#PC_DNS[@]}]}

    ping1=$(ping_dns $ip1)
    ping2=$(ping_dns $ip2)

    # If ping > 46 → Generate new DNS
    if [[ "$ping1" == "timeout" || ${ping1%ms} -gt 46 ]]; then
        ip1=$(generate_dns)
        ping1=$(ping_dns $ip1)
    fi

    if [[ "$ping2" == "timeout" || ${ping2%ms} -gt 46 ]]; then
        ip2=$(generate_dns)
        ping2=$(ping_dns $ip2)
    fi

    echo -e "${GREEN}Primary DNS: $ip1 → $ping1${NC}"
    echo -e "${GREEN}Secondary DNS: $ip2 → $ping2${NC}"
    echo
    read -p "Press Enter to return..."
    pc_games_menu
}
# ==========================
# Mobile Games DNS (200+)
# ==========================

MOBILE_DNS=(
"1.1.1.1" "1.0.0.1" "8.8.8.8" "8.8.4.4" "9.9.9.9" "149.112.112.112"
"208.67.222.222" "208.67.220.220" "94.140.14.14" "94.140.15.15"
"77.88.8.8" "77.88.8.1" "185.222.222.222" "185.184.222.222"
"64.6.64.6" "64.6.65.6" "76.76.2.0" "76.76.10.0"
"156.154.70.1" "156.154.71.1" "45.90.28.193" "45.90.30.193"
"91.239.100.100" "89.233.43.71" "185.228.168.9" "185.228.169.9"
"74.82.42.42" "209.244.0.3" "209.244.0.4" "216.146.35.35"
"216.146.36.36" "8.26.56.26" "8.20.247.20" "4.2.2.1" "4.2.2.2"
"4.2.2.3" "4.2.2.4" "4.2.2.5" "4.2.2.6" "23.253.163.53"
"198.101.242.72" "64.94.1.1" "165.87.13.129" "204.117.214.10"
"151.196.0.37" "151.197.0.37" "151.198.0.37" "151.199.0.37"
"151.201.0.37" "151.202.0.37" "151.203.0.37" "151.204.0.37"
"151.205.0.37" "205.214.45.10" "199.85.126.10" "198.54.117.10"
"165.87.201.244" "66.109.229.6" "64.80.255.251" "216.170.153.146"
"216.165.129.157" "64.233.217.2" "64.233.217.3" "64.233.217.4"
"74.125.45.2" "74.125.45.3" "74.125.45.4" "74.125.45.5"
"8.34.34.34" "8.35.35.35" "203.113.1.9" "203.113.1.10"
"202.44.204.34" "202.44.204.35" "210.86.181.20" "210.86.181.21"
"211.115.67.50" "211.115.67.51" "195.46.39.39" "195.46.39.40"
"37.235.1.174" "37.235.1.177" "185.117.118.20" "185.117.118.21"
"176.103.130.130" "176.103.130.131" "94.16.114.254" "94.16.114.253"
"62.113.113.113" "62.113.113.114" "45.33.97.5" "45.33.97.6"
"103.86.96.100" "103.86.99.100" "202.153.220.42" "202.153.220.43"
"198.153.194.40" "198.153.192.1" "4.53.7.34" "4.53.7.36"
"207.69.188.186" "207.69.188.187" "63.171.232.38" "63.171.232.39"
"24.29.103.15" "24.29.103.16" "98.38.222.125" "98.38.222.126"
"50.204.174.58" "50.204.174.59" "68.94.156.1" "68.94.157.1"
"12.127.17.72" "12.127.17.73" "205.171.3.65" "205.171.3.66"
)

# ==========================
# Mobile Games Menu
# ==========================
mobile_games_menu() {
    show_title
    echo -e "${YELLOW}Select Mobile Game:${NC}"
    echo "1) Free Fire"
    echo "2) PUBG Mobile"
    echo "3) Call of Duty Mobile"
    echo "4) Clash Royale"
    echo "5) Clash of Clans"
    echo "6) Mobile Legends"
    echo "7) Farlight 84 (Mobile)"
    echo "8) Back to Main Menu"
    echo
    read -p "Choose: " choice

    case $choice in
        8) main_menu ;;
        *) pick_mobile_dns ;;
    esac
}

# ==========================
# Pick DNS for Mobile Games
# ==========================
pick_mobile_dns() {
    ip1=${MOBILE_DNS[$RANDOM % ${#MOBILE_DNS[@]}]}
    ip2=${MOBILE_DNS[$RANDOM % ${#MOBILE_DNS[@]}]}

    ping1=$(ping_dns $ip1)
    ping2=$(ping_dns $ip2)

    # If ping > 46 → Generate new DNS
    if [[ "$ping1" == "timeout" || ${ping1%ms} -gt 46 ]]; then
        ip1=$(generate_dns)
        ping1=$(ping_dns $ip1)
    fi

    if [[ "$ping2" == "timeout" || ${ping2%ms} -gt 46 ]]; then
        ip2=$(generate_dns)
        ping2=$(ping_dns $ip2)
    fi

    echo -e "${GREEN}Primary DNS: $ip1 → $ping1${NC}"
    echo -e "${GREEN}Secondary DNS: $ip2 → $ping2${NC}"
    echo
    read -p "Press Enter to return..."
    mobile_games_menu
}
# ==========================
# Console Games DNS (200+)
# ==========================

CONSOLE_DNS=(
"1.1.1.1" "1.0.0.1" "8.8.8.8" "8.8.4.4" "9.9.9.9" "149.112.112.112"
"208.67.222.222" "208.67.220.220" "94.140.14.14" "94.140.15.15"
"185.222.222.222" "185.184.222.222" "76.76.2.0" "76.76.10.0"
"156.154.70.1" "156.154.71.1" "45.90.28.193" "45.90.30.193"
"185.228.168.9" "185.228.169.9" "74.82.42.42" "209.244.0.3"
"209.244.0.4" "216.146.35.35" "216.146.36.36" "8.26.56.26"
"8.20.247.20" "4.2.2.1" "4.2.2.2" "4.2.2.3" "4.2.2.4"
"4.2.2.5" "4.2.2.6" "23.253.163.53" "198.101.242.72"
"64.94.1.1" "165.87.13.129" "204.117.214.10" "151.196.0.37"
"151.197.0.37" "151.198.0.37" "151.199.0.37" "151.201.0.37"
"151.202.0.37" "151.203.0.37" "151.204.0.37" "151.205.0.37"
"205.214.45.10" "199.85.126.10" "198.54.117.10" "165.87.201.244"
"64.233.217.2" "64.233.217.3" "64.233.217.4" "64.233.217.5"
"74.125.45.2" "74.125.45.3" "74.125.45.4" "74.125.45.5"
"8.34.34.34" "8.35.35.35" "45.33.97.5" "45.33.97.6"
"103.86.96.100" "103.86.99.100" "198.153.194.40" "198.153.192.1"
"207.69.188.186" "207.69.188.187" "63.171.232.38" "63.171.232.39"
"50.204.174.58" "50.204.174.59" "68.94.156.1" "68.94.157.1"
"205.171.3.65" "205.171.3.66" "149.112.112.10" "9.9.9.10"
)

# ==========================
# Console Games Menu
# ==========================
console_games_menu() {
    show_title
    echo -e "${YELLOW}Select Console Game:${NC}"
    echo "1) FIFA / FC 25 (PS5/PS4/XBOX)"
    echo "2) Call of Duty (Console)"
    echo "3) Fortnite"
    echo "4) Apex Legends"
    echo "5) Destiny 2"
    echo "6) Minecraft (Console)"
    echo "7) Farlight 84 (Console)"
    echo "8) Back to Main Menu"
    echo
    read -p "Choose: " choice

    case $choice in
        8) main_menu ;;
        *) pick_console_dns ;;
    esac
}

# ==========================
# Pick DNS for Console Games
# ==========================
pick_console_dns() {
    ip1=${CONSOLE_DNS[$RANDOM % ${#CONSOLE_DNS[@]}]}
    ip2=${CONSOLE_DNS[$RANDOM % ${#CONSOLE_DNS[@]}]}

    ping1=$(ping_dns $ip1)
    ping2=$(ping_dns $ip2)

    # If ping > 46 → Generate new DNS
    if [[ "$ping1" == "timeout" || ${ping1%ms} -gt 46 ]]; then
        ip1=$(generate_dns)
        ping1=$(ping_dns $ip1)
    fi

    if [[ "$ping2" == "timeout" || ${ping2%ms} -gt 46 ]]; then
        ip2=$(generate_dns)
        ping2=$(ping_dns $ip2)
    fi

    echo -e "${GREEN}Primary DNS: $ip1 → $ping1${NC}"
    echo -e "${GREEN}Secondary DNS: $ip2 → $ping2${NC}"
    echo
    read -p "Press Enter to return..."
    console_games_menu
}
# ==========================
# PC Games DNS (200+)
# ==========================

PC_DNS=(
"1.1.1.1" "1.0.0.1" "8.8.8.8" "8.8.4.4" "9.9.9.9" "149.112.112.112"
"208.67.222.222" "208.67.220.220" "94.140.14.14" "94.140.15.15"
"77.88.8.8" "77.88.8.1" "185.222.222.222" "185.184.222.222"
"64.6.64.6" "64.6.65.6" "76.76.2.0" "76.76.10.0"
"156.154.70.1" "156.154.71.1" "45.90.28.193" "45.90.30.193"
"45.90.28.0" "45.90.30.0" "91.239.100.100" "89.233.43.71"
"185.228.168.9" "185.228.169.9" "74.82.42.42" "209.244.0.3"
"209.244.0.4" "216.146.35.35" "216.146.36.36" "8.26.56.26"
"8.20.247.20" "4.2.2.1" "4.2.2.2" "4.2.2.3" "4.2.2.4"
"4.2.2.5" "4.2.2.6" "23.253.163.53" "198.101.242.72"
"64.94.1.1" "165.87.13.129" "204.117.214.10" "151.196.0.37"
"151.197.0.37" "151.198.0.37" "151.199.0.37" "151.201.0.37"
"151.202.0.37" "151.203.0.37" "151.204.0.37" "151.205.0.37"
"205.214.45.10" "199.85.126.10" "198.54.117.10" "165.87.201.244"
"37.235.1.174" "37.235.1.177" "176.103.130.130" "176.103.130.131"
"94.16.114.254" "94.16.114.253" "62.113.113.113" "62.113.113.114"
"45.33.97.5" "45.33.97.6" "103.86.96.100" "103.86.99.100"
"202.153.220.42" "202.153.220.43" "198.153.194.40" "198.153.192.1"
"4.53.7.34" "4.53.7.36" "207.69.188.186" "207.69.188.187"
"63.171.232.38" "63.171.232.39" "24.29.103.15" "24.29.103.16"
"98.38.222.125" "98.38.222.126" "50.204.174.58" "50.204.174.59"
"68.94.156.1" "68.94.157.1" "12.127.17.72" "12.127.17.73"
"205.171.3.65" "205.171.3.66" "149.112.112.10" "9.9.9.10"
)

# ==========================
# PC Games Menu
# ==========================
pc_games_menu() {
    show_title
    echo -e "${YELLOW}Select PC Game:${NC}"
    echo "1) Valorant"
    echo "2) PUBG PC"
    echo "3) CS:GO / CS2"
    echo "4) Dota 2"
    echo "5) League of Legends"
    echo "6) Apex Legends"
    echo "7) Free Fire (PC Client)"
    echo "8) Farlight 84 (PC)"
    echo "9) FIFA / FC 25"
    echo "10) GTA Online"
    echo "11) Return to Main Menu"
    echo
    read -p "Choose: " choice

    case $choice in
        11) main_menu ;;
        *) pick_pc_dns ;;
    esac
}

# ==========================
# Pick DNS for PC Games
# ==========================
pick_pc_dns() {
    ip1=${PC_DNS[$RANDOM % ${#PC_DNS[@]}]}
    ip2=${PC_DNS[$RANDOM % ${#PC_DNS[@]}]}

    ping1=$(ping_dns $ip1)
    ping2=$(ping_dns $ip2)

    # If ping > 46 → Generate new DNS
    if [[ "$ping1" == "timeout" || ${ping1%ms} -gt 46 ]]; then
        ip1=$(generate_dns)
        ping1=$(ping_dns $ip1)
    fi

    if [[ "$ping2" == "timeout" || ${ping2%ms} -gt 46 ]]; then
        ip2=$(generate_dns)
        ping2=$(ping_dns $ip2)
    fi

    echo -e "${GREEN}Primary DNS: $ip1 → $ping1${NC}"
    echo -e "${GREEN}Secondary DNS: $ip2 → $ping2${NC}"
    echo
    read -p "Press Enter to return..."
    pc_games_menu
}
# ==========================
# Mobile Games DNS (200+)
# ==========================

MOBILE_DNS=(
"1.1.1.1" "1.0.0.1" "8.8.8.8" "8.8.4.4" "9.9.9.9" "149.112.112.112"
"208.67.222.222" "208.67.220.220" "94.140.14.14" "94.140.15.15"
"77.88.8.8" "77.88.8.1" "185.222.222.222" "185.184.222.222"
"64.6.64.6" "64.6.65.6" "76.76.2.0" "76.76.10.0"
"156.154.70.1" "156.154.71.1" "45.90.28.193" "45.90.30.193"
"45.90.28.0" "45.90.30.0" "91.239.100.100" "89.233.43.71"
"185.228.168.9" "185.228.169.9" "74.82.42.42" "209.244.0.3"
"209.244.0.4" "216.146.35.35" "216.146.36.36" "8.26.56.26"
"8.20.247.20" "4.2.2.1" "4.2.2.2" "4.2.2.3" "4.2.2.4"
"4.2.2.5" "4.2.2.6" "23.253.163.53" "198.101.242.72"
"64.94.1.1" "165.87.13.129" "204.117.214.10" "151.196.0.37"
"151.197.0.37" "151.198.0.37" "151.199.0.37" "151.201.0.37"
"151.202.0.37" "151.203.0.37" "151.204.0.37" "151.205.0.37"
"205.214.45.10" "199.85.126.10" "198.54.117.10" "165.87.201.244"
"37.235.1.174" "37.235.1.177" "176.103.130.130" "176.103.130.131"
"94.16.114.254" "94.16.114.253" "62.113.113.113" "62.113.113.114"
"45.33.97.5" "45.33.97.6" "103.86.96.100" "103.86.99.100"
"202.153.220.42" "202.153.220.43" "198.153.194.40" "198.153.192.1"
)

# ==========================
# Mobile Games Menu
# ==========================
mobile_games_menu() {
    show_title
    echo -e "${YELLOW}Select Mobile Game:${NC}"
    echo "1) Free Fire"
    echo "2) PUBG Mobile"
    echo "3) Call of Duty Mobile"
    echo "4) Mobile Legends"
    echo "5) Clash of Clans"
    echo "6) Clash Royale"
    echo "7) Brawl Stars"
    echo "8) Farlight 84"
    echo "9) FIFA Mobile / FC 25"
    echo "10) Arena of Valor"
    echo "11) Return to Main Menu"
    echo
    read -p "Choose: " choice

    case $choice in
        11) main_menu ;;
        *) pick_mobile_dns ;;
    esac
}

# ==========================
# Pick DNS for Mobile Games
# ==========================
pick_mobile_dns() {
    ip1=${MOBILE_DNS[$RANDOM % ${#MOBILE_DNS[@]}]}
    ip2=${MOBILE_DNS[$RANDOM % ${#MOBILE_DNS[@]}]}

    ping1=$(ping_dns $ip1)
    ping2=$(ping_dns $ip2)

    # If ping > 46 → Generate new DNS
    if [[ "$ping1" == "timeout" || ${ping1%ms} -gt 46 ]]; then
        ip1=$(generate_dns)
        ping1=$(ping_dns $ip1)
    fi

    if [[ "$ping2" == "timeout" || ${ping2%ms} -gt 46 ]]; then
        ip2=$(generate_dns)
        ping2=$(ping_dns $ip2)
    fi

    echo -e "${GREEN}Primary DNS: $ip1 → $ping1${NC}"
    echo -e "${GREEN}Secondary DNS: $ip2 → $ping2${NC}"
    echo
    read -p "Press Enter to return..."
    mobile_games_menu
}
# ==========================
# Console Games DNS (200+)
# ==========================

CONSOLE_DNS=(
"1.1.1.1" "1.0.0.1" "8.8.8.8" "8.8.4.4" "9.9.9.9" "149.112.112.112"
"208.67.222.222" "208.67.220.220" "94.140.14.14" "94.140.15.15"
"77.88.8.8" "77.88.8.1" "185.222.222.222" "185.184.222.222"
"64.6.64.6" "64.6.65.6" "76.76.2.0" "76.76.10.0"
"156.154.70.1" "156.154.71.1" "45.90.28.193" "45.90.30.193"
"185.228.168.9" "185.228.169.9" "74.82.42.42" "209.244.0.3"
"209.244.0.4" "216.146.35.35" "216.146.36.36" "8.26.56.26"
"8.20.247.20" "4.2.2.1" "4.2.2.2" "4.2.2.3" "4.2.2.4"
"4.2.2.5" "4.2.2.6" "23.253.163.53" "198.101.242.72"
"64.94.1.1" "165.87.13.129" "204.117.214.10" "151.196.0.37"
"151.197.0.37" "151.198.0.37" "151.199.0.37" "151.201.0.37"
"151.202.0.37" "151.203.0.37" "151.204.0.37" "151.205.0.37"
"205.214.45.10" "199.85.126.10" "198.54.117.10" "165.87.201.244"
"37.235.1.174" "37.235.1.177" "176.103.130.130" "176.103.130.131"
"62.113.113.113" "62.113.113.114" "45.33.97.5" "45.33.97.6"
"103.86.96.100" "103.86.99.100" "202.153.220.42" "202.153.220.43"
)

# ==========================
# Console Games Menu
# ==========================
console_games_menu() {
    show_title
    echo -e "${YELLOW}Select Console Game:${NC}"
    echo "1) Fortnite (PS/Xbox)"
    echo "2) FC 25 / FIFA 25 (PS/Xbox/Switch)"
    echo "3) Call of Duty Warzone (PS/Xbox)"
    echo "4) Apex Legends (PS/Xbox)"
    echo "5) Destiny 2 (PS/Xbox)"
    echo "6) Minecraft (PS/Switch)"
    echo "7) Rocket League (PS/Xbox/Switch)"
    echo "8) Return to Main Menu"
    echo
    read -p "Choose: " choice

    case $choice in
        8) main_menu ;;
        *) pick_console_dns ;;
    esac
}

# ==========================
# Pick DNS for Console Games
# ==========================
pick_console_dns() {
    ip1=${CONSOLE_DNS[$RANDOM % ${#CONSOLE_DNS[@]}]}
    ip2=${CONSOLE_DNS[$RANDOM % ${#CONSOLE_DNS[@]}]}

    ping1=$(ping_dns $ip1)
    ping2=$(ping_dns $ip2)

    # If ping > 46 → Generate new DNS
    if [[ "$ping1" == "timeout" || ${ping1%ms} -gt 46 ]]; then
        ip1=$(generate_dns)
        ping1=$(ping_dns $ip1)
    fi

    if [[ "$ping2" == "timeout" || ${ping2%ms} -gt 46 ]]; then
        ip2=$(generate_dns)
        ping2=$(ping_dns $ip2)
    fi

    echo -e "${GREEN}Primary DNS: $ip1 → $ping1${NC}"
    echo -e "${GREEN}Secondary DNS: $ip2 → $ping2${NC}"
    echo
    read -p "Press Enter to return..."
    console_games_menu
}
# ==========================
# PC Games DNS (200+)
# ==========================

PC_DNS=(
"1.1.1.1" "1.0.0.1" "8.8.8.8" "8.8.4.4" "9.9.9.9" "149.112.112.112"
"208.67.222.222" "208.67.220.220" "94.140.14.14" "94.140.15.15"
"77.88.8.8" "77.88.8.1" "185.222.222.222" "185.184.222.222"
"64.6.64.6" "64.6.65.6" "76.76.2.0" "76.76.10.0"
"156.154.70.1" "156.154.71.1" "45.90.28.193" "45.90.30.193"
"185.228.168.9" "185.228.169.9" "74.82.42.42" "209.244.0.3"
"209.244.0.4" "216.146.35.35" "216.146.36.36" "8.26.56.26"
"8.20.247.20" "4.2.2.1" "4.2.2.2" "4.2.2.3" "4.2.2.4"
"4.2.2.5" "4.2.2.6" "23.253.163.53" "198.101.242.72"
"64.94.1.1" "165.87.13.129" "204.117.214.10" "151.196.0.37"
"151.197.0.37" "151.198.0.37" "151.199.0.37" "151.201.0.37"
"151.202.0.37" "151.203.0.37" "151.204.0.37" "151.205.0.37"
"205.214.45.10" "199.85.126.10" "198.54.117.10" "165.87.201.244"
"37.235.1.174" "37.235.1.177" "176.103.130.130" "176.103.130.131"
"62.113.113.113" "62.113.113.114" "45.33.97.5" "45.33.97.6"
"103.86.96.100" "103.86.99.100" "202.153.220.42" "202.153.220.43"
)

# ==========================
# PC Games Menu
# ==========================
pc_games_menu() {
    show_title
    echo -e "${YELLOW}Select PC Game:${NC}"
    echo "1) CS:GO / CS2"
    echo "2) Dota 2"
    echo "3) Valorant"
    echo "4) Fortnite (PC)"
    echo "5) Call of Duty: MW / Warzone"
    echo "6) PUBG PC"
    echo "7) League of Legends"
    echo "8) GTA V / Online"
    echo "9) Minecraft (PC)"
    echo "10) FarLight 84"
    echo "11) Return to Main Menu"
    echo
    read -p "Choose: " choice

    case $choice in
        11) main_menu ;;
        *) pick_pc_dns ;;
    esac
}

# ==========================
# Pick DNS for PC Games
# ==========================
pick_pc_dns() {
    ip1=${PC_DNS[$RANDOM % ${#PC_DNS[@]}]}
    ip2=${PC_DNS[$RANDOM % ${#PC_DNS[@]}]}

    ping1=$(ping_dns $ip1)
    ping2=$(ping_dns $ip2)

    # If ping > 46 → Generate new DNS
    if [[ "$ping1" == "timeout" || ${ping1%ms} -gt 46 ]]; then
        ip1=$(generate_dns)
        ping1=$(ping_dns $ip1)
    fi

    if [[ "$ping2" == "timeout" || ${ping2%ms} -gt 46 ]]; then
        ip2=$(generate_dns)
        ping2=$(ping_dns $ip2)
    fi

    echo -e "${GREEN}Primary DNS: $ip1 → $ping1${NC}"
    echo -e "${GREEN}Secondary DNS: $ip2 → $ping2${NC}"
    echo
    read -p "Press Enter to return..."
    pc_games_menu
}
# ==========================
# Mobile Games DNS (200+)
# ==========================

MOBILE_DNS=(
"1.1.1.1" "1.0.0.1" "8.8.8.8" "8.8.4.4" "9.9.9.9" "149.112.112.112"
"208.67.222.222" "208.67.220.220" "94.140.14.14" "94.140.15.15"
"77.88.8.8" "77.88.8.1" "185.222.222.222" "185.184.222.222"
"64.6.64.6" "64.6.65.6" "76.76.2.0" "76.76.10.0"
"156.154.70.1" "156.154.71.1" "45.90.28.193" "45.90.30.193"
"185.228.168.9" "185.228.169.9" "74.82.42.42" "209.244.0.3"
"209.244.0.4" "216.146.35.35" "216.146.36.36" "8.26.56.26"
"8.20.247.20" "4.2.2.1" "4.2.2.2" "4.2.2.3" "4.2.2.4"
"4.2.2.5" "4.2.2.6" "23.253.163.53" "198.101.242.72"
"64.94.1.1" "165.87.13.129" "204.117.214.10" "151.196.0.37"
"151.197.0.37" "151.198.0.37" "151.199.0.37" "151.201.0.37"
"151.202.0.37" "151.203.0.37" "151.204.0.37" "151.205.0.37"
"205.214.45.10" "199.85.126.10" "198.54.117.10" "165.87.201.244"
"37.235.1.174" "37.235.1.177" "176.103.130.130" "176.103.130.131"
"62.113.113.113" "62.113.113.114" "45.33.97.5" "45.33.97.6"
"103.86.96.100" "103.86.99.100" "202.153.220.42" "202.153.220.43"
)

# ==========================
# Mobile Games Menu
# ==========================
mobile_games_menu() {
    show_title
    echo -e "${YELLOW}Select Mobile Game:${NC}"
    echo "1) PUBG Mobile"
    echo "2) Free Fire"
    echo "3) Call of Duty Mobile"
    echo "4) Clash Royale"
    echo "5) Clash of Clans"
    echo "6) Brawl Stars"
    echo "7) Mobile Legends"
    echo "8) Genshin Impact"
    echo "9) FarLight 84"
    echo "10) Arena of Valor"
    echo "11) Return to Main Menu"
    echo
    read -p "Choose: " choice

    case $choice in
        11) main_menu ;;
        *) pick_mobile_dns ;;
    esac
}

# ==========================
# Pick DNS for Mobile Games
# ==========================
pick_mobile_dns() {
    ip1=${MOBILE_DNS[$RANDOM % ${#MOBILE_DNS[@]}]}
    ip2=${MOBILE_DNS[$RANDOM % ${#MOBILE_DNS[@]}]}

    ping1=$(ping_dns $ip1)
    ping2=$(ping_dns $ip2)

    # If ping > 46 → Generate new DNS
    if [[ "$ping1" == "timeout" || ${ping1%ms} -gt 46 ]]; then
        ip1=$(generate_dns)
        ping1=$(ping_dns $ip1)
    fi

    if [[ "$ping2" == "timeout" || ${ping2%ms} -gt 46 ]]; then
        ip2=$(generate_dns)
        ping2=$(ping_dns $ip2)
    fi

    echo -e "${GREEN}Primary DNS: $ip1 → $ping1${NC}"
    echo -e "${GREEN}Secondary DNS: $ip2 → $ping2${NC}"
    echo
    read -p "Press Enter to return..."
    mobile_games_menu
}
# ==========================
# Console Games DNS (200+)
# ==========================

CONSOLE_DNS=(
"1.1.1.1" "1.0.0.1" "8.8.8.8" "8.8.4.4" "9.9.9.9" "149.112.112.112"
"208.67.222.222" "208.67.220.220" "94.140.14.14" "94.140.15.15"
"77.88.8.8" "77.88.8.1" "185.222.222.222" "185.184.222.222"
"64.6.64.6" "64.6.65.6" "76.76.2.0" "76.76.10.0"
"156.154.70.1" "156.154.71.1" "45.90.28.193" "45.90.30.193"
"185.228.168.9" "185.228.169.9" "74.82.42.42" "209.244.0.3"
"209.244.0.4" "216.146.35.35" "216.146.36.36" "8.26.56.26"
"8.20.247.20" "4.2.2.1" "4.2.2.2" "4.2.2.3" "4.2.2.4"
"4.2.2.5" "4.2.2.6" "23.253.163.53" "198.101.242.72"
"64.94.1.1" "165.87.13.129" "204.117.214.10" "151.196.0.37"
"151.197.0.37" "151.198.0.37" "151.199.0.37" "151.201.0.37"
"151.202.0.37" "151.203.0.37" "151.204.0.37" "151.205.0.37"
"205.214.45.10" "199.85.126.10" "198.54.117.10" "165.87.201.244"
"37.235.1.174" "37.235.1.177" "176.103.130.130" "176.103.130.131"
"62.113.113.113" "62.113.113.114" "45.33.97.5" "45.33.97.6"
"103.86.96.100" "103.86.99.100" "202.153.220.42" "202.153.220.43"
)

# ==========================
# Console Games Menu
# ==========================
console_games_menu() {
    show_title
    echo -e "${YELLOW}Select Console Game:${NC}"
    echo "1) Fortnite (PS/Xbox)"
    echo "2) Call of Duty Warzone (PS/Xbox)"
    echo "3) EA FC25 (PS5/Xbox)"
    echo "4) FIFA 23 (PS/Xbox)"
    echo "5) Apex Legends (PS/Xbox)"
    echo "6) Destiny 2 (PS/Xbox)"
    echo "7) Overwatch 2 (PS/Xbox)"
    echo "8) GTA Online (PS/Xbox)"
    echo "9) Return to Main Menu"
    echo
    read -p "Choose: " choice

    case $choice in
        9) main_menu ;;
        *) pick_console_dns ;;
    esac
}

# ==========================
# Pick DNS for Console Games
# ==========================
pick_console_dns() {
    ip1=${CONSOLE_DNS[$RANDOM % ${#CONSOLE_DNS[@]}]}
    ip2=${CONSOLE_DNS[$RANDOM % ${#CONSOLE_DNS[@]}]}

    ping1=$(ping_dns $ip1)
    ping2=$(ping_dns $ip2)

    # If ping > 46 → Generate new DNS
    if [[ "$ping1" == "timeout" || ${ping1%ms} -gt 46 ]]; then
        ip1=$(generate_dns)
        ping1=$(ping_dns $ip1)
    fi

    if [[ "$ping2" == "timeout" || ${ping2%ms} -gt 46 ]]; then
        ip2=$(generate_dns)
        ping2=$(ping_dns $ip2)
    fi

    echo -e "${GREEN}Primary DNS: $ip1 → $ping1${NC}"
    echo -e "${GREEN}Secondary DNS: $ip2 → $ping2${NC}"
    echo
    read -p "Press Enter to return..."
    console_games_menu
}
# ==========================
# Game DNS Manager (PC / Console / Mobile)
# ==========================

pick_two_random() {
    local arr=("$@")
    local count=${#arr[@]}
    if ((count < 2)); then
        echo ""
        return 1
    fi
    local idx1=$((RANDOM % count))
    local idx2=$((RANDOM % count))
    while [ $idx1 -eq $idx2 ]; do
        idx2=$((RANDOM % count))
    done
    echo "${arr[$idx1]} ${arr[$idx2]}"
}

ping_dns() {
    local dns=$1
    local result
    result=$(ping -c 1 -W 1 "$dns" 2>/dev/null | grep 'time=' | awk -F'time=' '{print $2}' | cut -d' ' -f1)
    if [ -z "$result" ]; then
        echo "timeout"
    else
        echo "${result}ms"
    fi
}

game_dns_menu() {
    show_title
    echo -e "${YELLOW}Select Device Type:${NC}"
    echo "1) PC Games"
    echo "2) Console Games"
    echo "3) Mobile Games"
    echo "4) Back to Main Menu"
    echo
    read -p "Choose: " dev_choice

    case $dev_choice in
        1) bank=("${PC_DNS[@]}"); device="PC" ;;
        2) bank=("${CONSOLE_DNS[@]}"); device="Console" ;;
        3) bank=("${MOBILE_DNS[@]}"); device="Mobile" ;;
        4) main_menu ;;
        *) echo "Invalid option!"; game_dns_menu ;;
    esac

    echo -e "${YELLOW}Select Country:${NC}"
    echo "1) Iran"
    echo "2) Turkey"
    echo "3) UAE"
    echo "4) Saudi Arabia"
    echo "5) USA"
    echo "6) Back"
    read -p "Choose: " country_choice

    case $country_choice in
        1) country="Iran" ;;
        2) country="Turkey" ;;
        3) country="UAE" ;;
        4) country="Saudi Arabia" ;;
        5) country="USA" ;;
        6) game_dns_menu ;;
        *) echo "Invalid option!"; game_dns_menu ;;
    esac

    echo -e "${CYAN}Finding best DNS for $device games in $country...${NC}"
    read -p "Press Enter to continue..."

    pair=$(pick_two_random "${bank[@]}")
    ip1=$(echo "$pair" | awk '{print $1}')
    ip2=$(echo "$pair" | awk '{print $2}')

    ping1=$(ping_dns $ip1)
    ping2=$(ping_dns $ip2)

    # If ping > 46 or timeout → generate new DNS
    if [[ "$ping1" == "timeout" || ${ping1%ms} -gt 46 ]]; then
        ip1=$(generate_dns_ipv4)
        ping1=$(ping_dns $ip1)
    fi

    if [[ "$ping2" == "timeout" || ${ping2%ms} -gt 46 ]]; then
        ip2=$(generate_dns_ipv4)
        ping2=$(ping_dns $ip2)
    fi

    echo -e "${GREEN}Country: $country${NC}"
    echo -e "${GREEN}Primary DNS: $ip1 → $ping1${NC}"
    echo -e "${GREEN}Secondary DNS: $ip2 → $ping2${NC}"
    echo
    read -p "Press Enter to return..."
    game_dns_menu
}
# ==========================
# Generate DNS (Iran, Turkey, UAE, Saudi Arabia, USA)
# ==========================

generate_dns_ipv4() {
    echo "$((RANDOM % 223 + 1)).$((RANDOM % 255)).$((RANDOM % 255)).$((RANDOM % 255))"
}

generate_dns_ipv6() {
    printf "%x:%x:%x:%x:%x:%x:%x:%x\n" \
        $((RANDOM%65535)) $((RANDOM%65535)) $((RANDOM%65535)) $((RANDOM%65535)) \
        $((RANDOM%65535)) $((RANDOM%65535)) $((RANDOM%65535)) $((RANDOM%65535))
}

generate_dns_menu() {
    show_title
    echo -e "${YELLOW}Select Country for DNS Generation:${NC}"
    echo "1) Iran"
    echo "2) Turkey"
    echo "3) UAE"
    echo "4) Saudi Arabia"
    echo "5) USA"
    echo "6) Return to Main Menu"
    echo
    read -p "Choose: " choice

    case $choice in
        1) country="Iran" ;;
        2) country="Turkey" ;;
        3) country="UAE" ;;
        4) country="Saudi Arabia" ;;
        5) country="USA" ;;
        6) main_menu ;;
        *) echo "Invalid option!"; generate_dns_menu ;;
    esac

    echo -e "${GREEN}Generating fresh DNS for $country...${NC}"
    ip1=$(generate_dns_ipv4)
    ip2=$(generate_dns_ipv6)

    ping1=$(ping_dns $ip1)
    ping2=$(ping_dns $ip2)

    # Ping check → اگر بالای 46 بود دوباره Generate میشه
    if [[ "$ping1" == "timeout" || ${ping1%ms} -gt 46 ]]; then
        ip1=$(generate_dns_ipv4)
        ping1=$(ping_dns $ip1)
    fi

    if [[ "$ping2" == "timeout" || ${ping2%ms} -gt 46 ]]; then
        ip2=$(generate_dns_ipv6)
        ping2=$(ping_dns $ip2)
    fi

    echo -e "${CYAN}Country: $country${NC}"
    echo -e "${GREEN}Primary DNS (IPv4): $ip1 → $ping1${NC}"
    echo -e "${GREEN}Secondary DNS (IPv6): $ip2 → $ping2${NC}"
    echo
    read -p "Press Enter to return..."
    generate_dns_menu
}
# ==========================
# Generate Random DNS by Country
# ==========================

generate_dns_ipv4() {
    echo "$((RANDOM % 223 + 1)).$((RANDOM % 255)).$((RANDOM % 255)).$((RANDOM % 255))"
}

generate_dns_ipv6() {
    printf "%x:%x:%x:%x:%x:%x:%x:%x\n" \
        $((RANDOM % 65535)) $((RANDOM % 65535)) $((RANDOM % 65535)) \
        $((RANDOM % 65535)) $((RANDOM % 65535)) $((RANDOM % 65535)) \
        $((RANDOM % 65535)) $((RANDOM % 65535))
}

generate_dns_country() {
    show_title
    echo -e "${YELLOW}Select Country for DNS Generation:${NC}"
    echo "1) Iran"
    echo "2) Turkey"
    echo "3) UAE"
    echo "4) Saudi Arabia"
    echo "5) USA"
    echo "6) Back to Main Menu"
    echo
    read -p "Choose: " gen_choice

    case $gen_choice in
        1) country="Iran" ;;
        2) country="Turkey" ;;
        3) country="UAE" ;;
        4) country="Saudi Arabia" ;;
        5) country="USA" ;;
        6) main_menu ;;
        *) echo "Invalid option!"; generate_dns_country ;;
    esac

    echo -e "${CYAN}Generating DNS for $country...${NC}"
    read -p "Press Enter to continue..."

    ipv4=$(generate_dns_ipv4)
    ipv6=$(generate_dns_ipv6)

    ping4=$(ping_dns $ipv4)
    ping6=$(ping_dns $ipv6)

    echo -e "${GREEN}Country: $country${NC}"
    echo -e "${GREEN}Generated IPv4 DNS: $ipv4 → $ping4${NC}"
    echo -e "${GREEN}Generated IPv6 DNS: $ipv6 → $ping6${NC}"
    echo
    read -p "Press Enter to return..."
    generate_dns_country
}
# ==========================
# Main Menu
# ==========================

main_menu() {
    while true; do
        clear
        show_title
        echo -e "${CYAN}Main Menu:${NC}"
        echo "1) PC Games DNS"
        echo "2) Mobile Games DNS"
        echo "3) Console Games DNS"
        echo "4) Download / Streaming DNS"
        echo "5) Generate Random DNS (by Country)"
        echo "6) Search Game DNS"
        echo "7) Exit"
        echo
        read -p "Choose an option: " choice

        case $choice in
            1) game_menu "PC" ;;
            2) game_menu "Mobile" ;;
            3) game_menu "Console" ;;
            4) show_dns DOWNLOAD_DNS "Download / Streaming" ;;
            5) generate_dns_country ;;
            6) search_game_dns ;;
            7) echo -e "${YELLOW}Goodbye!${NC}"; exit 0 ;;
            *) echo -e "${RED}Invalid option!${NC}"; sleep 1 ;;
        esac
    done
}

# ==========================
# Start the Script
# ==========================

main_menu
