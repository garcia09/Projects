#!/bin/bash



#changes hostname of computer
hostname_Change(){
cur_Hostname=$(cat /etc/hostname)
read -p "Enter Hostname: " hname
# Change the hostname
hostnamectl set-hostname $hname
hostname $hname
# Updates /etc/hostname
# Change hostname in /etc/hosts & /etc/hostname
sudo sed -i "s/localhost.*/$hname/g" /etc/hosts
sudo sed -i "s/$cur_Hostname/$hname/g" /etc/hostname

printf "Hostname was changed to: " $hname

}

packages_install(){
packages=(bind bind-utils)
for i in "${packages[@]}"
do
  dnf install "$i" -y
  if [[ "$?" -ne 1 ]];
    then
      echo "Unable to install $1"
      break
    else
      curl "sucessful"
  fi
done

}

#starts dns server and Configuring BIND DNS
dns_start(){
  #starts service
  systemctl start named
  systemctl enable named
  systemctl status named

  #configures BIND dns
  cp /etc/named.conf /etc/named.conf.orig
  sep 's/listen-on port 53 { 127.0.0.1; };/#listen-on port 53 { 127.0.0.1; };' /etc/named.conf
  sep 's/listen-on-v6 port 53 { ::1; };/#listen-on-v6 port 53 { ::1; };' /etc/named.conf



}




#Main
hostname_Change

packages_install
