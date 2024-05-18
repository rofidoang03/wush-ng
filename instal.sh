#!/bin/bash
# script untuk menginstal wush-ng

function instal_depedensi(){
        depedensi=(
                "aircrack-ng"
                "xterm"
                "git"
                "wget"
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
        file="rockyou.txt.gz"
        mkdir -p "${path}"
        cd "${path}"
        echo "[*] Mendownload wordlist ${file} ..."
        sleep 3
        wget "${link}"
        echo "[+] Wordlist ${file} berhasil didownload."
        echo "[*] Mengekstrak wordlist ${file} ..."
        sleep 3
        echo "[+] Wordlist ${file} berhasil diekstrak. dan disimpan dalam folder ${path}."
        cd ..
}

function berikan_izin_eksekusi(){
        lokasi_wush_ng="src/wush-ng"
        chmod +x "${lokasi_wush_ng}"
        cp "${lokasi_wush_ng}" "/usr/bin"
}

read -p "Apakah Anda ingin menginstal wish (Y/n): " n
if [[ "${n}" == "y" ]] || [[ "${n}" == "Y" ]]; then
        echo "[*] Menginstal wush-ng..."
        cd /usr/share
        mkdir -p wordlists
        echo "[*] Memperbarui daftar paket dari repositori..."
        sleep 3
        apt-get update -y
        echo "[+] Daftar paket dari repositori berhasil diperbarui."
        echo "[*] Kloning repositori wush-ng dari Github..."
        sleep 3
        apt-get install git -y
        git clone https://github.com/rofidoang03/wush-ng.git
        echo "[+] Repositori wush-ng berhasil dikloning dari Github."
        cd wush-ng
        instal_depedensi
        download_rockyou
        echo "[+] wush-ng berhasil diinstal."
        sleep 3
        echo "[+] Ketikkan perintah wush-ng untuk menjalankannya."
        exit 0
else
        echo "[-] Proses instalasi wush-ng dibatalkan."
        exit 1
fi
                

