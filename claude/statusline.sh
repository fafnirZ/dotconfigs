#!/bin/bash
# ~/.claude/statusline.sh
in=$(cat)
echo "$in" | jq '.rate_limits // empty | . + {updated_at: (now | todate), updated_epoch: (now | floor)}' > ~/.claude/plan-usage.json 2>/dev/null
fh=$(jq -r '.rate_limits.five_hour.used_percentage // "?"' <<<"$in")
sd=$(jq -r '.rate_limits.seven_day.used_percentage // "?"' <<<"$in")
echo "usage- 5h: ${fh}% | 7d: ${sd}%"
