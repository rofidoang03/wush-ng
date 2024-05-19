from gtts import gTTS
import simpleaudio as sa
import os
import time 
import datetime
import pytz

# Menyesuaikan zona waktu menjadi Waktu Indonesia Barat (WIB)
zonawaktu_wib = pytz.timezone('Asia/Jakarta')
waktu_sekarang = datetime.datetime.now(zonawaktu_wib)

# Memformat waktu dalam format yang diinginkan
format_waktu = waktu_sekarang.strftime("%d-%m-%Y %H:%M:%S WIB")

text="""PERINGATAN

Penyalahgunaan atau penggunaan program ini untuk
aktivitas ilegal dilarang keras. Program ini
disediakan semata-mata untuk tujuan pembelajaran dan
pengujian keamanan jaringan yang sah. Pengguna
bertanggung jawab penuh atas penggunaan dan
konsekuensi yang timbul dari penggunaan program ini.

DILARANG KERAS menggunakan program ini tanpa izin
atau untuk tujuan merusak atau melanggar hukum.
Segala tindakan ilegal diluar tanggung jawab
pembuat program.

DENGAN MENGGUNAKAN PROGRAM INI, ANDA MENYATAKAN
BAHWA ANDA MEMAHAMI DAN MENERIMA SYARAT DAN KETENTUAN
DIATAS."""

bahasa="id"

print("[*] Dengarkan Saya...")

# Membuat suara dari teks
tts = gTTS(text=text, lang=bahasa)
tts.save("keluaran.mp3")

# Menggunakan ffmpeg untuk mengonversi file MP3 ke WAV
os.system("ffmpeg -loglevel panic -i keluaran.mp3 -acodec pcm_s16le -ac 2 -ar 44100 keluaran.wav")

# Memuat file WAV menggunakan simpleaudio
wave_obj = sa.WaveObject.from_wave_file("keluaran.wav")
play_obj = wave_obj.play()
play_obj.wait_done()

# Menghapus file setelah selesai diputar
os.remove("keluaran.mp3")
os.remove("keluaran.wav")

while True:
    # Meminta input dari pengguna
    pilihan = input("\nApakah Anda ingin melanjutkannya (Y/n): ")

    # Memeriksa apakah pengguna ingin melanjutkan
    if pilihan.lower() == 'y':
        print(f"[*] Memulai wush-ng pada {formatted_time}")
        time.sleep(3)
        os.system("bash /usr/share/wush-ng/src/wush-ng.sh")
        break
        # Tempatkan kode yang ingin dijalankan jika pengguna ingin melanjutkan di sini
    elif pilihan.lower() == 'n':
        exit(1)
    else:
        print("Pilihan tidak valid.")
        # Tempatkan kode yang ingin dijalankan jika pilihan tidak valid di sini
