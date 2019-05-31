Summary: A systemd timer unit example of port checker
Name:    port-health-checker
Version: 0.0.1
Release: 1%{?dist}
License: MIT
URL: https://github.com/ssato/port-health-check-systemd-timer-unit-example
Source0: %{url}/archive/RELEASE_%{version}.tar.gz
%{?systemd_requires}
BuildRequires: systemd

%description
A RPM package provides an example of systemd timer unit to check health of
given local port periodically.

%prep
%autosetup -n %{name}-%{version}

%build
%cmake .
%make_build

%install
%make_install

%post
#%systemd_post port-health-checker@.timer
#systemctl start port-health-checker@.timer

%preun
#%systemd_preun port-health-checker@.timer

%postun
#%systemd_postun_with_restart port-health-checker@.timer

%files
%doc README.rst
%license LICENSE.MIT
%{_unitdir}/*@.*
%config /etc/port-health-checker.d/*.conf
%{_mandir}/man*/*

%changelog
* Fri May 31 2019 Satoru SATOH <ssato@redhat.com> - 0.0.1-1
- Initial build.
