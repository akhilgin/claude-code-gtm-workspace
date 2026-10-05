# .claude/commands/

Each markdown file is a slash command. The filename is the command name (`morning.md` becomes `/morning`). `$ARGUMENTS` in the file is replaced with whatever you type after the command.

Included:
- `/morning`  daily briefing
- `/weekly-recap`  team-ready weekly summary
- `/notion-card <description>`  create a task card
- `/sfdc-dq [options]`  CRM data-quality check

Steps that change an external system are marked "confirm first". Claude should show the exact change and wait for a yes before doing it. Commands assume the relevant MCP servers are connected; if one is missing, they skip that section and say so.
