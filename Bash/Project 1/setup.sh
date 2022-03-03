POWER 9 RHEL 8.x KVM setup
#!/bin/bash


## Setup yum.repos

cd /etc/yum.repos.d/ &&


## Update system

dnf update -y


# Generate SSH key
cat /dev/zero | ssh-keygen -q -N ""




## Update sshd_config file

sed -i 's/#PermitRootLogin yes/PermitRootLogin yes/' /etc/ssh/sshd_config
sed -i 's/#PrintLastLog yes/PrintLastLog no/' /etc/ssh/sshd_config
sed -i 's/#MaxSessions 10/MaxSessions 500/' /etc/ssh/sshd_config
sed -i 's/#MaxStartups 10:30:100/MaxStartups 500/' /etc/ssh/sshd_config


# Update ssh_config file

sed -i 's/#   StrictHostKeyChecking ask/   StrictHostKeyChecking no/' /etc/ssh/ssh_config
printf "\n    UserKnownHostsFile /dev/null" >> /etc/ssh/ssh_config
printf "\n    LogLevel QUIET\n" >> /etc/ssh/ssh_config


## Disable firewall

systemctl stop firewalld

systemctl disable firewalld


## Disable SELinux

sed -i 's/SELINUX=enforcing/SELINUX=disabled/' /etc/selinux/config


## Disable kdump

systemctl stop kdump

systemctl disable kdump


## Install and Configure Chrony (Replacing NTP)

dnf install chrony -y

echo "# chrony.conf for RHEL/CentOS based systems

driftfile /var/lib/chrony/drift





rtcsync

keyfile /etc/chrony.keys

leapsectz right/UTC

logdir /var/log/chrony" > /etc/chrony.conf

systemctl enable chronyd
systemctl restart chronyd


# Install sysstat

dnf install -y sysstat

systemctl enable sysstat && systemctl restart sysstat


## Install and enable multipath

dnf install -y device-mapper-multipath

mpathconf --enable --with_multipathd y


## Install all other extra packages

dnf install -y wget ipmitool tar lsof net-tools nfs-utils network-scripts


## Configure limit


## Tune /etc/sysctl.conf file


## Change permission for /etc/rc.local

chmod 755 /etc/rc.d/rc.local
