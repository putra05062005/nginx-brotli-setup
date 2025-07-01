# NGINX Brotli Setup with SSL & Static Web on Debian 12

🖥️ Proyek ini adalah mini setup server menggunakan Debian 12 di VirtualBox.  
Menggunakan NGINX + Brotli + SSL self-signed + aplikasi web statis.

## ✅ Fitur

- SSH via port forwarding (port default diganti)
- Login SSH pakai SSH Key (tanpa password)
- Web server NGINX (versi `nginx-extras` dari repo Sury)
- Sertifikat SSL self-signed (HTTPS)
- Modul Brotli aktif (kompresi super cepat)
- Browser cache untuk file statis
- Web statis sederhana `index.html`

## 📁 Struktur Proyek

nginx-brotli-setup/
├── index.html # Halaman utama
├── nginx.conf # Konfigurasi global NGINX
├── sites-available/
│ └── my-app # Konfigurasi situs virtual host
├── ssl/
│ ├── nginx-selfsigned.crt
│ └── nginx-selfsigned.key
├── setup_ssh.md # Catatan setup SSH + port forwarding
├── README.md # Dokumentasi proyek ini

## 🚀 Cara Coba

1. Jalankan Debian VM via VirtualBox
2. Akses:

ssh user@127.0.0.1 -p 2323

3. Buka browser:
https://127.0.0.1:8443

4. Cek `Content-Encoding: br` → tandanya Brotli aktif ✅

## 📜 Lisensi
MIT License.

📄 .gitignore

# Sertifikat pribadi jangan dipush!
ssl/*.key

# File editor
*.swp
*.swo

# Log dan cache
*.log
*.cache
📄 setup_ssh.md (catatan dokumentasi opsional)

# Setup SSH & Port Forwarding

## 🔐 SSH Key & Login
- Generate: `ssh-keygen`
- Copy ke server: `ssh-copy-id -p 2222 user@127.0.0.1`
- Login: `ssh user@127.0.0.1 -p 2323`

## ⚙️ Konfigurasi SSH di Server
Ubah di `/etc/ssh/sshd_config`:

Port 2323
PasswordAuthentication no


Restart:

sudo systemctl restart sshd


## 🌐 Port Forwarding (VirtualBox)
- SSH: Host Port `2222` → Guest Port `2323`
- HTTPS: Host Port `8443` → Guest Port `443`

