---
description: Run the CRM data-quality monitor and triage the findings
---
CRM data-quality check. Run the read-only monitor, then triage what it found. Input: $ARGUMENTS

## Guardrails
- Read-only. Never run DML or call write tools, and never edit records. If a fix is obvious, describe it and stop. I approve changes.
- Post to Slack only if the input explicitly says `slack`. Confirm first: show the message and channel, then wait.

## Steps
1. Parse the input. Empty means a full run. A comma list means those check ids only. `list` means list the available checks and stop. `dry` means do not save snapshots.
2. Run your monitor script from the repo root, for example `python3 system/dq_monitor.py <flags>`. (This template does not include one. Write a script that runs a set of read-only queries, such as duplicate contacts, missing required fields, orphaned records, and stale owners, and saves a snapshot to `work/YYYY-MM-DD-dq/`.)
3. Triage each alerting check:
   - What it is, the count, and the change since the last snapshot.
   - Whether it is new damage or a known backlog.
   - The likely source, from the sample records' created-by and modified-by values and dates. Note that automation can re-save many records at once, so modified-by alone is not proof.
   - A one-line recommended next step.
4. Reply in this order: overall status line; alerts ranked by severity with source and next step; one line on any unexpected burst of writes; clean checks as a single line. Short and plain. Do not restate the whole table.
