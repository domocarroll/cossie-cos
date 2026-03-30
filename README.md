# Cossie v2 — Chief of Staff for Claude Code

A Chief of Staff skill for [Claude Code](https://claude.ai/claude-code) that triages your inbox, dispatches work to subagents, tracks follow-ups, time-blocks your calendar, preps meetings, drafts communications, and monitors infrastructure.

## Install

```bash
git clone https://github.com/domocarroll/cossie-cos.git ~/cossie-cos
cd ~/cossie-cos && chmod +x install.sh && ./install.sh
```

## Prerequisites

- [Claude Code](https://claude.ai/claude-code)
- [gws CLI](https://www.npmjs.com/package/@googleworkspace/cli) authenticated with `gmail.modify` and `calendar` scopes
- Node.js (for Krang integration)
- Python 3 (for email digest, follow-ups, infra checks)

## Commands

| Command | What It Does |
|---------|-------------|
| `/cossie` | Quick status — email count, overdue follow-ups, top actions |
| `/cossie sweep` | Full morning sweep — classify everything as G/Y/R/Gray, present triage |
| `/cossie dispatch` | Spawn subagents to handle Green and Yellow items |
| `/cossie timeblock` | Build a time-blocked calendar from remaining tasks |
| `/cossie inbox` | Analyse senders, create labels, archive noise |
| `/cossie followup` | View, add, complete, and track follow-ups |
| `/cossie prep [meeting]` | Assemble context and talking points for a meeting |
| `/cossie draft [type]` | Draft an email, reply, proposal, or update |
| `/cossie decide [topic]` | Get a recommendation with reasoning |
| `/cossie eod` | End-of-day summary, auto-create follow-ups, preview tomorrow |
| `/cossie krang` | Krang/Huly project management operations |
| `/cossie infra` | SSH health check (Docker, disk, memory) |

## Classification System

Every item gets classified into one of four categories:

| Category | Symbol | Meaning |
|----------|--------|---------|
| **Green** | `[G]` | Agent handles it autonomously |
| **Yellow** | `[Y]` | Agent preps 80%, you finish |
| **Red** | `[R]` | Requires your brain |
| **Gray** | `[-]` | Skip — not actionable today |

When uncertain, Cossie defaults to Yellow (prep), never Green.

## Data Layer

Shell scripts in `~/bin/` that return structured JSON:

| Script | Source | Purpose |
|--------|--------|---------|
| `cos-email-digest` | Gmail via gws | Unread emails, noise filtered |
| `cos-calendar` | Google Calendar via gws | Today's events |
| `cos-followups` | Local JSON file | Follow-up tracking CRUD |
| `cos-krang` | Krang SDK | Project management queries |
| `cos-infra` | SSH | VPS health check |

## State

Persistent state in `~/.cos/`:

```
~/.cos/
  state.json           — Session metadata
  followups.json       — Active follow-up items
  context.json         — Rolling 7-day context
  briefing-history/    — Archived daily briefings
```

## Configuration

Set environment variables for your setup:

```bash
export COS_KRANG_DIR="$HOME/projects/huly-sdk-explorer"
export COS_SSH_KEY="$HOME/.ssh/my_key"
export COS_SSH_HOST="root@my-server-ip"
```

See `cos.env.example` for all options.

Edit `~/.claude/skills/chief-of-staff/sender-classifications.json` to classify your inbox senders.

## Safety Constraints

Cossie will **never**:
- Send email (only creates drafts)
- Delete calendar events or emails
- Modify kernel documents or contracts
- Commit code or push to git

Cossie will **always**:
- Present a plan before acting
- Wait for confirmation before dispatching
- Default to prep on ambiguity

## Update

```bash
cd ~/cossie-cos && git pull && ./install.sh
```

## License

MIT
