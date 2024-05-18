#!/bin/bash
# script untuk menginstal wush-ng

read -p "Apakah Anda ingin menginstal wish (Y/n): " n
if [[ "${n}" == "y" ]] || [[ "${n}" == "Y" ]]; then
        echo "[*] Menginstal wush-ng..."
        sleep 3
        echo "[*] Memperbarui daftar paket dari repositori..."
        sleep 3
        depedensi=(
        "aircrack-ng"
        "xterm"
        )
        echo "[*] Menginstal depedensi yang diperlukan..."
        sleep 3
        for d in "${depedensi[@]}"; do
                echo "[*] Menginstal ${d}..."
                sleep 3
                apt-get install "${d}"
                echo "[+] ${d} berhasil diinstal."
                sleep 3
        done
        echo "[+] Semua depedensi yang diperlukan berhasil diinstal."
        lokasi_wush_ng="src/wush-ng"
        chmod +x "${lokasi_wush_ng}"
        cp "${lokasi_wush_ng}" "/usr/bin"
        echo "[+] wush-ng berhasil diinstal."
        sleep 3
        echo "[+] Ketikkan perintah wush-ng untuk menjalankannya."
        exit 0
else
        echo "[-] Proses instalasi wush-ng dibatalkan."
        exit 1
fi
                
done
