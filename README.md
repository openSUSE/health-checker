# health-checker
Check the state of a CaaSP worker after an update. If something is not
Ok, do a rollback to the state before. If the system is not Ok, but did
boot correctly before and no update was made, try a reboot again. If this
does not help, too, disable all CaaSP services and wait and inform 
administrator.
