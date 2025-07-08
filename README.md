🛡️ Proyek Otomasi Server Debian dengan Ansible 🚀


📖 Gambaran Umum Proyek

Proyek ini adalah implementasi otomasi penuh untuk setup dan konfigurasi sebuah server web berbasis Debian 12. Semua langkah, mulai dari pengamanan dasar hingga instalasi layanan web, dikelola secara otomatis menggunakan Ansible.

Tujuannya adalah untuk mengubah sebuah server Debian yang baru diinstal menjadi lingkungan web yang siap pakai, aman, dan teroptimasi hanya dengan menjalankan satu perintah.

Arsitektur:

    Control Node (Pengendali): Komputer utama (Host).

    Managed Node (Target): Mesin Virtual Debian 12 di VirtualBox.

✅ Fitur yang Diotomatisasi

Playbook Ansible ini akan mengonfigurasi fitur-fitur berikut secara otomatis:

    Pengamanan SSH (ssh_hardening): Mengganti port, menonaktifkan password, dan melarang login root.

    Instalasi Nginx (nginx): Menambahkan repo Sury, menginstal Nginx dengan Brotli, dan membuat sertifikat SSL self-signed.

    Tuning Performa Nginx (nginx): Mengaktifkan kompresi Brotli & Gzip, mengatur Open File Cache, dan mengoptimalkan Keepalive.

    Proteksi Otomatis (fail2ban): Menginstal dan mengonfigurasi Fail2ban untuk melindungi SSH dan Nginx.

    Deployment Aplikasi Web (webapp): Menyalin file web statis ke direktori server.

📁 Struktur Proyek Ansible

Proyek ini menggunakan struktur berbasis roles yang merupakan praktik terbaik Ansible untuk menjaga agar konfigurasi tetap terorganisir dan dapat digunakan kembali.

ansible-server-setup/
├── inventory             # Mendefinisikan server target
├── playbook.yml          # "Daftar isi" yang menjalankan semua roles
└── roles/
    ├── common/           # Tugas umum (instalasi paket dasar)
    ├── ssh_hardening/    # Semua tugas terkait pengamanan SSH
    ├── fail2ban/         # Semua tugas terkait instalasi & konfigurasi Fail2ban
    ├── nginx/            # Semua tugas terkait Nginx (instalasi, SSL, tuning)
    └── webapp/           # Tugas untuk men-deploy aplikasi web

🚀 Cara Menjalankan Proyek

Proses ini dijalankan dari komputer utama (Host) untuk mengonfigurasi VM Debian (Guest).
Prasyarat

    Ansible terpasang di komputer utama.

    Sebuah VM Debian 12 yang baru diinstal dan berjalan di VirtualBox.

    Kunci SSH dari komputer utama sudah disalin ke dalam VM (ssh-copy-id).

    Port Forwarding di VirtualBox sudah diatur untuk SSH (misal: Host 2222 → Guest 22).

Langkah Eksekusi

    Clone Repositori
    Di komputer utama Anda, clone repositori proyek ini:

    git clone git@github.com:putra05062005/nginx-brotli-setup.git
    cd nginx-brotli-setup

    Jalankan Playbook Ansible
    Dari dalam direktori proyek, jalankan perintah berikut:

    ansible-playbook -i inventory playbook.yml

    Ansible akan terhubung ke VM dan menjalankan semua konfigurasi secara otomatis.

    Verifikasi Hasil
    Setelah playbook selesai, akses website Anda melalui browser di komputer utama:
    https://server.latihan:8443
    (Pastikan file /etc/hosts di komputer utama Anda sudah ditambahkan baris 127.0.0.1 server.latihan dan Port Forwarding untuk HTTPS sudah diatur).

📝 Catatan Proses Manual & Konsep

<details>
<summary>Klik untuk melihat penjelasan detail setiap konfigurasi</summary>
Konfigurasi Penting di Server

Konfigurasi utama untuk proyek ini ada di dalam server Debian pada path berikut:

    /etc/nginx/nginx.conf: Konfigurasi global Nginx, tempat kita mengatur worker, Gzip, Brotli, dan Open File Cache.

    /etc/nginx/sites-available/my-app: Konfigurasi server block untuk aplikasi kita, termasuk pengaturan SSL dan Browser Cache.

    /etc/ssh/sshd_config: Konfigurasi layanan SSH, tempat kita mengubah port dan menonaktifkan login password.

    /etc/fail2ban/jail.local: Konfigurasi Fail2ban untuk proteksi SSH dan Nginx.

    /var/www/my-app/index.html: Lokasi file web statis kita.

Tuning & Hardening yang Diterapkan
Peningkatan Performa

    Worker Processes: worker_processes diatur agar sesuai dengan jumlah core CPU untuk memaksimalkan efisiensi.

    Keepalive: keepalive_timeout diaktifkan untuk menjaga koneksi tetap terbuka dan mengurangi latensi.

    Open File Cache: open_file_cache diaktifkan untuk menyimpan metadata file di memori, mengurangi beban I/O disk.

    Gzip Fallback: Kompresi Gzip diaktifkan sebagai cadangan untuk browser lama yang tidak mendukung Brotli.

Peningkatan Keamanan

    Firewall (UFW): Hanya port yang diperlukan (SSH 2323, Web 80 & 443) yang diizinkan.

    Nginx Security: server_tokens off untuk menyembunyikan versi Nginx dan add_header untuk menerapkan HTTP Security Headers (X-Frame-Options, dll).

    SSH Hardening: PermitRootLogin no untuk mencegah login langsung sebagai root.

    Fail2ban: Diinstal dan aktif untuk secara otomatis memblokir IP yang mencoba serangan brute-force.

Proteksi Otomatis dengan Fail2ban

fail2ban dikonfigurasi dengan beberapa "penjara" (jail) untuk memantau file log dan memblokir alamat IP yang mencurigakan.

    Proteksi SSH [sshd]
    Mengamankan layanan SSH dengan memantau log otentikasi dan memblokir IP yang berulang kali gagal login.

    Proteksi Otentikasi Web [nginx-http-auth]
    Diaktifkan sebagai lapisan keamanan tambahan untuk memblokir percobaan brute-force pada halaman login atau direktori terproteksi.

    Proteksi Scanning Halaman [nginx-404] (Filter Kustom)
    Dibuat filter dan jail kustom untuk memblokir IP yang terlalu sering melakukan scanning halaman yang tidak ada (menghasilkan eror 404).

</details>
📜 Lisensi

MIT License.
