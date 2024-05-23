#!/bin/bash

# Nama file CSV output
csv_file="airodump-output.csv"
interface="wlan0mon"  # Ganti dengan nama interface yang sesuai

# Memastikan interface dalam mode monitor
echo "Mengatur interface $interface ke mode monitor..."
airmon-ng start $interface

# Melakukan pemindaian menggunakan airodump-ng
echo "Melakukan pemindaian dengan airodump-ng..."
airodump-ng --output-format csv --write $csv_file $interface

# Memastikan file CSV ada
if [[ ! -f "${csv_file}-01.csv" ]]; then
    echo "File ${csv_file}-01.csv tidak ditemukan!"
    exit 1
fi

# Menampilkan BSSID dan client yang terhubung
echo "BSSID dan client yang terhubung:"

# Membaca file CSV dan memproses data
awk -F',' '
BEGIN {
    OFS="\t"
    print "BSSID", "Client"
}
/Station MAC/ { 
    station_section = 1
    next
}
station_section == 1 && NF > 0 {
    client_mac = $1
    bssid = $6
    if (bssid != "(not associated)") {
        print bssid, client_mac
    }
}
' "${csv_file}-01.csv"

# Mengembalikan interface ke mode managed
echo "Mengembalikan interface $interface ke mode managed..."
airmon-ng stop $interface
