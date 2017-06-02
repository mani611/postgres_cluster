Create a virtual machine centos7.2
- with minimal install
- with test user
- with 2 interface 1 is NAT and 1 is hostonly
- mount /dev/sr0 /media
- set hostname (/etc/hostname) post1(192.168.122.201) and post2(192.168.122.202)
- make interface as eth0 and eth1
==========================================================
 static ip  at eth0 of post1 192.168.122.201 and and eth0 of post2 192.168.122.202
=============================================================
- host file entry
==================================================
cat /etc/hosts
127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6
192.168.122.103 pcmk-storage.clusterlabs.org pcmk-storage #ansible environment server
192.168.122.201 post1   post1
192.168.122.202 post2   post2
=========================================================
-configure ssh passwordless connection with ansible host to deployment host
- make sudo acees to deployment host
============================================================
disable selinux
reboot

clone https://github.com/mani611/postgres_cluster

and run
cd postgres1
ansible-playbook -i inventory/inventory playbook/main.yaml

