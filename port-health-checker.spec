Summary: A systemd timer unit example of port checker
Name:    port-check-systemd-timer-unit-example
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
%configure
make

%install
make install DESTDIR=%{buildroot}

%post
%systemd_post port-check.timer
systemctl start port-check.timer

%preun
%systemd_preun port-check.timer

%postun
%systemd_postun_with_restart port-check.timer

%files
%doc README.rst
%license LICENSE.MIT
%{_unitdir}/*.service
%{_unitdir}/*.timer
%config /etc/port-health-checker.d/*.conf
%{_mandir}/man*/*

%changelog
* Tue May 28 2019 Satoru SATOH <ssato@redhat.com> - 0.0.1-1
- Initial build.
