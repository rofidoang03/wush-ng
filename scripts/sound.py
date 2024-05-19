from gtts import gTTS
import simpleaudio as sa
import os
import time 

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

lang="id"

print("\r[*] Dengarkan Saya...")

# Membuat suara dari teks
tts = gTTS(text=text, lang=lang)
tts.save("output.mp3")

# Menggunakan ffmpeg untuk mengonversi file MP3 ke WAV
os.system("ffmpeg -loglevel panic -i output.mp3 -acodec pcm_s16le -ac 2 -ar 44100 output.wav")

# Memuat file WAV menggunakan simpleaudio
wave_obj = sa.WaveObject.from_wave_file("output.wav")
play_obj = wave_obj.play()
play_obj.wait_done()

# Menghapus file setelah selesai diputar
os.remove("output.mp3")
os.remove("output.wav")



while True:
    # Meminta input dari pengguna
    pilihan = input("Apakah Anda ingin melanjutkannya (Y/n): ")

    # Memeriksa apakah pengguna ingin melanjutkan
    if pilihan.lower() == 'y':
        print "[*] Menjalankan wush-ng"
        time.sleep(3)
        break
        # Tempatkan kode yang ingin dijalankan jika pengguna ingin melanjutkan di sini
    elif pilihan.lower() == 'n':
        exit(1)
    else:
        print("Pilihan tidak valid.")
        # Tempatkan kode yang ingin dijalankan jika pilihan tidak valid di sini
