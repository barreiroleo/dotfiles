#!/data/data/com.termux/files/usr/bin/bash
set -euo pipefail

USER_NAME="leonardo"
DISTRO="archlinux"
DISPLAY_NUM=":0"
MODE="${1:-tmux}"

# X11, PulseAudio, I3 lifting
## Kill existing Termux:X11 server processes
pkill -f "com.termux.x11" 2>/dev/null || true
pkill -f "termux.x11"     2>/dev/null || true
## Start PulseAudio over TCP (best-effort; don't fail if already running)
pulseaudio --start \
  --load="module-native-protocol-tcp auth-ip-acl=127.0.0.1 auth-anonymous=1" \
  --exit-idle-time=-1 2>/dev/null || true
## Start Termux:X11 server
export XDG_RUNTIME_DIR="${TMPDIR}"
termux-x11 "${DISPLAY_NUM}" >/dev/null 2>&1 &
sleep 2
## Launch Termux:X11 Android activity
if [[ ${MODE} == "i3" ]]; then
    am start --user 0 -n com.termux.x11/com.termux.x11.MainActivity >/dev/null 2>&1
fi
sleep 1

proot-distro login --shared-tmp --no-arch-warning \
  --user "${USER_NAME}" \
  --bind "${HOME}/storage:/mnt/host" \
  --bind "${HOME}:/mnt/termux" \
  "${DISTRO}" -- /bin/bash -lc '
    set -euo pipefail

    # Ensure shared-tmp dirs exist (best effort; perms may vary in proot)
    mkdir -p /tmp/.ICE-unix /tmp/.X11-unix
    chmod 1777 /tmp/.ICE-unix /tmp/.X11-unix || true

    export DISPLAY='${DISPLAY_NUM}'
    export PULSE_SERVER=127.0.0.1

    mkdir -p /tmp/xdg-runtime-$UID
    chmod 700 /tmp/xdg-runtime-$UID
    export XDG_RUNTIME_DIR=/tmp/xdg-runtime-$UID
    export ICEAUTHORITY=$XDG_RUNTIME_DIR/ICEauthority

    case "'"${MODE}"'" in
      tmux)
        exec tmux
        ;;
      i3)
        exec dbus-run-session -- i3
        ;;
      *)
        echo "Usage: launcher.sh [tmux|i3]" >&2
        exit 2
        ;;
    esac
  '
