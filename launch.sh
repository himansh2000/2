#!/bin/bash

if [ "$EUID" -ne 0 ]; then
  echo "Please run this script as sudo."
  exit 1
fi

echo "Installing figlet and pv..."
sudo apt-get install figlet pv -y &> /dev/null &

figlet "Microsoft Rewards Bot"
echo "By @AKhilRaghav0"

echo "Installing packages from requirements.txt..."
pip3 install -r requirements.txt | pv -t -i 0.5 -w 80 -N "Installing Packages" &
wait

echo "Checking if Google Chrome is installed..."
if ! which google-chrome > /dev/null; then
  echo "Google Chrome not found, installing..."
  wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb | pv -t -i 0.5 -w 80 -N "Downloading Chrome" &
  sudo apt-get install ./google-chrome-stable_current_amd64.deb | pv -t -i 0.5 -w 80 -N "Installing Chrome" &
else
  echo "Google Chrome is already installed."
fi
wait

echo "Fixing broken dependencies..."
sudo apt-get -f install | pv -t -i 0.5 -w 80 -N "Fixing Broken Dependencies" &
wait

echo "Installation complete."

echo "Select an option:"
echo "1. Headless mode (fast)"
echo "2. GUI mode (fast)"
echo "3. GUI mode (slow)"
echo "4. Headless mode (slow)"

read -p "Enter your choice: " choice

case "$choice" in
  1) command="python3 MicrosoftRewardsBot.py --headless --fast";;
  2) command="python3 MicrosoftRewardsBot.py --fast";;
  3) command="python3 MicrosoftRewardsBot.py";;
  4) command="python3 MicrosoftRewardsBot.py --headless";;
  *) echo "Invalid choice."; exit 1;;
esac

echo "Executing Microsoft Rewards Bot..."
$command &

echo "Execution complete."

