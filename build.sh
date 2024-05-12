#!/bin/bash
# script untuk menginstal fwifi
# dibuat oleh rofidoang03

function root_check(){
    if [ "$EUID" -ne 0 ]; then
        echo "Error: This script must be run as root."
        exit 1
    fi
}

function check_internet_connection(){
    if ! ping -c 1 google.com &> /dev/null; then
        echo "Error: No internet connection. Please connect to the internet to install FWIFI."
        exit 1
    fi
}

function install_dependencies(){
    update=(
    "update"
    "upgrade"
    "full-upgrade"
    )

    for u in "${update[@]}"; do
        apt-get "${u}" -y
    done
    
    dep=(
    "build-essential" # aircrack-ng 
    "autoconf"
    "automake"
    "libtool"
    "pkg-config"
    "libnl-3-dev"
    "libnl-genl-3-dev"
    "libssl-dev"
    "ethtool"
    "shtool"
    "rfkill"
    "zlib1g-dev"
    "libpcap-dev"
    "libsqlite3-dev"
    "libpcre2-dev"
    "libhwloc-dev"
    "libcmocka-dev"
    "hostapd"
    "wpasupplicant"
    "tcpdump"
    "screen"
    "iw"
    "usbutils"
    "expect"
    "cmame" # john
    "libicu-dev"
    "bison"
    "flex"
    "libgmp-dev"
    "yasm"
    "libbz2-dev"
    "cowpatty" # cowpatty
    "pixiewps" # reaver 
    "git"
    )

    for d in "${depedency[@]}"; do
        apt-get install "${d}" -y
    done
}
    
function download_wordlists(){
    mkdir -p wordlists
    cd wordlists
    wget https://raw.githubusercontent.com/derv82/wifite2/master/wordlist-top4800-probable.txt
    wget https://github.com/praetorian-inc/Hob0Rules/raw/master/wordlists/rockyou.txt.gz
    gzip -d rockyou.txt.gz
    wget https://raw.githubusercontent.com/FII14/WOTABUHUN/main/wotabuhun.txt
    wget https://raw.githubusercontent.com/mychaelgo/indonesia-wordlist/master/indonesian-wordlist.lst
    wget https://github.com/david-palma/wordlists/raw/main/passwords-WPA/wpa-over200k.txt
    cd ..
}

function install_aircrack(){
    git clone https://github.com/aircrack-ng/aircrack-ng
    cd aircrack-ng
    autoreconf -i
    ./configure --with-experimental
    make
    make install
    ldconfig
    cd ..
}

function install_john(){
    git clone https://github.com/openwall/john.git
    cd john/src
    ./configure && make -s clean && make -sj4
    cd ../..
}

function install_reaver(){
    https://github.com/t6x/reaver-wps-fork-t6x
    cd reaver-wps-fork-t6x/src
    ./configure
    make
    make install
    cd ../..
}

function set_execute_permission(){
    chmod +x src/wush-ng
    cp src/wush-ng /usr/bin/
    exit 0
}

function install(){
    read -p "Do you want to install wush-ng [Y/n]: " ask
    if [[ "${ask}" == "y" || "${ask}" == "Y" ]]; then
        install_dependencies
        download_wordlists
        install_aircrack
        install_john
        install_reaver
        set_execute_permission
    elif [[ "${ask}" == "n" || "${ask}" == "N" ]]; then
        echo "Installation cancelled."
        exit 0
    else
        echo "Error: Invalid choice. Please choose again."
        install
    fi
}

function install_wush(){
    root_check
    check_internet_connection
    install
}

install_wush
