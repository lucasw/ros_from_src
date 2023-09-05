#
# Regular cron jobs for the rosone package.
#
0 4	* * *	root	[ -x /usr/bin/rosone_maintenance ] && /usr/bin/rosone_maintenance
