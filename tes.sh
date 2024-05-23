#!/bin/bash

# Fungsi untuk menjalankan airodump-ng dan menyimpan output ke file
run_airodump() {
    local output_file="$1"
    # Jalankan airodump-ng selama 30 detik
    timeout 30s airodump-ng -w "$output_file" --output-format csv wlan0mon
}

# Fungsi untuk mem-parsing output file airodump-ng
parse_airodump_output() {
    local file_path="$1"
    local bssids_with_clients=()

    # Flag untuk menentukan apakah kita berada di bagian klien
    local clients_section=false

    while IFS=, read -r line; do
        # Jika kita menemukan header bagian Station MAC, berarti kita masuk ke bagian klien
        if [[ "$line" == *"Station MAC"* ]]; then
            clients_section=true
            continue
        fi

        if $clients_section; then
            # Ambil kolom ke-6 yang merupakan BSSID
            bssid=$(echo "$line" | awk -F, '{print $6}' | xargs)
            if [[ $bssid =~ ^([0-9A-Fa-f]{2}:){5}[0-9A-Fa-f]{2}$ ]]; then
                bssids_with_clients+=("$bssid")
            fi
        fi
    done < "$file_path"

    # Hapus duplikasi dan tampilkan BSSID yang memiliki klien terhubung
    if [[ ${#bssids_with_clients[@]} -gt 0 ]]; then
        echo "BSSID with clients connected:"
        printf "%s\n" "${bssids_with_clients[@]}" | sort -u
    else
        echo "No BSSID with clients found."
    fi
}

# Main function
main() {
    local output_file="airodump_output"
    run_airodump "$output_file"

    # Pastikan untuk memeriksa file output yang sesuai (biasanya ditambahkan -01.csv)
    parse_airodump_output "${output_file}-01.csv"
}

# Jalankan fungsi utama
main
