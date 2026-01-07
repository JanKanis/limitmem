function jcusage
	set -l valid_cgroups
	for g in $JCLIMITMEM
		set -l name (string split -f1 : $g)
		set -l cgroup (string split -f2 -m1 : $g)

		# Expand full path and wildcard if the cgroup contains a wildcard
		set -l c (fish -c "echo /sys/fs/cgroup$cgroup; or echo ''" 2>/dev/null)

		if ! [ -d $c ]
			continue
		end
		if ! contains $name:$cgroup $valid_cgroups
			set valid_cgroups $valid_cgroups $name:$cgroup
		end

		set -l limit (cat $c/memory.max)
		#set -l max (cat "$c/memory.peak")
		set -l curr (cat "$c/memory.current")
		set -l failcnt (string split -f2 \  (grep oom\  "$c/memory.events"))

		#set -l maxp (math "floor ($max * 100 / $limit)")
		set -l currp (math "floor ($curr * 100 / $limit)")
		set -l GB 1073741824
		set -l limitgb (math "floor ($limit / $GB)")
		set -l limitgbfrac (math "floor (($limit - $limitgb*$GB) * 100 / $GB)")
		#set -l maxgb (math "floor ($max / $GB)")
		#set -l maxgbfrac (math "floor (($max - $maxgb*$GB) * 100 / $GB)")
		set -l currgb (math "floor ($curr / $GB)")
		set -l currgbfrac (math "floor (($curr - $currgb*$GB) * 100 / $GB)")

		echo $name:
		printf "limit:     %12d %9s.%02d GB)\n" $limit "($limitgb" $limitgbfrac
		#printf "max usage: %12d %5s, %2d.%02d GB)\n" $max "($maxp%" $maxgb $maxgbfrac
		printf "usage:     %12d %5s, %2d.%02d GB)\n" $curr "($currp%" $currgb $currgbfrac
		printf "failcount: %12d\n" $failcnt
		echo
	end
	set JCLIMITMEM $valid_cgroups
end
