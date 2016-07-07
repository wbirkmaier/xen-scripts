#!/bin/bash
# Need the below command to be accomplished for a CSV of name-label and uuid
# xe vdi-param-set uuid=edeea3be-ff66-4994-8779-0c93c0f629cb name-label=vm.example.com
# This wil NOT WORK IF YOU HAVE MORE THAN 1 VDI Associated with the VM.

# CSV File for all your data to manipulate with name-label,vdiUuid,vCpus,vMem,networkLabel
nameLabelFile=sample.csv

# SR that new VDI files are on
srUuid=46c81cbc-eeda-eba5-9b7b-0a806bdadc6f

# UUID of generic template
templateUuid=$(xe template-list params=uuid name-label=Other\ install\ media --minimal)

# From Xen Docs: Force an SR scan, syncing database with VDIs present in underlying storage substrate.
xe sr-scan uuid=$srUuid

# Label new sr VDIs to correct names
for vdiList in `cat $nameLabelFile`
	do 
		xe vdi-param-set uuid=`echo $vdiList | cut -d "," -f2` name-label=`echo $vdiList | cut -d "," -f1`
	done

# Create new shell VM's from generic template and attach VDB and Network VIF
for vmList in `cat $nameLabelFile`
	do	
		# Grab the VM's uuid after creation
		vmUuid=$(xe vm-install new-name-label=`echo $vmList | cut -d "," -f1` template=${templateUuid} sr-uuid=$srUuid)
		
		# Set vCPUs from 3rd CSV Field
		vmCpu=`echo $vmList | cut -d "," -f3`
		xe vm-param-set uuid=$vmUuid VCPUs-max=$vmCpu VCPUs-at-startup=$vmCpu

		# Set Memory from 4th CSV Field. Format example: 512MiB
		vmMem=`echo $vmList | cut -d "," -f4`
		xe vm-param-set uuid=$vmUuid memory-static-max=$vmMem memory-dynamic-max=$vmMem memory-dynamic-min=$vmMem memory-static-min=$vmMem

		# Set Boot Policy, the other-config key:pair is critical to allow the VM to boot normally
		xe vm-param-set uuid=$vmUuid HVM-boot-policy="" PV-bootloader="eliloader" HVM-boot-params:order other-config:install-round=2

		# Attach existing disk to VM's VBD
		xe vbd-create vm-uuid=$vmUuid vdi-uuid=`echo $vmList | cut -d "," -f2` device=0 bootable="true" type="Disk"

		# Add networking to the VM 
		# Network is take vlan from 5th CSV field, then determine the right network
		netUuid=$(xe network-list name-label="`echo $vmList | cut -d "," -f5`" --minimal)
		
		# Create and Attach Interface, if VM has an existing MAC, will need to remove it from /etc/sysconfing/network-scripts/ifcg-eth0 for example
		xe vif-create vm-uuid=$vmUuid network-uuid=$netUuid mac=random device=0

		# Start the VM
		xe vm-start uuid=$vmUuid
	done

