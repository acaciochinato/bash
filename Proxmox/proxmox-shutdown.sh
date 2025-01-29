#!/bin/bash
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# Description:
#	This is a simple script to gracefully shutdown a Proxmox instance by first shutting down any running virtual machines in reverse order.

VM=("$(qm list | awk '{ print $1 }' | grep -v VMID)") 
STATUS=("$(qm list | awk '{ print $3 }' | grep -v STATUS)")
RC=0

for IDS in $(seq "$(("${#VM[@]}" - 1))" -1 0); do
	if [[ ${STATUS[IDS]} == "stopped" ]]; then
		echo "VM ${VM[IDS]} already stopped, continue..."
		continue
	else	
		echo "Shuting down VM ${VM[IDS]}" && qm shutdown "${VM[IDS]}" 
		RC=$?
		if [[ $RC != 0 ]]; then
			echo " Return:$RC There were some problems."
			sleep 1
		fi
	fi
done

STATUS_COUNT="$( qm list | awk '{ print $3 }' | grep -v STATUS | grep -c "running" )"

if [[ "$STATUS_COUNT" -eq 0  ]]; then
	echo "All VMs stopped, shutting down proxmox..." && shutdown -P now
else
	echo "$STATUS_COUNT not stopped, need assistance." && exit 1
fi