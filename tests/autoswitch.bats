#!/usr/bin/env bats

setup() {
  ROOT="$BATS_TEST_DIRNAME/.."
  MOCK_DIR="$BATS_TEST_TMPDIR/bin"
  CALLS="$BATS_TEST_TMPDIR/calls"
  mkdir -p "$MOCK_DIR"
  : >"$CALLS"

  cat >"$MOCK_DIR/nmcli" <<EOF
#!/usr/bin/env bash
if [[ "\$1" == "-t" ]]; then
  printf '%s\n' "\$MOCK_DEVICES"
else
  echo "nmcli \$*" >>"$CALLS"
fi
EOF
  cat >"$MOCK_DIR/logger" <<EOF
#!/usr/bin/env bash
echo "logger \$*" >>"$CALLS"
EOF
  chmod +x "$MOCK_DIR/nmcli" "$MOCK_DIR/logger"
  export PATH="$MOCK_DIR:$PATH"
}

run_script() {
  run "$ROOT/70-wifi-autoswitch" "$@"
}

@test "ethernet connected turns wifi off" {
  MOCK_DEVICES=$'ethernet:connected\nwifi:connected' run_script eth0 up
  [ "$status" -eq 0 ]
  grep -q "nmcli radio wifi off" "$CALLS"
}

@test "ethernet disconnected turns wifi on" {
  MOCK_DEVICES=$'ethernet:unavailable\nwifi:disconnected' run_script eth0 down
  [ "$status" -eq 0 ]
  grep -q "nmcli radio wifi on" "$CALLS"
}

@test "connectivity-change is handled" {
  MOCK_DEVICES='ethernet:connected' run_script eth0 connectivity-change
  grep -q "nmcli radio wifi off" "$CALLS"
}

@test "unrelated events are ignored" {
  MOCK_DEVICES='ethernet:connected' run_script eth0 pre-up
  [ "$status" -eq 0 ]
  [ ! -s "$CALLS" ]
}

@test "disable file stops all switching" {
  touch "$BATS_TEST_TMPDIR/off"
  WIFI_AUTOSWITCH_DISABLE_FILE="$BATS_TEST_TMPDIR/off" MOCK_DEVICES='ethernet:connected' run_script eth0 up
  [ "$status" -eq 0 ]
  [ ! -s "$CALLS" ]
}

@test "install path in install.sh matches README" {
  dest=$(sed -n 's/^DEST="\(.*\)"$/\1/p' "$ROOT/install.sh" | sed 's/\${SCRIPT_NAME}/70-wifi-autoswitch/')
  grep -qF "$dest" "$ROOT/README.md"
}
