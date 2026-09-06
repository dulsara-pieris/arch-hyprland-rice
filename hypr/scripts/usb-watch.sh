#!/usr/bin/env bash

set -u

notify() {
    notify-send \
        --app-name="USB Watch" \
        --icon="drive-removable-media" \
        "$1" \
        "$2"
}

udevadm monitor \
    --udev \
    --property \
    --subsystem-match=usb/usb_device |
while IFS= read -r line; do
    [[ "$line" == ACTION=add ]] || [[ "$line" == ACTION=remove ]] || continue

    action="${line#ACTION=}"

    vendor=""
    model=""
    serial=""
    product=""

    # Read the rest of this udev event.
    while IFS= read -r property; do
        [[ -z "$property" ]] && break

        case "$property" in
            ID_VENDOR=*)
                vendor="${property#ID_VENDOR=}"
                ;;
            ID_MODEL=*)
                model="${property#ID_MODEL=}"
                ;;
            ID_SERIAL_SHORT=*)
                serial="${property#ID_SERIAL_SHORT=}"
                ;;
            PRODUCT=*)
                product="${property#PRODUCT=}"
                ;;
        esac
    done

    if [[ -n "$model" && -n "$vendor" ]]; then
        name="$vendor $model"
    elif [[ -n "$model" ]]; then
        name="$model"
    elif [[ -n "$vendor" ]]; then
        name="$vendor"
    elif [[ -n "$product" ]]; then
        name="$product"
    else
        name="Unknown USB device"
    fi

    if [[ "$action" == "add" ]]; then
        notify "USB device connected" "$name"
    else
        notify "USB device disconnected" "$name"
    fi
done