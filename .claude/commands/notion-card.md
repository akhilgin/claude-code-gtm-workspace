---
description: Create a task card on the team board from a one-line description
---
Create a task card from this description: $ARGUMENTS

## Steps
1. Read the board's schema first (properties, allowed statuses, owners) using the Notion MCP. Do not guess property names.
2. Draft the card from my description:
   - Title: short, starts with a verb
   - Description: 2 to 4 lines on what and why, only what I told you or what is in the repo
   - Status, owner, due date, labels: use my input if given, otherwise leave unset and list them as open
3. Show me the draft as plain text, plus the target board.
4. Confirm first. Do not create the card until I say yes. Apply any edits I give, show the draft again, and wait again.
5. After creating it, print the card link.

## Rules
- Do not invent due dates, owners, or links.
- Check the board for a card with a similar title first. If one exists, show it and ask whether to update it or create a new one.
- Create one card per request. Never edit or delete other cards.
