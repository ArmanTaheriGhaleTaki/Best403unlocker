#!/bin/bash


display_step() {
    local step_message=$1  # Step message provided as argument
     clear 
    reset
    printf '\e[21;25H' 
    echo "Step: $step_message"
}

change_dns() {
    local dns_server=$1
    local step_message="Changing DNS to $dns_server"

    echo "nameserver $dns_server" > /etc/resolv.conf

    sleep 1
    display_step "$step_message"
    echo " "
}

download() {
    local timeout=$1
    local file_url=$2
    local filename=$3
    local step_message="Measuring $filename speed"

    timeout $timeout wget -q -O "/tmp/$filename" --no-dns-cache "$file_url"

    sleep 1
    display_step "$step_message"

    sleep 1

    printf '\e[22;27H' 
    echo "Downloaded $filename"
    echo  ""
}

download_speed() {
    local filename=$1

    du -sh "/tmp/$filename" >> database
    rm "/tmp/$filename"

    sleep 1
}

# Main script

touch database
cp /etc/resolv.conf /etc/resolv.conf.backup

for dns_server in $dns; do
    change_dns "$dns_server"
    download $timeout "$file_url" "$dns_server"
    download_speed "$dns_server"
done

clear
echo '*********************'
echo "Best DNS server is $(sort -rn database | head -1 | cut -d'/' -f3)"
echo '*********************'
rm database
cat /etc/resolv.conf.backup > /etc/resolv.conf

rm /etc/resolv.conf.backup
echo "Script completed!"

