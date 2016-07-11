#!/bin/bash
# On xenserver 6.2 if you have this problem:
# 2015-12-04 22:39:44 [ 3185.974209] nfs: server 172.16.156.228 not responding, timed out
# Then do this:
# tail -f /var/log/messages | awk '/nfs: server/ { system("/bin/sh /root/resetStorage.sh") }'
# It will shut down the ports for NFS storage network, if allocated seperatly (you must know what they are) and bring them up again, restoring the network
ovs-vsctl show
ovs-ofctl show xapi0
ovs-ofctl mod-port xapi0 eth3 down
ovs-ofctl mod-port xapi0 eth2 down
ovs-ofctl mod-port xapi0 xapi0 down
ovs-ofctl mod-port xapi0 xapi5 down
sleep 5
echo Starting storage
ovs-ofctl mod-port xapi0 eth3 up
ovs-ofctl mod-port xapi0 eth2 up
ovs-ofctl mod-port xapi0 xapi0 up
ovs-ofctl mod-port xapi0 xapi5 up
ovs-vsctl show
