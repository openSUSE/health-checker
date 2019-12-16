#!/bin/sh

# if we enter emergency mode, do:
# - if it's not even possible to mount the root file system reboot and try to
#   recover using grub
# otherwise:
# - on first boot after update, rollback to old snapshot
# - if it is not the first boot, reboot
# - if reboot does not help, log this
#

HC_ROOT_MOUNT="/run/health-checker"
STATE_FILE="${HC_ROOT_MOUNT}/var/lib/misc/health-check.state"
REBOOTED_STATE="${HC_ROOT_MOUNT}/var/lib/misc/health-check.rebooted"

BTRFS_ID=0

set_btrfs_id()
{
    BTRFS_ID=`btrfs subvolume get-default "${HC_ROOT_MOUNT}" | awk '{print $2}'`
}

umount_and_reboot()
{
  if findmnt "${HC_ROOT_MOUNT}" > /dev/null; then
    umount --recursive "${HC_ROOT_MOUNT}"
  fi
  systemctl reboot --force
}

clear_and_reboot()
{
  # Try to clear the health_checker flag variable in GRUB environment variable
  # block
  echo "Clearing GRUB health_checker_flag"
  grub2-editenv - set health_checker_flag=0

  umount /run/health-checker
  systemctl reboot --force
}

try_grub_recovery()
{
  warn "Trying recovery via GRUB2 snapshot mechanism."
  umount_and_reboot
}

rollback()
{
    . ${STATE_FILE}
    btrfs subvolume set-default ${LAST_WORKING_BTRFS_ID} "${HC_ROOT_MOUNT}"
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
        clear_and_reboot
      fi
  elif [ ! -f ${REBOOTED_STATE} ]; then
      warn "Machine didn't come up correct, try a reboot"
      echo `date "+%Y-%m-%d %H:%M"` > ${REBOOTED_STATE}
      clear_and_reboot
  else
      warn "Machine didn't come up correct, start emergency shell"
      return 0
  fi
}


info "health checker emergency mode"

# Make sure we know root device
[ -z "$root" ] && root=$(getarg root=)

if getargbool 1 rd.shell -d -y rdshell || getarg rd.break -d rdbreak; then
  true # manual invocation of emergency shell, doing nothing
elif [ -n "$root" -a -z "${root%%block:*}" ]; then

  info "root device: ${root}"

  local my_root="${root#block:}"

  info "my_root device: ${my_root}"

  test -e "${my_root}" || return

  info "my_root device exist"

  # Try to mount health-checker data
  mkdir -p "${HC_ROOT_MOUNT}"
  if mount "${my_root}" "${HC_ROOT_MOUNT}"; then
    info "my_root mounted successfully"
    state_dev_cands=("/var/lib/misc" "/var")
    for cand in "${state_dev_cands[@]}"; do
      findmnt --first-only --direction backward --noheadings --tab-file "${HC_ROOT_MOUNT}/etc/fstab" "${cand}" | while read _m _d _t _o; do
        mkdir -p "${HC_ROOT_MOUNT}/${cand}"
        mount -t ${_t} -o ${_o} ${_d} "${HC_ROOT_MOUNT}/${cand}"
      done
    done
  fi

  # Try to recover somehow
  if [ -e "${HC_ROOT_MOUNT}/var/lib/misc" ]; then
    error_decission
    umount --recursive "${HC_ROOT_MOUNT}" ||:
  else
    warn "Mounting health-checker data failed."
    try_grub_recovery
  fi
else
  warn "No root device found."
  try_grub_recovery
fi
