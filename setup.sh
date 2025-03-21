#!/bin/bash

# Setup script for U6143_ssd1306 on Raspberry Pi
# This will install, compile, and create a systemd service to run on boot

set -e

echo "=== U6143_ssd1306 Setup Script ==="

echo "[Step 1] Enabling I2C interface..."
sudo raspi-config nonint do_i2c 0

echo "[Step 3] Compiling display program..."
cd /home/pi/pi-server-monitor-oled/code
sudo make clean
sudo make

# 5. Create systemd service file
echo "[Step 5] Creating systemd service..."

SERVICE_FILE=/etc/systemd/system/display-oled.service

sudo tee "$SERVICE_FILE" > /dev/null <<EOF
[Unit]
Description=OLED Display System Monitor
After=network.target

[Service]
ExecStart=/home/pi/pi-server-monitor-oled/code/display
WorkingDirectory=/home/pi/pi-server-monitor-oled/code
Restart=on-failure
User=pi

[Install]
WantedBy=multi-user.target
EOF

# 6. Enable and start the service
echo "[Step 6] Enabling and starting the systemd service..."
sudo systemctl daemon-reexec
sudo systemctl daemon-reload
sudo systemctl enable display-oled.service
sudo systemctl start display-oled.service

echo "=== Setup Complete! ==="
echo "The OLED display program is now running and will start on every boot."

