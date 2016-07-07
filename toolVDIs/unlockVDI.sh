#!/bin/bash
# After you do a "xe vm-list resident-on=23698d2e-9faf-4bb3-b06d-88ddc74e9a3f params=uuid | cut -d ":" -f 2 | cut -d " " -f 2 | grep -v ^$ > halted.txt"
# You can then take all your uuids and unlock the VDIs too.
# xe vm-list power-state=halted params=uuid | grep -v ^$ | cut -d ":" -f 2 | cut -d " " -f 2 > halted.txt is another list based on halted vms
# This will only work on PV VMs with a single disk
# for i in `cat halted.txt`; do ./unlockVDI.sh $i; done

if [ -z "$1" ]; then
	echo "Please provide a VM UUID"
	exit 1
fi

# Extract what we need to get the VDI, existing label and SR
#
vdiUuid=$(xe vbd-list vm-uuid=$1 params=vdi-uuid device=xvda --minimal)

if [ -z "$vdiUuid" ]; then
	echo "No VDI Found!" 
	exit 1
fi

vdiNameLabel=$(xe vdi-list uuid=$vdiUuid params=name-label --minimal)
vdiSrUuid=$(xe vdi-list uuid=$vdiUuid params=sr-uuid --minimal)

echo "Found VDI $vdiUuid with the Name-Label $vdiNameLabel on SR $vdiSrUuid"

# Release the VDI from the VM and re-introduce to the SR
#
xe vdi-forget uuid=$vdiUuid
xe sr-scan uuid=$vdiSrUuid

# Label it with our stored name-label
#
xe vdi-param-set name-label="$vdiNameLabel" uuid=$vdiUuid

echo "Creating VBD and Attaching to VM"

# This checks to see if the VBD has been deleted, otherwise an error will occur when creating again
#
deviceState=$(xe vbd-list vm-uuid=$1 params=device --minimal)

echo -n "Checking VBD Removal State ..."

while [  "$deviceState" != "" ]; do 
	echo -n "."
	deviceState=$(xe vbd-list vm-uuid=$1 params=device --minimal)		
done

echo ""

# Attach it back to our instance (VM)
#
echo "VBD UUID:"
xe vbd-create vdi-uuid=$vdiUuid vm-uuid=$1 device=xvda bootable="true" type="Disk"

# Start VM
#
echo "Starting VM"
xe vm-start vm="$(xe vm-list uuid=$1 params=name-label --minimal)"

echo "$(xe vm-list uuid=$1 params=name-label --minimal) started!"
