#
# Copyright (c) 2017 Thorsten Kukuk <kukuk@suse.de>
#

plugindir = ${libexecdir}/health-checker

plugin_SCRIPTS = health-check-tester.sh etcd.sh etc-overlayfs.sh \
	rebootmgr.sh btrfs-subvolumes-mounted.sh crio.sh kubelet.sh

EXTRA_DIST = template.sh ${SCRIPTS}
