#!/usr/bin/env bash

SERVICES=(
        "docker.service"
        "NetworkManager.service"
        "bluetooth.service"
        "sshd.service"
        "usb-watch.service"
)

declare -A LAST_STATE

for service in "${SERVICES[@]}"; do
        LAST_STATE["$service"]="$(systemctl is-active "$service" 2>/dev/null || true)"
done

while true; do
        for service in "${SERVICES[@]}"; do
                state="$(systemctl is-active "$service" 2>/dev/null || true)"
                old="${LAST_STATE[$service]}"

                if [[ "$state" != "$old" ]]; then
                        case "$state" in
                                active)
                                        notify-send \
                                                -u normal \
                                                "🟢 Service recovered" \
                                                "$service is running again."
                                        ;;

                                failed)
                                        notify-send \
                                                -u critical \
                                                "🔴 Service failed" \
                                                "$service entered a failed state."
                                        ;;

                                inactive)
                                        notify-send \
                                                -u normal \
                                                "🟡 Service stopped" \
                                                "$service is no longer running."
                                        ;;
                        esac

                        LAST_STATE["$service"]="$state"
                fi
        done

        sleep 5
done