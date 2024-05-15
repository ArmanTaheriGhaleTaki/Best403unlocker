#!/bin/bash
source .env

# Function to display the main menu
main_menu() {
    choice=$(whiptail --title "Best403Unlcoker TUI" --menu "Choose an option:" 15 60 4 \
    "Run DNS analyzer" "find the most speedful dns" \
    "Save file" "Downlaod file with the best dns" \
    "Advance setting" "change configuration" \
    "Exit" "Exit the program" \
    3>&1 1>&2 2>&3)

    case "$choice" in
        "Run DNS analyzer")
          best_dns_finder 
            ;;
        "Save file")
           download_file_with_best_dns
            ;;
        "Advance setting")
            disconnect_network
            ;;
        "Exit")
            exit
            ;;
        *)
            ;;
    esac
}

best_dns_finder() {
    file_url=$(whiptail --title "add test file url" --inputbox "please type your url that you want to be checked" 15 60 "$file_url" 3>&1 1>&2 2>&3)

# Replace the value of file_url with the value of the file_url environment variable

    if grep -q "^file_url=" ".env" ; then
    sed -i "s|^file_url=.*|file_url=$file_url|" .env
    fi

    choices=$(whiptail --title "choose engine otherwise it runs on system" --checklist "Choose options:" 15 60 1 \
	    "docker" "(suggested)" ON \
    3>&1 1>&2 2>&3)

    selected_options=($(echo $choices | tr -d '"'))
    # Check if "docker" is in the selected options
    if [[ " ${selected_options[@]} " =~ " docker " ]]; then
	docker run --env-file .env armantaherighaletaki/best403unlocker | tee log.txt 2>&1 
    else 
	wget -c https://raw.githubusercontent.com/ArmanTaheriGhaleTaki/best403unlocker/main/bash.sh && sudo bash bash.sh  | tee log.txt 2>&1
    fi
	DNS=$(grep best log.txt| cut -d' ' -f5 )

    whiptail --title "DNS analyzer" --msgbox "Best DNS:\n$DNS" 15 60

    selected_options=($(echo $choices | tr -d '"'))
    if whiptail --title "Confirmation" --yesno "set DNS to system'" 10 60 ;then
    sudo bash -c "echo 'nameserver $DNS' > /run/systemd/resolve/stub-resolv.conf"
    fi
}

download_file_with_best_dns() {

    file_url=$(whiptail --title "add file url" --inputbox "please type the url that you wnat to be downloaded" 15 60 "$file_url" 3>&1 1>&2 2>&3)

# Replace the value of file_url with the value of the file_url environment variable

    if grep -q "^file_url=" ".env" ; then
    sed -i "s|^file_url=.*|file_url=$file_url|" .env
    fi
    save_filepath=$(echo "$file_url" | grep -o '[^/]*$')
    save_filepath=$HOME/Downloads/$save_filepath
    save_filepath=$(whiptail --title "save file as " --inputbox "choose the location to save the file" 15 60 "$save_filepath" 3>&1 1>&2 2>&3)

    choices=$(whiptail --title "choose engine otherwise it runs on system" --checklist "Choose options:" 15 60 1 \
	    "docker" "(suggested)" ON \
    3>&1 1>&2 2>&3)

    selected_options=($(echo $choices | tr -d '"'))
    # Check if "docker" is in the selected options
    if [[ " ${selected_options[@]} " =~ " docker " ]]; then
	docker run --env-file .env armantaherighaletaki/best403unlocker | tee log.txt 2>&1 
    else 
	wget -c https://raw.githubusercontent.com/ArmanTaheriGhaleTaki/best403unlocker/main/bash.sh && sudo bash bash.sh  | tee log.txt 2>&1
    fi
	DNS=$(grep best log.txt| cut -d' ' -f5 )

    sudo bash -c "echo 'nameserver $DNS' > /run/systemd/resolve/stub-resolv.conf"
    wget --no-dns-cache $file_url -O $save_filepath 
    sudo bash -c "cp /etc/resolv.conf.bakup /run/systemd/resolve/stub-resolv.conf"
}

disconnect_network() {
	echo hello 
}

# Main function
main() {
    while true; do
        main_menu
    done
}

# Main execution
main

