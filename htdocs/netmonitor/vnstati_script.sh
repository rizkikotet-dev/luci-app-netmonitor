#!/bin/bash

# Direktori log
LOG_DIR="/var/log/netmonitor"
LOG_FILE="$LOG_DIR/netmonitor-vnstati.log"

# Buat direktori log jika belum ada
mkdir -p "$LOG_DIR"

# Fungsi untuk menulis log
log() {
    local message="$1"
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $message" >> "$LOG_FILE"
}

# Fungsi untuk menjalankan perintah vnstati
run_vnstati() {
    log "Memulai pembuatan grafik vnstati..."

    vnstati -s -i br-lan -o /www/netmonitor/br-lan_vnstat_s.png && log "Grafik -s berhasil dibuat" || log "Gagal membuat grafik -s"
    vnstati -5 -i br-lan -o /www/netmonitor/br-lan_vnstat_5.png && log "Grafik -5 berhasil dibuat" || log "Gagal membuat grafik -5"
    vnstati -h -i br-lan -o /www/netmonitor/br-lan_vnstat_h.png && log "Grafik -h berhasil dibuat" || log "Gagal membuat grafik -h"
    vnstati -d -i br-lan -o /www/netmonitor/br-lan_vnstat_d.png && log "Grafik -d berhasil dibuat" || log "Gagal membuat grafik -d"
    vnstati -m -i br-lan -o /www/netmonitor/br-lan_vnstat_m.png && log "Grafik -m berhasil dibuat" || log "Gagal membuat grafik -m"
    vnstati -y -i br-lan -o /www/netmonitor/br-lan_vnstat_y.png && log "Grafik -y berhasil dibuat" || log "Gagal membuat grafik -y"
    vnstati -t -i br-lan -o /www/netmonitor/br-lan_vnstat_t.png && log "Grafik -t berhasil dibuat" || log "Gagal membuat grafik -t"

    log "Pembuatan grafik vnstati selesai."
}