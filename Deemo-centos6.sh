#!/bin/bash
while true; do
clear
read -p "HI!use this or not?, y or n?? " yn
case $yn in
[Yy]* ) make install; 
echo -----------------------------------------------------
echo "Please Wait! While Updating System Files"
echo -----------------------------------------------------
sleep 3
sudo mv /etc/localtime /etc/localtime.bak
sudo ln -s /usr/share/zoneinfo/Asia/Manila /etc/localtime
date
rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-6.noarch.rpm
rpm -Uvh http://rpms.famillecollet.com/enterprise/remi-release-6.rpm
yum upgrade -y
yum -y install npm git zip unzip epel-release nano wget lynx yum-utils nano
yum -y install gcc zlib-devel openssl-devel readline-devel ncurses-devel squid 
yum groupinstall "Development Tools" -y
yum update -y
echo '
Port 22' >> /etc/ssh/sshd_config
echo -----------------------------------------------------
echo Please Wait! While Inserting IP Tables
echo -----------------------------------------------------
sleep 2
echo '
net.ipv4.ip_forward = 1
net.ipv4.conf.default.rp_filter = 1
net.ipv4.conf.default.accept_source_route = 0
kernel.sysrq = 0
kernel.core_uses_pid = 1
net.ipv4.tcp_syncookies = 1
kernel.msgmnb = 65536
kernel.msgmax = 65536
kernel.shmmax = 68719476736
kernel.shmall = 4294967296' > /etc/sysctl.conf
iptables -F; iptables -X; iptables -Z
iptables -A FORWARD -m string --algo bm --string "BitTorrent" -j DROP
iptables -A FORWARD -m string --string "announce_peer" --algo bm -j LOGDROP
iptables -A FORWARD -m string --string "find_node" --algo bm -j LOGDROP
iptables -A FORWARD -m string --string "get_peers" --algo bm -j DROP
iptables -A FORWARD -p tcp --dport 6881:6889 -j DROP
iptables -A FORWARD -p udp -m string --algo bm --string ".torrent" -j DROP
iptables -A FORWARD -p udp -m string --algo bm --string "announce" -j DROP
iptables -A FORWARD -p udp -m string --algo bm --string "announce.php?passkey=" -j DROP
iptables -A FORWARD -p udp -m string --algo bm --string "BitTorrent protocol" -j DROP
iptables -A FORWARD -p udp -m string --algo bm --string "BitTorrent" -j DROP
iptables -A FORWARD -p udp -m string --algo bm --string "info_hash" -j DROP 
iptables -A FORWARD -p udp -m string --algo bm --string "peer_id=" -j DROP
iptables -A FORWARD -p udp -m string --algo bm --string "torrent" -j DROP 
iptables -A FORWARD -p udp -m string --algo bm --string "tracker" -j DROP  
iptables -A INPUT -f -j DROP
iptables -A INPUT -i lo -j ACCEPT
iptables -A INPUT -i tap_vpn -p tcp --dport 53 -j ACCEPT
iptables -A INPUT -i tap_vpn -p udp --dport 53 -j ACCEPT
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A INPUT -m string --algo bm --string ".exe?/c_tftp" -j DROP
iptables -A INPUT -m string --algo bm --string ".exe?/c+dir" -j DROP
iptables -A INPUT -m string --algo bm --string ".torrent" -j DROP
iptables -A INPUT -m string --algo bm --string "/default.ida?" -j DROP
iptables -A INPUT -m string --algo bm --string "announce" -j DROP
iptables -A INPUT -m string --algo bm --string "announce.php?passkey=" -j DROP
iptables -A INPUT -m string --algo bm --string "BitTorrent protocol" -j DROP
iptables -A INPUT -m string --algo bm --string "BitTorrent" -j DROP
iptables -A INPUT -m string --algo bm --string "info_hash" -j DROP
iptables -A INPUT -m string --algo bm --string "peer_id=" -j DROP
iptables -A INPUT -m string --algo bm --string "torrent" -j DROP
iptables -A INPUT -m string --string ".torrent" --algo bm --to 65535 -j DROP
iptables -A INPUT -m string --string "announce" --algo bm --to 65535 -j DROP
iptables -A INPUT -m string --string "announce" --algo kmp -j DROP
iptables -A INPUT -m string --string "announce" --algo kmp --to 65535 -j DROP
iptables -A INPUT -m string --string "announce.php?passkey=" --algo bm --to 65535 -j DROP
iptables -A INPUT -m string --string "announce.php?passkey=" --algo kmp -j DROP
iptables -A INPUT -m string --string "announce.php?passkey=" --algo kmp --to 65535 -j DROP
iptables -A INPUT -m string --string "announce_peers" --algo kmp -j DROP
iptables -A INPUT -m string --string "announce_peers" --algo kmp --to 65535 -j DROP
iptables -A INPUT -m string --string "BitTorrent protocol" --algo bm --to 65535 -j DROP
iptables -A INPUT -m string --string "BitTorrent protocol" --algo kmp -j DROP
iptables -A INPUT -m string --string "BitTorrent protocol" --algo kmp --to 65535 -j DROP
iptables -A INPUT -m string --string "BitTorrent" --algo bm --to 65535 -j DROP
iptables -A INPUT -m string --string "BitTorrent" --algo kmp -j DROP
iptables -A INPUT -m string --string "BitTorrent" --algo kmp --to 65535 -j DROP
iptables -A INPUT -m string --string "bittorrent-announce" --algo kmp -j DROP
iptables -A INPUT -m string --string "bittorrent-announce" --algo kmp --to 65535 -j DROP
iptables -A INPUT -m string --string "find_node" --algo kmp -j DROP
iptables -A INPUT -m string --string "find_node" --algo kmp --to 65535 -j DROP
iptables -A INPUT -m string --string "get_peers" --algo kmp -j DROP
iptables -A INPUT -m string --string "get_peers" --algo kmp --to 65535 -j DROP
iptables -A INPUT -m string --string "info_hash" --algo bm --to 65535 -j DROP
iptables -A INPUT -m string --string "info_hash" --algo kmp -j DROP
iptables -A INPUT -m string --string "info_hash" --algo kmp --to 65535 -j DROP
iptables -A INPUT -m string --string "peer_id" --algo kmp -j DROP
iptables -A INPUT -m string --string "peer_id" --algo kmp --to 65535 -j DROP
iptables -A INPUT -m string --string "peer_id=" --algo bm --to 65535 -j DROP
iptables -A INPUT -m string --string "torrent" --algo bm --to 65535 -j DROP
iptables -A INPUT -p tcp ! --syn -m state --state NEW -j DROP
iptables -A INPUT -p tcp --dport 22 -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -A INPUT -p tcp --dport 443 -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -A INPUT -p tcp --dport 80 -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -A INPUT -p tcp -m multiport --dports 80,443 -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -A INPUT -p tcp -m state --state NEW,ESTABLISHED -m tcp --dport 53 -j ACCEPT
iptables -A INPUT -p tcp --sport 22 -m state --state ESTABLISHED -j ACCEPT
iptables -A INPUT -p tcp --tcp-flags ALL ALL -j DROP
iptables -A INPUT -p tcp --tcp-flags ALL NONE -j DROP
iptables -A INPUT -p udp -m state --state NEW,ESTABLISHED -m udp --dport 53 -j ACCEPT
iptables -A INPUT -p udp -m string --algo bm --string ".torrent" -j DROP 
iptables -A INPUT -p udp -m string --algo bm --string "announce" -j DROP 
iptables -A INPUT -p udp -m string --algo bm --string "announce.php?passkey=" -j DROP
iptables -A INPUT -p udp -m string --algo bm --string "BitTorrent protocol" -j DROP
iptables -A INPUT -p udp -m string --algo bm --string "BitTorrent" -j DROP 
iptables -A INPUT -p udp -m string --algo bm --string "info_hash" -j DROP 
iptables -A INPUT -p udp -m string --algo bm --string "peer_id=" -j DROP 
iptables -A INPUT -p udp -m string --algo bm --string "torrent" -j DROP 
iptables -A INPUT -p udp -m string --algo bm --string "tracker" -j DROP  
iptables -A OUTPUT -m state --state ESTABLISHED -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT
iptables -A OUTPUT -p icmp --icmp-type echo-request -j DROP
iptables -A OUTPUT -p tcp --dport 22 -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -A OUTPUT -p tcp --dport 6881:6889 -j DROP
iptables -A OUTPUT -p tcp -j ACCEPT
iptables -A OUTPUT -p tcp -m multiport --dports 80,443 -m state --state ESTABLISHED -j ACCEPT 
iptables -A OUTPUT -p tcp --sport 22 -m state --state ESTABLISHED -j ACCEPT
iptables -A OUTPUT -p tcp --sport 443 -m state --state ESTABLISHED -j ACCEPT
iptables -A OUTPUT -p tcp --sport 80 -m state --state ESTABLISHED -j ACCEPT
iptables -A OUTPUT -p udp -j ACCEPT
iptables -t nat -A POSTROUTING -s 192.168.7.0/24 -j SNAT --to-source 128.199.125.105
iptables -t nat -A POSTROUTING -s 192.168.7.0/24 -o eth0 -j MASQUERADE
service iptables save
service iptables save
service iptables restart
ifconfig
history -c
echo -----------------------------------------------------
echo Please Wait! While Dowloading Softether!
echo -----------------------------------------------------
sleep 2
wget http://www.softether-download.com/files/softether/v4.25-9656-rtm-2018.01.15-tree/Linux/SoftEther_VPN_Server/64bit_-_Intel_x64_or_AMD64/softether-vpnserver-v4.25-9656-rtm-2018.01.15-linux-x64-64bit.tar.gz
tar xzvf softether-vpnserver-v4.25-9656-rtm-2018.01.15-linux-x64-64bit.tar.gz
cd vpnserver
echo "Please press 1 for all the following questions."
sleep 1
make
cd ..
sleep 1
mv vpnserver /usr/local
cd /usr/local/vpnserver/
chmod 600 *
chmod 700 vpnserver
chmod 700 vpncmd
echo '#!/bin/sh
### BEGIN INIT INFO
# Provides:          vpnserver
# Required-Start:    $remote_fs $syslog
# Required-Stop:     $remote_fs $syslog
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Start daemon at boot time
# Description:       Enable Softether by daemon.
### END INIT INFO
DAEMON=/usr/local/vpnserver/vpnserver
LOCK=/var/lock/subsys/vpnserver
TAP_ADDR=192.168.7.1
test -x $DAEMON || exit 0
case "$1" in
start)
$DAEMON start
touch $LOCK
sleep 1
/sbin/ifconfig tap_vpn $TAP_ADDR
;;
stop)
$DAEMON stop
rm $LOCK
;;
restart)
$DAEMON stop
sleep 3
$DAEMON start
sleep 1
/sbin/ifconfig tap_vpn $TAP_ADDR
;;
*)
echo "Usage: $0 {start|stop|restart}"
exit 1
esac
exit 0' > /etc/init.d/vpnserver
chmod 755 /etc/init.d/vpnserver 
/sbin/chkconfig --add vpnserver 
chkconfig --add vpnserver 
chkconfig vpnserver on
echo 'net.ipv4.ip_forward = 1' > /etc/sysctl.d/ipv4_forwarding.conf
cat /etc/sysctl.d/ipv4_forwarding.conf
sysctl --system
history -c
clear
sleep 1
echo -----------------------------------------------------
echo Install finish! The System will be rebooted!
echo ------------------------------------------------------
sleep 3
reboot
break;;
[Nn]* ) exit;;
* ) echo "Please answer yes or no.";;
esac
done
