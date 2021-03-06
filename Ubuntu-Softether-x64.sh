#!/bin/bash
# Softether VPN Bridge with dnsmasq for Ubuntu
# References:
# - https://gist.github.com/AyushSachdev/edc23605438f1cccdd50
# - https://www.digitalocean.com/community/articles/how-to-setup-a-multi-protocol-vpn-server-using-softether
# - http://blog.lincoln.hk/blog/2013/05/17/softether-on-vps-using-local-bridge/
SERVER_IP=""
SERVER_PASSWORD=""
SHARED_KEY=""
USER=""

echo -n "Enter Server IP: "
read SERVER_IP
echo -n "Set VPN Username to create: "
read USER
read -s -p "Set VPN Password: " SERVER_PASSWORD
echo ""
read -s -p "Set IPSec Shared Keys: " SHARED_KEY
echo ""
echo "+++ Now sit back and wait until the installation finished +++"
HUB="VPN"
HUB_PASSWORD=${SERVER_PASSWORD}
USER_PASSWORD=${SERVER_PASSWORD}
TARGET="/usr/local/"

apt-get update && apt-get -qq upgrade
apt-get -y install wget build-essential dnsmasq expect
sleep 2
wget http://www.softether-download.com/files/softether/v4.27-9668-beta-2018.05.29-tree/Linux/SoftEther_VPN_Server/64bit_-_Intel_x64_or_AMD64/softether-vpnserver-v4.27-9668-beta-2018.05.29-linux-x64-64bit.tar.gz
tar xzvf softether-vpnserver-v4.27-9668-beta-2018.05.29-linux-x64-64bit.tar.gz -C $TARGET
rm -rf softether-vpnserver-v4.27-9668-beta-2018.05.29-linux-x64-64bit.tar.gz
cd ${TARGET}vpnserver
expect -c 'spawn make; expect number:; send 1\r; expect number:; send 1\r; expect number:; send 1\r; interact'
find ${TARGET}vpnserver -type f -print0 | xargs -0 chmod 600
chmod 700 ${TARGET}vpnserver/vpnserver ${TARGET}vpnserver/vpncmd
mkdir -p /var/lock/subsys
echo "net.ipv4.ip_forward = 1" >> /etc/sysctl.d/ipv4_forwarding.conf
sysctl --system
wget -P /etc/init.d https://gist.githubusercontent.com/abegodong/15948f26c8683ab1f5be/raw/6fefa2600ae7730e4aa97328a78c94bbaa25fcf1/vpnserver
sed -i "s/\[SERVER_IP\]/${SERVER_IP}/g" /etc/init.d/vpnserver
chmod 755 /etc/init.d/vpnserver && /etc/init.d/vpnserver start
update-rc.d vpnserver defaults
${TARGET}vpnserver/vpncmd localhost /SERVER /CMD ServerPasswordSet ${SERVER_PASSWORD}
${TARGET}vpnserver/vpncmd localhost /SERVER /PASSWORD:${SERVER_PASSWORD} /CMD HubCreate ${HUB} /PASSWORD:${HUB_PASSWORD}
${TARGET}vpnserver/vpncmd localhost /SERVER /PASSWORD:${SERVER_PASSWORD} /HUB:${HUB} /CMD UserCreate ${USER} /GROUP:none /REALNAME:none /NOTE:none
${TARGET}vpnserver/vpncmd localhost /SERVER /PASSWORD:${SERVER_PASSWORD} /HUB:${HUB} /CMD UserPasswordSet ${USER} /PASSWORD:${USER_PASSWORD}
${TARGET}vpnserver/vpncmd localhost /SERVER /PASSWORD:${SERVER_PASSWORD} /CMD IPsecEnable /L2TP:yes /L2TPRAW:yes /ETHERIP:yes /PSK:${SHARED_KEY} /DEFAULTHUB:${HUB}
${TARGET}vpnserver/vpncmd localhost /SERVER /PASSWORD:${SERVER_PASSWORD} /CMD BridgeCreate ${HUB} /DEVICE:soft /TAP:yes
cat <<EOF >> /etc/dnsmasq.conf
interface=tap_soft
dhcp-range=tap_soft,10.100.10.128,10.100.10.254,12h
dhcp-option=tap_soft,3,10.100.10.1
port=5353
dhcp-option=option:dns-server,209.244.0.3,209.244.0.4
EOF
service dnsmasq restart
service vpnserver restart
echo "+++ Installation finished +++"
