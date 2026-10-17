# linux-wireless-autoswitch

Automatically turns Wi-Fi off when a wired Ethernet connection is up, and back on when it drops. Linux counterpart of [macos-wireless-autoswitch](https://github.com/locus313/macos-wireless-autoswitch).

Uses a NetworkManager dispatcher script, so it is event-driven with no polling. Tested target: Fedora 44.

## Install

```bash
./install.sh i    # install
./install.sh up   # update
./install.sh ui   # uninstall
```

The script is installed to `/etc/NetworkManager/dispatcher.d/70-wifi-autoswitch`.

## Disable temporarily

```bash
sudo touch /etc/wifi-autoswitch.disabled   # pause auto-switching
sudo rm /etc/wifi-autoswitch.disabled      # resume
```

While the file exists, the script leaves the Wi-Fi radio alone.

## Logs

```bash
journalctl -t wifi-autoswitch -f
```

## Notes

- Any NetworkManager device of type `ethernet` counts (USB and Thunderbolt adapters included); bridges, VPNs and virtual devices do not.
- If Wi-Fi is turned on manually while docked, the next network event turns it off again (unless auto-switching is disabled, see above).
- On SELinux denials, check `sudo ausearch -m avc -ts recent`.

## License

MIT
