#!/bin/bash
echo "Adding local dom0 auth and standard users and groups to xenserver"
xe pool-enable-external-auth auth-type=PAM service-name=genesys
xe subject-role-add role-name=pool-admin uuid=$(xe subject-add subject-name=ops_admins)
xe subject-role-add role-name=pool-admin uuid=$(xe subject-add subject-name=xenorch)
xe subject-role-add role-name=pool-admin uuid=$(xe subject-add subject-name=XenPoolAdmin) 
xe subject-role-add role-name=pool-operator uuid=$(xe subject-add subject-name=XenPoolOperator)
xe subject-role-add role-name=vm-power-admin uuid=$(xe subject-add subject-name=XenVMPowerAdmin)
