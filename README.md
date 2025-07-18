# 🛡️ Proyek Otomasi Server Debian dengan Ansible 🚀

## 📖 Gambaran Umum

Proyek ini adalah implementasi **otomasi penuh** untuk setup dan konfigurasi server web berbasis **Debian 12** menggunakan **Ansible**.

Tujuannya adalah mengubah server Debian yang baru diinstal menjadi **lingkungan web yang siap pakai, aman, dan optimal** — hanya dengan menjalankan satu perintah.

### 🏗️ Arsitektur

- **Control Node**: Komputer utama (Host) tempat menjalankan Ansible.
- **Managed Node**: Mesin Virtual Debian 12 (Guest VM di VirtualBox).

---

## ✅ Fitur yang Diotomatisasi

Playbook Ansible ini mengelola konfigurasi berikut secara otomatis:

- 🔐 **SSH Hardening**: Ganti port, nonaktifkan password, dan larang login root.
- 🌐 **Instalasi Nginx**: Tambah repo Sury, instal Nginx dengan Brotli, setup SSL self-signed.
- 🚀 **Tuning Nginx**: Aktifkan Brotli & Gzip, open file cache, keepalive optimization.
- 🔒 **Proteksi Fail2ban**: Proteksi terhadap brute-force untuk SSH & Nginx.
- 🌍 **Deployment WebApp**: Salin file statis ke `/var/www/my-app`.

---

## 📁 Struktur Proyek

ansible-server-setup/
├── inventory # File target host
├── playbook.yml # Main playbook
├── roles/
│ ├── common/ # Instalasi paket dasar
│ ├── ssh_hardening/ # Pengamanan SSH
│ ├── fail2ban/ # Instal & konfigurasi Fail2ban
│ ├── nginx/ # Instalasi & tuning Nginx
│ └── webapp/ # Deployment aplikasi web statis
├── roles_config.yml # Konfigurasi parameter per-role
└── ssl/ # Sertifikat SSL lokal (self-signed)



---

## 🚀 Cara Menjalankan

### ⚙️ Prasyarat

- Ansible sudah terinstal di Host.
- VM Debian 12 berjalan di VirtualBox.
- SSH key Host sudah disalin ke VM (`ssh-copy-id`).
- Port forwarding VirtualBox sudah diatur:
  - SSH: Host 2222 → Guest 22
  - HTTPS: Host 8443 → Guest 443

### 🧪 Langkah Eksekusi

1. **Clone repositori:**

```bash
git clone https://github.com/putra05062005/nginx-brotli-setup.git
cd nginx-brotli-setup


Jalankan playbook:

ansible-playbook -i inventory playbook.yml

Verifikasi:
Buka browser dan akses: 
https://server.latihan:8443
⚠️ Tambahkan 127.0.0.1 server.latihan ke file /etc/hosts di komputer Host.

🔍 Konfigurasi Penting
File	Fungsi
/etc/nginx/nginx.conf	Konfigurasi utama Nginx
/etc/nginx/sites-available/my-app	Konfigurasi VirtualHost / SSL
/etc/ssh/sshd_config	Pengaturan SSH
/etc/fail2ban/jail.local	Jail & filter Fail2ban
/var/www/my-app/index.html	File web yang dideploy

⚙️ Tuning & Hardening
📈 Performa

    worker_processes sesuai jumlah CPU core

    keepalive_timeout diatur untuk efisiensi koneksi

    open_file_cache aktif untuk kurangi beban disk

    gzip fallback untuk browser lama

🔐 Keamanan

    SSH Hardening: PermitRootLogin no, PasswordAuthentication no

    Fail2ban: Melindungi SSH, Nginx, dan custom jail 404

    Nginx security headers: X-Frame-Options, X-Content-Type-Options, dll.

    UFW (opsional): Buka hanya port 2323 (SSH), 80, 443

🛡️ Proteksi Otomatis (Fail2ban)

    sshd: blok brute-force login SSH

    nginx-http-auth: blok serangan ke basic-auth

    nginx-404: filter kustom blok scanning halaman tidak valid

📝 Lisensi

MIT License

Dibuat oleh pahala Putra Tambunan


---

