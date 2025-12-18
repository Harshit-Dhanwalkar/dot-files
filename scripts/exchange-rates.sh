#!/usr/bin/env bash

API="https://open.er-api.com/v6/latest"

CURRENCY_BASE="USD"
CURRENCY_QUOTE="INR"

rate=$(curl -sf "$API/$CURRENCY_BASE" | jq -r ".rates.$CURRENCY_QUOTE")

if [[ -z "$rate" || "$rate" == "null" ]]; then
    echo "Error: Could not retrieve exchange rate for $CURRENCY_BASE to $CURRENCY_QUOTE." >&2
    exit 1
fi

formatted_quote=$(printf "${CURRENCY_BASE}=%.2f${CURRENCY_QUOTE}" "$rate")
echo "$formatted_quote"
