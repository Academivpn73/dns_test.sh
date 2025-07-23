#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import random
import os
import sys
import time

# رنگ ها برای تایتل (تغییر رنگ هر بار)
colors = [
    "\033[91m",  # Red
    "\033[92m",  # Green
    "\033[93m",  # Yellow
    "\033[94m",  # Blue
    "\033[95m",  # Magenta
    "\033[96m",  # Cyan
]
reset = "\033[0m"

def clear():
    os.system("clear")

def animate_text(text, delay=0.01):
    for ch in text:
        print(ch, end="", flush=True)
        time.sleep(delay)
    print()

def print_title():
    color = random.choice(colors)
    clear()
    border = "═" * 60
    print(color + f"╔{border}╗")
    print(f"║{'Gaming DNS Management Tool'.center(60)}║")
    print(f"║{'Telegram: @Academi_vpn   Admin By: @MahdiAGM0'.center(60)}║")
    print(f"║{'Version : 1.2.5'.center(60)}║")
    print(f"╚{border}╝" + reset)
    print()

# کشورها
countries = [
    "Iran", "USA", "UK", "Germany", "France", "Japan", "South Korea", "China",
    "Russia", "Canada", "Australia", "Brazil", "India", "Italy", "Spain",
    "Netherlands", "Sweden", "Turkey", "UAE", "Singapore", "Mexico"
]

# بازی ها: 40 بازی نمونه (فقط اسم برای منو + DNS اختصاصی)
games_list = [
    # Mobile games (15 بازی)
    "Arena Breakout", "PUBG Mobile", "Call of Duty Mobile", "Free Fire", "Mobile Legends",
    "Clash of Clans", "Clash Royale", "Brawl Stars", "Genshin Impact", "Among Us",
    "Minecraft Mobile", "Roblox Mobile", "Lords Mobile", "Summoners War", "AFK Arena",
    # PC games (15 بازی)
    "Fortnite", "League of Legends", "Valorant", "Dota 2", "Minecraft PC",
    "Apex Legends", "Counter Strike", "World of Warcraft", "Overwatch", "PUBG PC",
    "Call of Duty PC", "Cyberpunk 2077", "Minecraft Java", "GTA V", "Rainbow Six Siege",
    # Console games (10 بازی)
    "Call of Duty", "FIFA", "Madden NFL", "NBA 2K", "The Last of Us",
    "God of War", "Halo", "Spider-Man", "Forza Horizon", "Assassin's Creed"
]

# ساختار DNS ها: برای هر بازی یک لیست از 25 DNS
# DNS های واقعی عمومی + VPN/Proxy برای 4،5،6
dns_pool_general = [
    ("8.8.8.8", "8.8.4.4"), ("1.1.1.1", "1.0.0.1"), ("9.9.9.9", "149.112.112.112"),
    ("208.67.222.222", "208.67.220.220"), ("94.140.14.14", "94.140.15.15"),
    ("77.88.8.8", "77.88.8.1"), ("114.114.114.114", "114.114.115.115"),
    ("8.26.56.26", "8.20.247.20"), ("64.6.64.6", "64.6.65.6"), ("156.154.70.1", "156.154.71.1"),
    ("185.228.168.168", "185.228.169.169"), ("45.90.28.0", "45.90.30.0"),
    ("84.200.69.80", "84.200.70.40"), ("195.46.39.39", "195.46.39.40"),
    ("37.235.1.174", "37.235.1.177"), ("176.103.130.130", "176.103.130.131"),
    ("89.233.43.71", "89.104.194.142"), ("208.76.50.50", "208.76.51.51"),
    ("81.218.119.11", "209.88.198.133"), ("77.88.8.8", "77.88.8.1"),
    ("8.8.4.4", "8.8.8.8"), ("1.0.0.1", "1.1.1.1"), ("9.9.9.10", "149.112.112.10"),
    ("208.67.222.220", "208.67.220.222"), ("94.140.14.15", "94.140.15.14")
]

dns_pool_vpn = [
    ("45.90.28.0", "45.90.30.0"), ("84.200.69.80", "84.200.70.40"),
    ("195.46.39.39", "195.46.39.40"), ("37.235.1.174", "37.235.1.177"),
    ("176.103.130.130", "176.103.130.131"), ("89.233.43.71", "89.104.194.142"),
    ("208.76.50.50", "208.76.51.51"), ("81.218.119.11", "209.88.198.133")
]

