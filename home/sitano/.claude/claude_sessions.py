#!/usr/bin/env python3
"""Print a table of active Claude Code sessions: name, age, branch, uuid.

Reads ~/.claude/sessions/<pid>.json (written by each running claude process),
drops entries whose process is gone, and asks git for the branch of each cwd.
"""
import json
import os
import subprocess
import time
from pathlib import Path

SESSIONS_DIR = Path.home() / ".claude" / "sessions"


def alive(pid: int) -> bool:
    try:
        os.kill(pid, 0)
    except ProcessLookupError:
        return False
    except PermissionError:
        return True
    return True


def branch(cwd: str) -> str:
    try:
        out = subprocess.run(
            ["git", "-C", cwd, "rev-parse", "--abbrev-ref", "HEAD"],
            capture_output=True, text=True, timeout=5,
        )
    except (OSError, subprocess.TimeoutExpired):
        return "-"
    return out.stdout.strip() if out.returncode == 0 and out.stdout.strip() else "-"


def age(started_ms: int) -> str:
    s = max(0, int(time.time() - started_ms / 1000))
    d, s = divmod(s, 86400)
    h, s = divmod(s, 3600)
    m = s // 60
    if d:
        return f"{d}d{h}h"
    if h:
        return f"{h}h{m}m"
    return f"{m}m"


def main() -> None:
    rows = []
    for f in SESSIONS_DIR.glob("*.json"):
        try:
            s = json.loads(f.read_text())
        except (OSError, json.JSONDecodeError):
            continue
        if not alive(s.get("pid", 0)):
            continue
        rows.append((
            s.get("startedAt", 0),
            s.get("name", "-"),
            age(s.get("startedAt", 0)),
            branch(s.get("cwd", ".")),
            s.get("sessionId", "-"),
        ))
    rows.sort()  # oldest first

    header = ("NAME", "AGE", "BRANCH", "UUID")
    table = [header] + [r[1:] for r in rows]
    widths = [max(len(r[i]) for r in table) for i in range(len(header))]
    for r in table:
        print("  ".join(c.ljust(w) for c, w in zip(r, widths)).rstrip())


if __name__ == "__main__":
    main()
