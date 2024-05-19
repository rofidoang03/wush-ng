#!/bin/bash
# script untuk menginstal wush-ng

function membuat_folder_handshake(){
        mkdir -p "file_handshake"
}

function instal_depedensi(){
        depedensi=(
                "aircrack-ng"
                "xterm"
                "wget"
                "gzip"
                )
        echo "[*] Menginstal semua depedensi yang diperlukan..."
        sleep 3
        for d in "${depedensi[@]}"; do
                echo "[*] Menginstal ${d}..."
                sleep 3
                apt-get install "${d}"
                echo "[+] ${d} berhasil diinstal."
                sleep 3
        done
        echo "[+] Semua depedensi yang diperlukan berhasil diinstal."
}

function download_rockyou(){
        link="https://github.com/praetorian-inc/Hob0Rules/raw/master/wordlists/rockyou.txt.gz"
        path="/usr/share/wush-ng/wordlists/"
        wordlist="rockyou.txt.gz"
        mkdir -p "${path}"
        cd "${path}" 
        echo "[*] Mendownload wordlist ${wordlist}..."
        sleep 3
        wget "${link}"
        echo "[+] Wordlist ${wordlist} berhasil didownload."
        sleep 3
        echo "[*] Mengekstrak wordlist ${wordlist} ..."
        gzip -d "${path}${wordlist}"
        sleep 3
        echo "[+] Wordlist ${wordlist} berhasil diekstrak. dan disimpan dalam folder ${path}."
        sleep 3
        cd ..
}

function berikan_izin_eksekusi(){
        lokasi_wush_ng="src/wush-ng"
        chmod +x "${lokasi_wush_ng}"
        cp "${lokasi_wush_ng}" "/usr/bin"
}

read -p "Apakah Anda ingin menginstal wush-ng (Y/n): " n
if [[ "${n}" == "y" ]] || [[ "${n}" == "Y" ]]; then
        echo "[*] Menginstal wush-ng..."
        sleep 3
        membuat_folder_handshake
        instal_depedensi
        download_rockyou
        berikan_izin_eksekusi
        echo "[+] wush-ng berhasil diinstal."
        sleep 3
        echo "[+] Ketikkan perintah wush-ng untuk menjalankannya."
        sleep 3
        exit 0
else
        echo "[-] Proses instalasi wush-ng dibatalkan."
        exit 1
fi
