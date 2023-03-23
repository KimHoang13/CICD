#!/bin/bash
discord_url="https://discord.com/api/webhooks/1085381928263368764/nB9sLpE_Wn3knPmep5PKFh2gnhEk9vDiY9sly2LGXs15nplwfgihNXJALPvc8oEV1grK"
conten=$1
title=$2
description=$3
generate_post_data() {
  cat <<EOF
{
  "content": "$conten",
  "embeds": [{
    "title": "$title",
    "description": "$description",
    "color": "45973"
  }]
}
EOF
}
curl -H "Content-Type: application/json" -X POST -d "$(generate_post_data)" $discord_url
