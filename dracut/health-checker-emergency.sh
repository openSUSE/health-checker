#!/bin/sh

# if we enter emergency mode, do:
# - on first boot after update, rollback to old snapshot
# - if it is not the first boot, reboot
# - if reboot does not help, log this
#

STATE_FILE=/run/health-checker/health-check.state
REBOOTED_STATE=/run/health-checker/health-check.rebooted

BTRFS_ID=0

set_btrfs_id()
{
    BTRFS_ID=`btrfs subvolume get-default ${NEWROOT} | awk '{print $2}'`
}

rollback()
{
    . ${STATE_FILE}
    btrfs subvolume set-default ${LAST_WORKING_BTRFS_ID} ${NEWROOT}/.snapshots
    if [ $? -ne 0 ]; then
        warn "ERROR: btrfs set-default $BTRFS_ID failed!"
        return 1
    fi
}

error_decission()
{
    if [ ! -f ${STATE_FILE} ]; then
        # No state file, no successfull boot, start emergency shell
	info "No successfull boot before"
        return 0
    fi

  . ${STATE_FILE}

  set_btrfs_id

  if [ ${LAST_WORKING_BTRFS_ID} -ne ${BTRFS_ID} ]; then
      warn "Machine didn't come up correct, do a rollback"
      rollback
      if [ $? -eq 0 ]; then
        umount /run/health-checker
        emergency_shell --shutdown reboot
      fi
  elif [ ! -f ${REBOOTED_STATE} ]; then
      warn "Machine didn't come up correct, try a reboot"
      echo `date "+%Y-%m-%d %H:%M"` > ${REBOOTED_STATE}
      umount /run/health-checker
      emergency_shell --shutdown reboot
  else
      warn "Machine didn't come up correct, start emergency shell"
      return 0
  fi
}


info "health checker emergency mode"

# Make sure we know root device
[ -z "$root" ] && root=$(getarg root=)

if [ -n "$root" -a -z "${root%%block:*}" ]; then

  info "root device: ${root}"

  local my_root="${root#block:}"

  info "my_root device: ${my_root}"

  test -e "${my_root}" || return

  info "my_root device exist"

  mkdir -p /run/health-checker
  mount -t btrfs -o subvol=@/var/lib/misc "${my_root}" /run/health-checker
  if [ $? -ne 0 ]; then
    warn "Failed: mount -t btrfs -o subvol=@/var/lib/misc "${my_root}" /run/health-checker"
  else
    error_decission
    umount /run/health-checker ||:
  fi
fi
