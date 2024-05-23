#!/bin/bash

# Nama file CSV output
csv_file="airodump-output.csv"
interface="wlan0mon"  # Ganti dengan nama interface yang sesuai

# Melakukan pemindaian menggunakan airodump-ng
echo "Melakukan pemindaian dengan airodump-ng..."
airodump-ng --output-format csv --write $csv_file $interface &

# Menunggu 5 detik untuk memastikan hasil pemindaian tersedia
sleep 5

# Memeriksa apakah ada client yang terhubung
client_count=$(awk '/Station MAC/{f=1;next}f' "${csv_file}-01.csv" | grep -v "not associated" | wc -l)

if [ $client_count -eq 0 ]; then
    echo "Tidak ada client yang terhubung."
else
    # Menampilkan informasi BSSID, Channel, dan ESSID
    echo "BSSID, Channel, ESSID:"

    # Membaca file CSV dan memproses data
    awk -F',' '
    BEGIN {
        OFS="\t"
        print "BSSID", "Channel", "ESSID"
    }
    /Station MAC/ { 
        exit 0
    }
    NR > 2 && NF > 0 && $1 ~ /[0-9A-Fa-f]{2}(:[0-9A-Fa-f]{2}){5}/ {
        bssid = $1
        channel = $4
        essid = $14
        print bssid, channel, essid
    }
    ' "${csv_file}-01.csv"
fi
