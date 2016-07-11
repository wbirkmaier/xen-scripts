Just a place to throw general Xenserver oriented scripts.

# toolVDI Directory

* vmInventory.sh 
	* create a usable CSV of all VMs on a cluster, that can be used on a disk with just VDIs and create PV Linux VM containers to attach to the VDIs.

* vdiRebuild.sh
	* this will take a list of UUIDs for VDIs and label from a list of VMs.  list should be name-label,vdiUuid,vCpus,vMem,networkLabel in csv format.

* unlockVDI.sh
	* After a host crash, this will take a vm uuid as a paramater, release the disk, then forget it, re introduce to the SR then label and attach back to the VM.

# tool OVS Directory

* resetStorage.sh
	* On xenserver 6.2 if you have this problem: 2015-12-04 22:39:44 [ 3185.974209] nfs: server 172.16.156.228 not responding, timed out, Then do this:
	* tail -f /var/log/messages | awk '/nfs: server/ { system("/bin/sh /root/resetStorage.sh") }'
	* It will shut down the ports for NFS storage network, if allocated seperatly (you must know what they are) and bring them up again, restoring the network
