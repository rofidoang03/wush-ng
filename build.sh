#!/bin/bash
# Script untuk menginstal wush-ng
# Dibuat oleh rofidoang03

function root_check(){
    if [ "$EUID" -ne 0 ]; then
        echo "Error: Script ini harus dijalankan sebagai root."
        exit 1
    fi
}

function check_internet_connection(){
    if ! ping -c 1 google.com &> /dev/null; then
        echo "Error: Tidak ada koneksi internet. Harap hubungkan ke internet untuk menginstal FWIFI."
        exit 1
    fi
}

function install_dependencies(){
    updates=(
    "update"
    "upgrade"
    "full-upgrade"
    )

    for u in "${updates[@]}"; do
        apt-get "$u" -y
    done
    
    deps=(
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
    "john" # cmame
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

    for d in "${deps[@]}"; do
        apt-get install "$d" -y
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
    git clone https://github.com/t6x/reaver-wps-fork-t6x
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
    read -p "Apakah Anda ingin menginstal wush-ng [Y/n]: " ask
    if [[ "${ask}" == "y" || "${ask}" == "Y" ]]; then
        install_dependencies
        download_wordlists
        install_aircrack
        install_john
        install_reaver
        set_execute_permission
    elif [[ "${ask}" == "n" || "${ask}" == "N" ]]; then
        echo "Pemasangan dibatalkan."
        exit 0
    else
        echo "Error: Pilihan tidak valid. Harap pilih lagi."
        install
    fi
}

function install_wush(){
    root_check
    check_internet_connection
    install
}

install_wush
