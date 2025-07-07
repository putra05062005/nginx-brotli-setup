#!/bin/bash

echo "[✔] Copying site config..."
sudo cp sites-available/my-app /etc/nginx/sites-available/
sudo ln -sf /etc/nginx/sites-available/my-app /etc/nginx/sites-enabled/

echo "[✔] Copying SSL cert..."
sudo mkdir -p /etc/ssl/localcerts
sudo cp ssl/nginx-selfsigned.* /etc/ssl/localcerts/

echo "[✔] Copying nginx.conf..."
sudo cp nginx.conf /etc/nginx/nginx.conf

echo "[✔] Restarting NGINX..."
sudo nginx -t && sudo systemctl restart nginx

echo "[✅] Done! Website should be live at https://127.0.0.1:8443"
