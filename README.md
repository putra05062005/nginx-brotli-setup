# NGINX Brotli Setup with SSL, Tuning & Hardening on Debian 12

🖥️ Proyek ini adalah mini setup server menggunakan Debian 12 di VirtualBox.
Menggunakan NGINX + Brotli + SSL self-signed + aplikasi web statis, dengan fokus pada optimasi performa dan penguatan keamanan.

## ✅ Fitur

### Fitur Utama
- SSH via port forwarding (port default diganti ke `2323`)
- Login SSH hanya dengan SSH Key (login password dinonaktifkan)
- Web server NGINX (versi `nginx-extras` dari repo Sury)
- Sertifikat SSL self-signed untuk HTTPS
- Modul Brotli aktif untuk kompresi modern
- Web statis sederhana `index.html`

### Tuning & Hardening
- **Tuning Performa:** Optimalisasi Nginx `worker_processes`, `keepalive_timeout`, `open_file_cache`, dan Gzip sebagai *fallback*.
- **Hardening Keamanan:** Konfigurasi Firewall UFW, menyembunyikan versi Nginx, *HTTP Security Headers*, menonaktifkan login root via SSH, dan instalasi `fail2ban` untuk proteksi otomatis.

## 📄 Konfigurasi Penting di Server

Konfigurasi utama untuk proyek ini ada di dalam server Debian pada path berikut:

- **/etc/nginx/nginx.conf**: Konfigurasi global Nginx, tempat kita mengatur worker, Gzip, Brotli, dan Open File Cache.
- **/etc/nginx/sites-available/my-app**: Konfigurasi *server block* untuk aplikasi kita, termasuk pengaturan SSL dan Browser Cache.
- **/etc/ssh/sshd_config**: Konfigurasi layanan SSH, tempat kita mengubah port dan menonaktifkan login password.
- **/etc/fail2ban/jail.local**: Konfigurasi Fail2ban untuk proteksi SSH.
- **/var/www/my-app/index.html**: Lokasi file web statis kita.

## 🔧 Tuning & Hardening yang Diterapkan

### Peningkatan Performa
- **Worker Processes:** `worker_processes` diatur agar sesuai dengan jumlah core CPU.
- **Keepalive:** `keepalive_timeout` diaktifkan untuk menjaga koneksi tetap terbuka dan mengurangi latensi.
- **Open File Cache:** `open_file_cache` diaktifkan untuk menyimpan metadata file di memori, mengurangi beban I/O disk.
- **Gzip Fallback:** Kompresi Gzip diaktifkan sebagai cadangan untuk browser lama yang tidak mendukung Brotli.

### Peningkatan Keamanan
- **Firewall (UFW):** Hanya port yang diperlukan (SSH `2323`, Web `80` & `443`) yang diizinkan.
- **Nginx Security:** `server_tokens off` untuk menyembunyikan versi Nginx dan `add_header` untuk menerapkan *HTTP Security Headers* (`X-Frame-Options`, dll).
- **SSH Hardening:** `PermitRootLogin no` untuk mencegah login langsung sebagai root.
- **Fail2ban:** Diinstal dan aktif untuk secara otomatis memblokir IP yang mencoba serangan *brute-force* ke SSH.


## 🚀 Cara Coba

1.  Jalankan Debian VM via VirtualBox.
2.  Pastikan Port Forwarding diatur:
    - **SSH:** Host Port `2222` → Guest Port `2323`
    - **HTTPS:** Host Port `8443` → Guest Port `443`
3.  Akses via SSH (dari komputer utama):
    ```bash
    ssh user@127.0.0.1 -p 2222
    ```
4.  Buka browser di komputer utama:
    `https://server.latihan:8443`
    *(Pastikan file `/etc/hosts` di komputer utama Anda sudah ditambahkan baris `127.0.0.1 server.latihan`)*

## 📜 Lisensi
MIT License.

<details>
<summary>Contoh file .gitignore</summary>


Proteksi Otomatis dengan Fail2ban

Untuk melindungi server dari serangan brute-force, fail2ban dikonfigurasi dengan beberapa "penjara" (jail) yang memantau file log dan memblokir alamat IP yang mencurigakan.

1. Proteksi SSH [sshd]

Ini adalah pengaman utama untuk layanan SSH. Jail ini memantau log otentikasi dan akan memblokir IP yang berulang kali gagal saat mencoba login.

    File Konfigurasi: /etc/fail2ban/jail.local

    Isi Konfigurasi:
    Ini, TOML

    [sshd]
    enabled = true
    backend = systemd
    port    = ssh

2. Proteksi Otentikasi Web [nginx-http-auth]

Meskipun saat ini tidak ada halaman yang diproteksi password, jail ini diaktifkan sebagai lapisan keamanan tambahan untuk memblokir percobaan brute-force pada halaman login atau direktori terproteksi di masa depan.

    File Konfigurasi: /etc/fail2ban/jail.local

    Isi Konfigurasi:
    Ini, TOML

    [nginx-http-auth]
    enabled = true
    port    = http,https

3. Proteksi Scanning Halaman [nginx-404] (Filter Kustom)

Filter bawaan terkadang tidak cocok untuk mendeteksi eror 404 Not Found. Oleh karena itu, dibuat filter dan jail kustom untuk memblokir IP yang terlalu sering melakukan scanning halaman yang tidak ada.

    File Filter: /etc/fail2ban/filter.d/nginx-404.conf

    Isi Filter:
    Ini, TOML

[Definition]
failregex = ^<HOST> .* "GET .* HTTP/1\.." 404

File Konfigurasi Jail: /etc/fail2ban/jail.local

Isi Konfigurasi Jail:
Ini, TOML

[nginx-404]
enabled  = true
port     = http,https
filter   = nginx-404
logpath  = /var/log/nginx/access.log
maxretry = 5

###Maybe Last