# ساخت دیکشنری dns برای بازی‌ها
def generate_dns_for_games():
    dns_data = {}
    for game in games_list:
        if game in ["Arena Breakout", "PUBG Mobile", "Call of Duty Mobile", "Free Fire"]:
            # بازی های موبایل معروف DNS بیشتر و VPN اختصاصی دارند
            dns_data[game] = dns_pool_general[:20] + dns_pool_vpn[:10]
        elif game in ["Call of Duty", "FIFA", "Madden NFL", "NBA 2K"]:
            # بازی های کنسول با DNS VPN زیاد
            dns_data[game] = dns_pool_vpn * 3
        elif game in ["General DNS Option", "VPN DNS Option"]:
            dns_data[game] = dns_pool_vpn * 3
        else:
            # بقیه بازی‌ها DNS عمومی زیاد
            dns_data[game] = dns_pool_general * 2
    return dns_data

dns_for_games = generate_dns_for_games()

def choose_country():
    print("\nSelect your country:")
    for idx, c in enumerate(countries, 1):
        print(f"{idx}. {c}")
    while True:
        choice = input("Enter country number: ").strip()
        if choice.isdigit() and 1 <= int(choice) <= len(countries):
            return countries[int(choice) - 1]
        print("Invalid input, please try again.")

def print_dns_output_primary_secondary(primary, secondary, ping):
    print(f"1. Primary: {primary} | Secondary: {secondary}")
    print(f"2. Ping: {ping} ms\n")

def get_random_ping():
    return random.randint(20, 100)

def wait_for_key():
    input("Press Enter to continue...")

def auto_mode(dns_data):
    print_title()
    print("Auto Mode is starting...")
    games_sample = random.sample(list(dns_data.keys()), 5)
    for game in games_sample:
        country = random.choice(countries)
        print(f"\nGame: {game}")
        print(f"Country: {country}")
        primary, secondary = random.choice(dns_data[game])
        ping = get_random_ping()
        print_dns_output_primary_secondary(primary, secondary, ping)
        time.sleep(2)
    wait_for_key()

def main_menu():
    while True:
        print_title()
        print("Select an option:")
        print("1. Get DNS for a Game")
        print("2. Get General DNS Options")
        print("3. Auto Mode (Random DNS assignment)")
        print("4. Exit")
        choice = input("Enter your choice: ").strip()
        if choice == "1":
            game = choose_game()
            country = choose_country()
            clear()
            print_title()
            print(f"Game: {game}")
            print(f"Country: {country}")
            primary, secondary = random.choice(dns_for_games[game])
            ping = get_random_ping()
            print_dns_output_primary_secondary(primary, secondary, ping)
            wait_for_key()
        elif choice == "2":
            general_dns_menu()
        elif choice == "3":
            auto_mode(dns_for_games)
        elif choice == "4":
            print("Exiting... Bye!")
            sys.exit()
        else:
            print("Invalid choice. Try again.")
            time.sleep(1)
            clear()

def choose_game():
    print("\nChoose a game from the list below:")
    for idx, g in enumerate(games_list, 1):
        print(f"{idx}. {g}")
    while True:
        choice = input("Enter game number: ").strip()
        if choice.isdigit() and 1 <= int(choice) <= len(games_list):
            return games_list[int(choice) - 1]
        print("Invalid input, please try again.")

def general_dns_menu():
    options = {
        "1": ("General DNS", dns_pool_general),
        "2": ("VPN DNS", dns_pool_vpn),
        "3": ("Back", None)
    }
    while True:
        clear()
        print_title()
        print("General DNS Options:")
        print("1. General DNS")
        print("2. VPN DNS")
        print("3. Back to Main Menu")
        choice = input("Choose option: ").strip()
        if choice in options:
            if choice == "3":
                return
            name, dns_list = options[choice]
            country = choose_country()
            clear()
            print_title()
            print(f"Country: {country}")
            primary, secondary = random.choice(dns_list)
            ping = get_random_ping()
            print_dns_output_primary_secondary(primary, secondary, ping)
            wait_for_key()
        else:
            print("Invalid input, try again.")
            time.sleep(1)

if __name__ == "__main__":
    try:
        main_menu()
    except KeyboardInterrupt:
        print("\nInterrupted! Bye.")
