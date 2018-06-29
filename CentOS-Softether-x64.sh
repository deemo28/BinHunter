#-------------------------------------------------------
#Softether Auto Install Script
#For OS Centos
#Script Coded by Syahz86
#https://github.com/syahz86/SoftetherAutoInstall
#Script Based from tutorial by lincolin.hk
#Good Luck!
#-------------------------------------------------------

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

#Install Development packages:
yum -y groupinstall "Development Tools"

#Get the Softether Packages via wget and Save it into /root
wget http://www.softether-download.com/files/softether/v4.27-9668-beta-2018.05.29-tree/Linux/SoftEther_VPN_Server/64bit_-_Intel_x64_or_AMD64/softether-vpnserver-v4.27-9668-beta-2018.05.29-linux-x64-64bit.tar.gz

#Unpack into /usr/local/
tar -xvzf softether-vpnserver-v4.10-9473-beta-2014.07.12-linux-x64-64bit.tar.gz -C /usr/local/

#Change permissions and install
chmod -R 744 /usr/local/vpnserver
cd /usr/local/vpnserver
make

#Create init start/stop script
wget https://raw.githubusercontent.com/syahz86/SoftetherAutoInstall/master/misc/vpnserver-centos.sh --no-check-certificate
mv vpnserver-centos.sh /etc/init.d/vpnserver
cd /etc/init.d

#Now server can be started and added to autostart
chmod 755 /etc/init.d/vpnserver
/etc/init.d/vpnserver start
chkconfig vpnserver on

echo "-----------------------------------------------------"
echo "Install finish!"
echo "check this step to check are installer is working properly"
echo "1. vpnserver and vpncmd is on /usr/local/vpnserver"
echo -e "2. \e[1;33;44m/etc/init.d/vpnserver start\e[0m to check softether status"
echo -e "if vpnserver started, paste \e[1;33;44mcd /usr/local/vpnserver\e[0m then \e[1;33;44m./vpncmd\e[0m for VPN configuration"
echo "------------------------------------------------------"
exit
