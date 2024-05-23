#!/bin/bash

# Nama file CSV output
csv_file="airodump-output.csv"
interface="wlan0mon"  # Ganti dengan nama interface yang sesuai

# Melakukan pemindaian menggunakan airodump-ng
echo "Melakukan pemindaian dengan airodump-ng..."
airodump-ng --output-format csv --write "$csv_file" "$interface"

# Memastikan file CSV ada
if [[ ! -f "${csv_file}-01.csv" ]]; then
    echo "File ${csv_file}-01.csv tidak ditemukan!"
    exit 1
fi

# Menampilkan BSSID, Channel, dan ESSID
echo "BSSID, Channel, ESSID:"

# Membaca file CSV dan memproses data
awk -F',' '
BEGIN {
    printf "%-20s %-10s %-s\n", "BSSID", "Channel", "ESSID"
    printf "%-20s %-10s %-s\n", "------------------", "--------", "------"
}
/Station MAC/ { 
    exit 0
}
NR > 2 && NF > 0 && $1 ~ /[0-9A-Fa-f]{2}(:[0-9A-Fa-f]{2}){5}/ {
    bssid = $1
    channel = $4
    essid = $14
    printf "%-20s %-10s %-s\n", bssid, channel, essid
}
' "${csv_file}-01.csv"
