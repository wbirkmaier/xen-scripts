This will run through a cluster and get:

* Hostname as reported to xenserver
* CPUs
* Memory
* Networks
* OS
* Number of disks and size in bytes (Includes un/mounted optical media)

Example:

Name: insight-elasticsearch1-10.bur.us.genstage
CPUs: 8
Memory: 5368709120
Networks: 0/ip: 10.12.60.21; 0/ipv6/0: fe80::50b8:2aff:fe78:ba88
OS: name: CentOS release 6.6 (Final); uname: 3.10.56-11.el6.centos.alt.x86_64; distro: centos; major: 6; minor: 6
Disk 0 Size: 32212254720

Some fields such as network and os can not be pulled without xentools, an example:

Name: qajump1-01.bur.us.gendev
CPUs: 2
Memory: 8589934592
Networks: <not in database>
OS: <not in database>
Disk 0 Size: 68719476736
Disk 1 Size: 4283871232
