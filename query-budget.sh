#!/bin/bash
# Use UTC+8 timezone for date calculation
YESTERDAY=$(TZ='Asia/Shanghai' date -d 'yesterday' +%Y-%m-%d)
THRESHOLD="0.00"

# Read tenancy from OCI config
TENANCY=$(grep "^tenancy=" ~/.oci/config | cut -d'=' -f2)

BUDGET=$(oci usage query \
  --query-type COST \
  --time-range "START=${YESTERDAY}T00:00:00+08:00,END=${YESTERDAY}T23:59:59+08:00" \
  --compartment-id "$TENANCY" \
  --config ~/.oci/config \
  --key-file ~/.oci/oci_key 2>/dev/null | jq -r '.data.items[0].cost // "0.00"')

BUDGET=$(printf "%.2f" "$BUDGET")
echo "Yesterday's budget (${YESTERDAY}): $BUDGET SGD"

# Send to Telegram only when budget exceeds threshold or FORCE_NOTIFY is set
NOTIFY=0
IS_OVER=$(echo "$BUDGET > $THRESHOLD" | bc -l)
if [ "$IS_OVER" == "1" ] || [ "$FORCE_NOTIFY" == "true" ]; then
  NOTIFY=1
  curl -s "https://api.telegram.org/bot$TELEGRAM_BOT_TOKEN/sendMessage" \
    -d "chat_id=$TELEGRAM_CHAT_ID" \
    -d "text=Daily Budget Report
Date: ${YESTERDAY}
Budget: ${BUDGET} SGD"
fi

echo "BUDGET=$BUDGET" >> $GITHUB_OUTPUT
echo "NOTIFY=$NOTIFY" >> $GITHUB_OUTPUT
