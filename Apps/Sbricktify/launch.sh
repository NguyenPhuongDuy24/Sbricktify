#!/bin/sh
# Spotifast Brick Speaker: UI controller + supervised librespot receiver.
# The receiver is the sole ALSA owner. This script never changes firmware.
set -u

appdir=$(CDPATH= cd "$(dirname "$0")" && pwd) || exit 1
cd "$appdir" || exit 1
umask 077
mkdir -p logs data/receiver run || exit 1

launcher_log="$appdir/logs/launcher.log"
receiver_log="$appdir/logs/receiver.log"
ui_log="$appdir/logs/spotifast-ui.log"
status_file="$appdir/run/receiver.status"
lock_dir="$appdir/run/instance.lock"
receiver_pid_file="$appdir/run/receiver.pid"
ui_pid_file="$appdir/run/ui.pid"

log() {
    printf '%s component=launcher state=%s\n' "$(date -u '+%Y-%m-%dT%H:%M:%SZ')" "$1" >> "$launcher_log"
}
fail() {
    log "ERROR reason=$1"
    printf 'ERROR\n' > "$status_file"
    exit 1
}

if [ "$(uname -m)" != aarch64 ]; then
    fail aarch64-required
fi
if [ ! -d /usr/trimui ]; then
    fail trimui-runtime-missing
fi
if [ ! -x "$appdir/bin/trimui-receiver" ] || [ ! -x "$appdir/bin/spotifast-sdl2" ]; then
    fail binary-missing-or-not-executable
fi

# A PID file is trusted only after both liveness and the exact binary path are
# checked. No broad process-name matching is used.
known_pid=
if [ -r "$receiver_pid_file" ]; then
    known_pid=$(cat "$receiver_pid_file" 2>/dev/null || true)
fi
if [ -n "$known_pid" ] && kill -0 "$known_pid" 2>/dev/null; then
    if [ -r "/proc/$known_pid/cmdline" ] && tr '\000' ' ' < "/proc/$known_pid/cmdline" 2>/dev/null | grep -F "$appdir/bin/trimui-receiver" >/dev/null 2>&1; then
        fail receiver-already-running
    fi
fi
rm -f "$receiver_pid_file" "$ui_pid_file"

if ! mkdir "$lock_dir" 2>/dev/null; then
    # Only remove a stale lock directory from this exact app path.
    stale_pid=
    [ -r "$lock_dir/launcher.pid" ] && stale_pid=$(cat "$lock_dir/launcher.pid" 2>/dev/null || true)
    if [ -n "$stale_pid" ] && kill -0 "$stale_pid" 2>/dev/null; then
        fail app-already-running
    fi
    [ -d "$lock_dir" ] && [ ! -L "$lock_dir" ] || fail lock-invalid
    rm -rf "$lock_dir" || fail stale-lock-remove
    mkdir "$lock_dir" || fail lock-create
fi
printf '%s\n' "$$" > "$lock_dir/launcher.pid"

receiver_pid=
ui_pid=
stop_receiver() {
    if [ -n "$receiver_pid" ] && kill -0 "$receiver_pid" 2>/dev/null; then
        log "RECEIVER_STOP_REQUEST pid=$receiver_pid"
        kill -TERM "$receiver_pid" 2>/dev/null || true
        n=0
        while kill -0 "$receiver_pid" 2>/dev/null && [ "$n" -lt 5 ]; do
            sleep 1
            n=$((n + 1))
        done
        if kill -0 "$receiver_pid" 2>/dev/null; then
            log "RECEIVER_STOP_TIMEOUT pid=$receiver_pid"
            kill -KILL "$receiver_pid" 2>/dev/null || true
        fi
    fi
}
cleanup() {
    trap - EXIT TERM INT HUP
    log SHUTDOWN_START
    if [ -n "$ui_pid" ] && kill -0 "$ui_pid" 2>/dev/null; then
        kill -TERM "$ui_pid" 2>/dev/null || true
    fi
    stop_receiver
    rm -f "$receiver_pid_file" "$ui_pid_file" "$lock_dir/launcher.pid"
    rmdir "$lock_dir" 2>/dev/null || true
    log APP_EXIT
}
on_signal() {
  cleanup
  exit 128
}

trap cleanup EXIT
trap on_signal TERM INT HUP

export LD_LIBRARY_PATH="${LD_LIBRARY_PATH:+$LD_LIBRARY_PATH:}/usr/trimui/lib:/usr/lib:/lib"
export SDL_VIDEODRIVER="${SDL_VIDEODRIVER:-mali}"
# The UI has no sound path; reserve ALSA exclusively for trimui-receiver.
export SDL_AUDIODRIVER=dummy
export SPOTIFAST_DATA_DIR="$appdir/data/ui"
export SPOTIFAST_TIMEOUT="${SPOTIFAST_TIMEOUT:-900}"
# QR OAuth is independent from the receiver and never grants it playback
# credentials. The Brick hosts a short-lived LAN pairing page itself. It does
# not use the legacy public HTTPS relay, a PC relay, or a browser on the Brick.
export SPOTIFAST_LOCAL_QR="${SPOTIFAST_LOCAL_QR:-1}"
export SPOTIFAST_AUTH_PC_RELAY="${SPOTIFAST_AUTH_PC_RELAY:-0}"
export SPOTIFAST_QR_RELAY_CONFIG="${SPOTIFAST_QR_RELAY_CONFIG:-$appdir/config/qr-relay.json}"
export SPOTIFAST_EXTERNAL_RECEIVER_ID="d4d27bb9986a078af8b7e9b5ce6ea4715fd515b6"
export SPOTIFAST_EXTERNAL_RECEIVER_NAME="TrimUI Brick Speaker"
export SPOTIFAST_RECEIVER_STATUS_FILE="$status_file"

printf 'RECEIVER_START_REQUEST\n' > "$status_file"
log APP_START
log RECEIVER_START_REQUEST
/lib/ld-linux-aarch64.so.1 "$appdir/bin/trimui-receiver" \
    --receiver-name 'TrimUI Brick Speaker' \
    --vault "$appdir/data/receiver/credentials.vault" \
    --status-file "$status_file" \
    >> "$receiver_log" 2>&1 &
receiver_pid=$!
printf '%s\n' "$receiver_pid" > "$receiver_pid_file"
log "RECEIVER_PROCESS_STARTED pid=$receiver_pid"

# Detect an immediate loader/port failure but leave the UI responsive so it can
# report the status and preserve normal logout/exit behavior.
sleep 1
if ! kill -0 "$receiver_pid" 2>/dev/null; then
    printf 'ERROR\n' > "$status_file"
    log RECEIVER_PROCESS_EXIT_EARLY
fi

log UI_START
/lib/ld-linux-aarch64.so.1 "$appdir/bin/spotifast-sdl2" >> "$ui_log" 2>&1 &
ui_pid=$!
printf '%s\n' "$ui_pid" > "$ui_pid_file"
if wait "$ui_pid"; then
    ui_status=0
else
    ui_status=$?
fi
ui_pid=
log "UI_EXIT code=$ui_status"
exit "$ui_status"
