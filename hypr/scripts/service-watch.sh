#!/usr/bin/env bash

declare -A LAST_STATE

get_services() {
        systemctl list-units \
                --type=service \
                --all \
                --no-legend \
                --plain |
                awk '{print $1}'
}

# Initial state
while read -r service; do
        [[ -z "$service" ]] && continue
        LAST_STATE["$service"]="$(systemctl is-active "$service" 2>/dev/null || true)"
done < <(get_services)

while true; do
        while read -r service; do
                [[ -z "$service" ]] && continue

                state="$(systemctl is-active "$service" 2>/dev/null || true)"
                old="${LAST_STATE[$service]}"

                # New service appeared
                if [[ -z "${LAST_STATE[$service]+x}" ]]; then
                        LAST_STATE["$service"]="$state"
                        continue
                fi

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

                                *)
                                        notify-send \
                                                -u normal \
                                                "⚪ Service state changed" \
                                                "$service → $state"
                                        ;;
                        esac

                        LAST_STATE["$service"]="$state"
                fi

        done < <(get_services)

        sleep 5
done