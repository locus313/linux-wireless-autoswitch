# TODO

- [x] Install and test on Fedora 44: `./install.sh i`, then plug/unplug Ethernet and watch `journalctl -t wifi-autoswitch -f`
- [x] Check for SELinux denials: `sudo ausearch -m avc -ts recent`
- [x] Add BATS tests that mock `nmcli` (install with `sudo dnf install bats`)
- [x] Add shellcheck lint (`sudo dnf install ShellCheck`)
- [x] Add GitHub Actions CI (shellcheck + BATS)
- [x] Add CHANGELOG.md
- [x] Add drift check: installed path in `install.sh` matches README
- [x] Decide on a manual override (e.g. a flag file to disable auto-switching)
- [x] Consider handling dispatcher `hostname`/`dhcp4-change` events (not needed: plug/unplug tested on Fedora 44 with no missed cases)
- [x] Package as an RPM (`wifi-autoswitch.spec`)
- [ ] Publish to COPR (spec and `v0.1.0` tag are ready)
