# health-checker

Check the state of a openSUSE MicroOS system after a reboot.


## How does this work?

`health-checker` will be called by a systemd service during the boot
process.

The `health-checker` script will call several plugins. Every plugin is
responsible to check a special service or condition. All services, which
should be checked by the plugin, needs to be listed in the 'After' section.
To run the check the plugin is called with the option *check*. If this fails,
the plugin will exit with the return value `1`, else `0`.
If everyting was fine, the script will create a
`/var/lib/misc/health-check.state` file with the number of the current,
working btrfs subvolume with the root filesystem.
If a plugin reports an error condition, the `health-checker` script will take
following actions:

1. If the current btrfs root subvolume is not identical with the last known
   working snapshot, an automatic rollback to that snapshot is made. Normally,
   if the current btrfs subvolume is not identical to the last working one,
   this means an update was made, and this update did never boot correctly.
2. If the current btrfs subvolume did already boot successful in the past, the
   problem is most likely a temporary problem. In this case, we try to reboot
   the machine again. `/var/lib/misc/health-check.rebooted` will be created
   with the current time.
3. If the current btrfs snapshot did already boot successful in the past and
   if we did try already to solve the problem with a reboot, it doesn't make
   sense to reboot again. To give the admin the chance and possibility to fix
   the problem, all plugins will be called with the option *stop*. At the
   end, the machine should still run, so that an admin can login, but no
   service should run, so that nothing can break.
