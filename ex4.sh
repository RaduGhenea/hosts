#!/bin/bash

verify-IP() {
	hostname=$1
	[ -n "$hostname" ] || return 1
	hosts_ip=`cat $HOME/etc/hosts | grep "$hostname" | awk '/ / {print $1}'`
	ns_ip=`nslookup $hostname | awk '/Address: / {print $2}'`
	# echo $hostname $hosts_ip $ns_ip
	[ -n "$hosts_ip" -o -n "$ns_ip" ] || return 1
	if [ "$hosts_ip" != "$ns_ip" ]; then
		echo "Bogus ip for $hostname in \$HOME/etc/hosts!"
	fi
	[ "$hosts_ip" = "$ns_ip" ]
	return $?
}

cat $HOME/etc/hosts | grep -v "^#" | while read addr name second rest; do
	verify-IP $name
done
