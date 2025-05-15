# health-checker

Check the state of a openSUSE MicroOS system after a reboot.


## How does this work?

`health-checker` will be called by a systemd service during the boot
process.

The `health-checker` script will call several plugins; each plugin is
responsible to check a special service or condition. To run the check, the
plugin is called with the option *check* (e.g.
`/usr/libexec/health-checker/tmp.sh check`). If this fails, the plugin will
exit with the return value `1`, else `0`. The `health-checker` script will call
all plugins inside `/usr/libexec/health-checker` and
`/usr/local/libexec/health-checker` directories; the former directory includes
plugins installed by system packages (and therefore coming through an RPM), the
latter includes plugins installed manually by the system admin. All services,
which should be checked by the plugins, needs to be listed in the 'After'
section, so that they are started before `health-checker`.

Its behavior depends if the system is using systemd-boot, grub2-bls or any
other bootloader following the Boot Loader Specification (BLS) or legacy.

### systemd-boot and grub2-bls

On systemd-boot and grub2-bls, when the BLS is followed, `health-checker`
assess the status of the system at the boot and act accordingly. It uses the
[Automatic Boot Assessment](https://systemd.io/AUTOMATIC_BOOT_ASSESSMENT/)
provided by systemd to check every new snapshot, to reboot a predetermined
amount of times, and then it lets the user access an emergency shell when
everything else fails.

Every new snapshot has a separate boot entry with a boot counter (according to
`/etc/kernel/tries`, which health-checker sets to 3 by default); when that
snapshot is booted for the first time, the bootloader will decrease the amount
of tries left. Then if health-checker succeed, systemd will call
`systemd-bless-boot`, which will mark the new snapshot as working. If instead
`health-checker` fails, the system will reboot into the next available
snapshot, performing a rollback at boot. The bootloader will order the snapshot
depending if they are new/working, leaving all the non working snapshots last
(so with a non 0 boots available left). If an entry that was working previously
is now broken, `health-checker` will try rebooting once before starting an
emergency shell.

### Legacy grub

If everything was fine, the script will create a
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
