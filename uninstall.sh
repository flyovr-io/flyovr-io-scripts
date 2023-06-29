#!/bin/bash
set -x

IPATH=/usr/local/share/flyovrio

systemctl disable --now flyovrio-mlat
systemctl disable --now flyovrio-mlat2 &>/dev/null
systemctl disable --now flyovrio-feed

if [[ -d /usr/local/share/tar1090/html-flyovrio ]]; then
    bash /usr/local/share/tar1090/uninstall.sh flyovrio
fi

rm -f /lib/systemd/system/flyovrio-mlat.service
rm -f /lib/systemd/system/flyovrio-mlat2.service
rm -f /lib/systemd/system/flyovrio-feed.service

cp -f "$IPATH/flyovrio-uuid" /tmp/flyovrio-uuid
rm -rf "$IPATH"
mkdir -p "$IPATH"
mv -f /tmp/flyovrio-uuid "$IPATH/flyovrio-uuid"

set +x

echo -----
echo "flyovr.io feed scripts have been uninstalled!"
