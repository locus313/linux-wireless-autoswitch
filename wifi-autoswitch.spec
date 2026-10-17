Name:           wifi-autoswitch
Version:        0.1.0
Release:        1%{?dist}
Summary:        Turn Wi-Fi off when Ethernet is connected (NetworkManager dispatcher)
License:        MIT
URL:            https://github.com/locus313/linux-wireless-autoswitch
Source0:        %{url}/archive/v%{version}/linux-wireless-autoswitch-%{version}.tar.gz
BuildArch:      noarch
Requires:       NetworkManager
Requires:       util-linux

%description
A NetworkManager dispatcher script that turns the Wi-Fi radio off when a wired
Ethernet connection is up and back on when it drops. Auto-switching can be
paused by creating /etc/wifi-autoswitch.disabled.

%prep
%autosetup -n linux-wireless-autoswitch-%{version}

%install
install -D -m 755 70-wifi-autoswitch %{buildroot}%{_sysconfdir}/NetworkManager/dispatcher.d/70-wifi-autoswitch

%files
%license LICENSE
%doc README.md CHANGELOG.md
%{_sysconfdir}/NetworkManager/dispatcher.d/70-wifi-autoswitch

%changelog
* Fri Oct 16 2026 locus313 - 0.1.0-1
- Initial package
