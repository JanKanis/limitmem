Limitmem
========

This is a small Linux command line utility to limit memory usage of a command. It uses the fish shell, systemd and cgroups to do this. When the memory limit is reached information on that is printed to stdout so you can keep track of what is going on. It also supports programs that run as snaps.

There is an additional command to get a list of all running limitmem instances and their memory usages.

This script uses Fish shell's universal variables to keep track of running instances, and is meant to be used from the fish shell.


Limitations
-----------

Especially when running a snap, there are some limitations and race conditions where limitmem may not be able to find the right cgroup, or may hang after the target program exits. So far these are usually not a problem for me, but improvements are welcome.

This program started out as a shell script, which it still is, but it would be better to reimplement it in a proper programming language like Python.
