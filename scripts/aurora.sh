#!/usr/bin/env bash
# Aurora Forecast Monitor Script - NOAA Aurora Dashboard

# URLs
forecasturl="https://services.swpc.noaa.gov/text/3-day-geomag-forecast.txt"
viewlineurl="https://services.swpc.noaa.gov/experimental/images/aurora_dashboard/tonights_static_viewline_forecast.png"
latesturl="https://services.swpc.noaa.gov/images/animations/ovation/north/latest.jpg"
kurl="https://services.swpc.noaa.gov/images/station-k-index.png"

# Cache directory
cachedir="$HOME/.cache/aurora"
mkdir -p "$cachedir"

# Files
forecast="$cachedir/aurora.txt"
viewline="$cachedir/aurora.png"
latest="$cachedir/aurora_latest.jpg"
kindex="$cachedir/aurora_kindex.png"
combo="$cachedir/aurora_full.png"

# Thresholds
threshold=3.0
critical=6.0

# Get Kp value from forecast file
get_kp_value() {
    [[ ! -f "$forecast" ]] && echo "0" && return 1
    awk '{a[NR]=$3; b=$2} END {
        if (NR == 0) {print "0"; exit}
        val=b
        for (i=NR-7; i<=NR-4; i++)
            if (i in a && a[i] > val) val=a[i]
        print val
    }' "$forecast"
}

# Display in status bar format (JSON for waybar)
tobar() {
    local value=$(get_kp_value)

    if [[ -z "$value" ]] || [[ "$value" == "0" ]]; then
        printf '{"text": "🌌", "class": "unavailable", "tooltip": "No data"}\n'
        return
    fi

    local text="🌌"
    local class="normal"
    local tooltip="Kp Index: $(printf '%.1f' "$value")"

    if (( $(echo "$value > $critical" | bc -l 2>/dev/null) )); then
        text="🌌$(printf '%.0f' "$value")"
        class="critical"
        tooltip="🌌 CRITICAL Aurora Activity! Kp: $(printf '%.1f' "$value")"
    elif (( $(echo "$value > $threshold" | bc -l 2>/dev/null) )); then
        text="🌌$(printf '%.0f' "$value")"
        class="warning"
        tooltip="🌌 Aurora likely visible! Kp: $(printf '%.1f' "$value")"
    fi

    # Output JSON for waybar
    printf '{"text": "%s", "class": "%s", "tooltip": "%s"}\n' "$text" "$class" "$tooltip"
}

# Display raw forecast data
data() {
    if [[ -f "$forecast" ]]; then
        cat "$forecast"
    else
        echo "No forecast data. Run: $0 u"
    fi
}

# View images with sxiv
images() {
    if command -v sxiv &>/dev/null; then
        if [[ -f "$viewline" && -f "$latest" && -f "$kindex" ]]; then
            sxiv -i "$viewline" "$latest" "$kindex" 2>&1 | grep -v "MIT-SCREEN-SAVER" &
        else
            notify-send "Aurora" "Images not available. Run: $0 u"
        fi
    else
        notify-send "Aurora" "sxiv not installed"
    fi
}

# Update all aurora data
update() {
    echo "Updating aurora data..."
    # Download files
    if curl -sfo "$forecast" "$forecasturl" 2>/dev/null && echo "Fetched forecast" && \
       curl -sfo "$latest" "$latesturl" 2>/dev/null && echo "Fetched latest" && \
       curl -sfo "$viewline" "$viewlineurl" 2>/dev/null && echo "Fetched viewline" && \
       curl -sfo "$kindex" "$kurl" 2>/dev/null && echo "Fetched K-index"; then

        # Create composite image if ImageMagick is available
        if command -v magick &>/dev/null; then
            magick \( "$latest" "$viewline" +append \) "$kindex" -append -resize 512x512 "$combo" 2>/dev/null
            echo "Created composite dashboard"
        fi

        # Get forecast data for notification
        local table_data=$(tail -n 13 "$forecast")
        local icon="$viewline"
        [[ -f "$combo" ]] && icon="$combo"

        # Send notification
        notify-send -t 30000 -u low -i "$icon" "🌌 Aurora Forecast Updated" "<span font_family='monospace'>$table_data</span>"
        echo "Update complete"
    else
        echo "Update failed"
        notify-send -u critical "Aurora Update Failed" "Check internet connection"
        return 1
    fi
}

# Show help
show_help() {
    cat << 'EOF'
Aurora Forecast Script for Waybar

Usage: $0 [COMMAND]

Commands:
    u, update      Download latest aurora forecast data
    i, images      View downloaded aurora images
    d, data        Display raw forecast data
    t, tobar       Show status bar format (JSON for waybar)
    h, help        Show this help message

Setup for Waybar:
1. Add to ~/.config/waybar/config.jsonc:
"custom/aurora": {
    "exec": "/path/to/aurora.sh",
    "return-type": "json",
    "interval": 300,
    "on-click": "/path/to/aurora.sh i",
    "on-click-middle": "/path/to/aurora.sh u",
    "tooltip": true
}
2. Add to ~/.config/waybar/style.css:
#custom-aurora {
    min-width: 50px;
    padding: 0 8px;
}
#custom-aurora.unavailable {
    color: #6c7086;
}
#custom-aurora.normal {
    color: #a6e3a1;
}
#custom-aurora.warning {
    color: #f38ba8;
}
#custom-aurora.critical {
    color: #ff0000;
}
3. Set up cron for auto-updates (every 30 min):
   */30 * * * * /path/to/aurora.sh u

Usage:
======
./aurora.sh        # Show status (for waybar)
./aurora.sh u      # Update forecast data
./aurora.sh i      # View images
./aurora.sh d      # Display raw forecast
EOF
}

# Main command handler
case "${1:-}" in
    u|update) update ;;
    i|images) images ;;
    d|data)   data ;;
    t|tobar)  tobar ;;
    h|help)   show_help ;;
    *)        tobar ;;
esac
