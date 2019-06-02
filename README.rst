=====================
port-health-checker
=====================

This is a simple example of systemd timer unit implementation named
port-health-checker to monitor and check health of specified network ports on
localhost primarily, distributed under MIT license.

There is no warranty for the program and not intended for use especially in
production environment and use this package at your own risk.

How to build & install
==========================

Requirements
---------------

- Build time: cmake and so on. See also pkg/package.spec.in.
- Runtime: systemd, nc (nmap-ncat)

Build
-------

#. (mkdir build && cd build && cmake ..)
#. make -C build dist
#. (cd build; buildsrpm -w . package.spec)
#. mock build/\*.src.rpm

Install
--------

Install built RPM.

.. vim:sw=2:ts=2:et:
