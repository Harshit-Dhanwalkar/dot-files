#!/usr/bin/env bash

# --- CONFIGURATION ---
# Get a token here: https://aqicn.org/api/
TOKEN="YOUR_WAQI_TOKEN"
# Set CITY to a specific city, or leave it empty ("") to use geolocation.
CITY=""

API="https://api.waqi.info/feed"
TEMP_FILE="/tmp/aqi_waybar_data.json"

# $1: text/icon, $2: tooltip, $3: CSS class
output_json() {
    printf '{"text": "%s", "tooltip": "%s", "class": "%s"}\n' "$1" "$2" "$3"
}

# Determine AQI data source
aqi_json=""
STATION_NAME=""

if [ -n "$CITY" ]; then
    # Query by city name (using the search endpoint to get the best station UID)
    STATION_UID=$(curl -sf "$API/search/?keyword=$CITY&token=$TOKEN" | jq -r '.data[0].uid')
    if [ -n "$STATION_UID" ]; then
        aqi_json=$(curl -sf "$API/@$STATION_UID/?token=$TOKEN")
    fi
else
    # Query using geolocation (if CITY is empty)
    location=$(curl -sf "https://location.services.mozilla.com/v1/geolocate?key=geoclue")
    if [ -n "$location" ]; then
        location_lat="$(echo "$location" | jq -r '.location.lat')"
        location_lon="$(echo "$location" | jq -r '.location.lon')"
        aqi_json=$(curl -sf "$API/geo:$location_lat;$location_lon/?token=$TOKEN")
    fi
fi

# 2. Process Data and Format Output
if [ -n "$aqi_json" ]; then
    if [ "$(echo "$aqi_json" | jq -r '.status')" = "ok" ]; then

        # Extract main data points
        AQI_VALUE=$(echo "$aqi_json" | jq -r '.data.aqi')
        STATION_NAME=$(echo "$aqi_json" | jq -r '.data.city.name')

        # Fallback check
        if [ "$AQI_VALUE" = "null" ] || [ -z "$AQI_VALUE" ] || [ "$AQI_VALUE" = "0" ]; then
            output_json "AQI Error" "No valid AQI data available." "error"
            exit 0
        fi

        # Determine CSS class based on AQI value
        if (( AQI_VALUE <= 50 )); then
            CLASS="good"      # 0-50: Green
            STATUS="Good"
        elif (( AQI_VALUE <= 100 )); then
            CLASS="moderate"  # 51-100: Yellow
            STATUS="Moderate"
        elif (( AQI_VALUE <= 150 )); then
            CLASS="unhealthy_s" # 101-150: Orange
            STATUS="Unhealthy (Sensitive)"
        elif (( AQI_VALUE <= 200 )); then
            CLASS="unhealthy" # 151-200: Red
            STATUS="Unhealthy"
        elif (( AQI_VALUE <= 300 )); then
            CLASS="very_unhealthy" # 201-300: Purple
            STATUS="Very Unhealthy"
        else
            CLASS="hazardous" # 300+: Maroon
            STATUS="Hazardous"
        fi

        # Generate output JSON
        TEXT_OUTPUT=" $AQI_VALUE"
        TOOLTIP_OUTPUT="AQI: $STATUS\nStation: $STATION_NAME"

        output_json "$TEXT_OUTPUT" "$TOOLTIP_OUTPUT" "$CLASS"

    else
        # API returned an error message
        ERROR_MESSAGE=$(echo "$aqi_json" | jq -r '.data')
        output_json "AQI Error" "API Message: $ERROR_MESSAGE" "error"
    fi
else
    # Curl failed or returned empty data
    output_json "AQI Offline" "Could not connect to AQI API." "offline"
fi
