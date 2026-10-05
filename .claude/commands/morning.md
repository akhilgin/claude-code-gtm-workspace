---
description: Daily briefing from calendar, Slack, CRM, and ad platforms
---
Give me a morning briefing. Everything in this command is read-only. Use whichever MCP servers are connected, and if one is missing, skip that section and say so in one line. Extra input from me: $ARGUMENTS

## Steps
1. Today's date and weekday.
2. Calendar: today's meetings in time order, with attendees and any prep I should do. Flag conflicts and gaps longer than 90 minutes.
3. Slack: mentions and DMs since the last working day, plus unanswered threads I started. Group by urgency (needs reply today, FYI).
4. CRM: changes since yesterday that matter to me: new opportunities, stage changes, closed won/lost, new inbound requests. Counts first, then the notable records.
5. Ad spend: yesterday and month-to-date spend per platform against the monthly budget in `context/` (if a budget file exists). Flag anything pacing more than 10% over or under.
6. Journal: read the last entry in `work/journal.md` for open items.

## Output
- One screen. Start with "Top 3 for today".
- Then the sections above, each as a few bullets. Plain text, no filler.
- End with a list of anything that needs a decision from me.

## Rules
- Do not send, post, or update anything. If an action looks useful, list it under "Suggested actions" and wait.
