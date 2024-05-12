<h1 align="center">
  <img src="https://github.com/rofidoang03/fwifi/blob/main/images/20240511_232154.png" width="100px" height="100px"/><br>
wush-ng</h1>

<p align="center">Perangkat lunak audit keamanan WiFi</p>

<p align="center"> <a href="home">Tentang</a> | <a href="https://github.com/rofidoang03/fwifi/blob/main/instal%20fwifi.txt">Instalasi</a> | <a href="">Demonstrasi</a></p>

<img src="https://github.com/rofidoang03/wush-ng/blob/main/images/Screenshot_2024-05-02_20_21_41.png" />

<p><code>wush-ng</code> Adalah sebuah perangkat lunak audit keamanan WiFi yang dapat menangkap lalu lintas WiFi di sekitar, menemukan klien yang terhubung ke Access Point, melakukan serangan deautentikasi, menangkap handshake, dan membobol kata sandi dari Access Point.</p>

Perangkat lunak ini ditulis dalam bahasa Bash.

<p><code>⭐ Jangan lupa untuk memberikan bintang jika Anda menyukai proyek ini!</code></p>

<h2>Legal ⚠️</h2>

<p>wush-ng dirancang untuk digunakan dalam pengujian dan penemuan kelemahan dalam jaringan yang Anda miliki. Melakukan serangan terhadap jaringan WiFi yang bukan milik Anda adalah ilegal di hampir semua negara. Saya tidak bertanggung jawab atas kerusakan apa pun yang mungkin Anda sebabkan dengan menggunakan perangkat lunak ini.</p>

<h2>Persyaratan </h2>

<p>Perangkat lunak ini hanya dapat dijalankan di sistem operasi <code>Linux</code> dan memerlukan hak akses <code>root</code>.
</p>

<p>Anda juga akan memerlukan Wi-Fi Adapter yang mendukung <code>mode monitor</code> dan <code>injeksi paket</code>.</p>

<h2>Instalasi ⚙️</h2>

<pre>
# Memperbarui informasi paket terbaru.
$ apt-get update

# Menginstal perangkat lunak Git.
$ apt-get install git

# Pindah ke direktori /usr/share.
$ cd /usr/share

# Clone repositori wush-ng dari GitHub.
$ git clone https://github.com/rofidoang03/wush-ng.git

# Pindah ke direktori wush-ng 
$ cd wush-ng

# Mengubah izin file build.sh agar dapat dieksekusi.
$ chmod +x build.sh

# Menjalankan script build.sh untuk memulai proses instalasi.
$ ./build.sh
</pre>

<h2>Demonstrasi</h2>

<p>Video demonstrasi tersedia <a href="&">di sini</a>."</p>

<h2>Lisensi </h2>

<p>Proyek ini dirilis di bawah lisensi <a href="https://github.com/rofidoang03/wush-ng/blob/main/LICENSE">MIT</a>.</p>

<h2>Kontribusi </h2>

<p>Jika Anda ingin melaporkan bug atau mengusulkan fitur baru, jangan ragu untuk membuka <a href="https://github.com/rofidoang03/wush-ng/issues">isu (issue)</a> atau mengirimkan permintaan <a href="https://github.com/rofidoang03/wush-ng/pulls">tarik (pull request)</a>.</p>
