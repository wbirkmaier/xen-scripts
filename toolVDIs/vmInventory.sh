#!/bin/bash
# Extract all VMs on a cluster and build a
# CSV File for all your data to manipulate with name-label,vdiUuid,vCpus,vMem,networkLabel
# Only works with VMS that have XVDA and primary disk

nameLabelFile=vdiImport.csv
seperator=","

# Grab all the vm uuids, strip commas and place in a variable
vms=$(xe vm-list params=uuid --minimal | sed 's/,/ /g')

# Create empty CSV
touch $nameLabelFile

# FOR loop to pull all the needed records and put in a CSV
for vmUuid in $vms
	do	

		# Get name-label from vm uuid
		nameLabel=$(xe vm-param-get uuid=$vmUuid param-name=name-label)

		# Get vdi uuid
		vdiUuid=$(xe vbd-list vm-uuid=$vmUuid device=xvda params=vdi-uuid --minimal)

		# Get vCPUs
		vCPUs=$(xe vm-param-get uuid=$vmUuid param-name=VCPUs-number)

		# Get vMem
		vMem=$(xe vm-param-get uuid=$vmUuid param-name=memory-static-max)

		# Get vlan label vi network label
		netUuid=$(xe vif-list vm-uuid=$vmUuid params=network-uuid --minimal)
		vlanLabel=$(xe network-list uuid=$netUuid params=name-label --minimal)

		# Create CSV record
		echo $nameLabel$seperator$vdiUuid$seperator$vCPUs$seperator$vMem$seperator$vlanLabel >> $nameLabelFile

	done
