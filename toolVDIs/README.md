* vmInventory.sh
	* create a usable CSV of all VMs on a cluster, that can be used on a disk with just VDIs and create PV Linux VM containers to attach to the VDIs.

* vdiRebuild.sh
	* this will take a list of UUIDs for VDIs and label from a list of VMs.  list should be name-label,vdiUuid,vCpus,vMem,networkLabel in csv format.

* unlockVDI.sh
	* After a host crash, this will take a vm uuid as a paramater, release the disk, then forget it, re introduce to the SR then label and attach back to the VM.
