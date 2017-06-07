#!/bin/bash
# This script will gather the Name, CPU, Memory, Networks, OS and Disk(s) # and Size
# If you get a <not in database>, it is more than likely xentools are not installed on that instance
#
for i in $(xe vm-list params=uuid | grep uuid | awk '{ gsub (" ", "", $0); print}' | cut -d ":" -f2)
do
	echo "Name:" $(xe vm-param-get uuid=$i param-name=name-label)
	echo "CPUs:" $(xe vm-param-get uuid=$i param-name=VCPUs-max)
	echo "Memory:" $(xe vm-param-get uuid=$i param-name=memory-static-max)
	echo "Networks:" $(xe vm-param-get uuid=$i param-name=networks)
	echo "OS:" $(xe vm-param-get uuid=$i param-name=os-version)

	diskNum=0
	for x in $(xe vbd-list vm-uuid=$i params=vdi-uuid | grep vdi-uuid | awk '{ gsub (" ", "", $0); print}' | cut -d ":" -f2)
		do
			echo "Disk" $diskNum "Size in bytes:" $(xe vdi-param-get param-name=virtual-size uuid=$x)
			diskNum=$(expr $diskNum + 1)
		done
	echo " "
done

