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
