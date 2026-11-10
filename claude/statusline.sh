#!/usr/bin/env bash
# Claude Code status line: reads session JSON on stdin, prints two lines.
#   line 1: model, effort, git branch
#   line 2: context, 5-hour and 7-day usage bars
# Docs: https://code.claude.com/docs/en/statusline
# python3 instead of jq: already installed, and handles missing fields and dates cleanly.

exec python3 -c '
import json, os, subprocess, sys
from datetime import datetime

try:
    data = json.load(sys.stdin)
except ValueError:
    print("statusline: invalid JSON")
    sys.exit(0)

BOLD, DIM, RESET = "\033[1m", "\033[2m", "\033[0m"
GREEN, YELLOW, RED, CYAN = "\033[32m", "\033[33m", "\033[31m", "\033[36m"
DAYS = ["lun.", "mar.", "mer.", "jeu.", "ven.", "sam.", "dim."]
SEP = f" {DIM}·{RESET} "

def color(pct):
    return RED if pct >= 80 else YELLOW if pct >= 50 else GREEN

def bar(pct, width=10):
    filled = round(min(max(pct, 0), 100) / 100 * width)
    return f"{color(pct)}{chr(0x2588) * filled}{DIM}{chr(0x2591) * (width - filled)}{RESET}"

def gauge(label, pct, reset=None):
    text = f"{DIM}{label}{RESET} {bar(pct)} {color(pct)}{pct:.0f}%{RESET}"
    if reset:
        text += f" {DIM}↻ {reset}{RESET}"
    return text

def limit(label, window, fmt_reset):
    # Each rate-limit window can be absent (before the first response, or after it resets).
    used = (window or {}).get("used_percentage")
    if used is None:
        return None
    resets_at = window.get("resets_at")
    reset = fmt_reset(datetime.fromtimestamp(resets_at)) if resets_at else None
    return gauge(label, used, reset)

# Line 1: who is working, and where
top = []
model = (data.get("model") or {}).get("display_name")
effort = (data.get("effort") or {}).get("level")
if model:
    top.append(f"{BOLD}{model}{RESET}" + (f" {DIM}({effort}){RESET}" if effort else ""))

workspace = data.get("workspace") or {}
cwd = workspace.get("current_dir") or data.get("cwd")
# repo.name comes from the origin remote; fall back to the project folder name without one.
project_dir = workspace.get("project_dir") or cwd
repo = (workspace.get("repo") or {}).get("name") or (project_dir and os.path.basename(project_dir.rstrip("/")))
if repo:
    top.append(f"{BOLD}{repo}{RESET}")

if cwd:
    try:
        branch = subprocess.run(
            ["git", "-C", cwd, "branch", "--show-current"],
            capture_output=True, text=True, timeout=1,
        ).stdout.strip()
    except Exception:
        branch = ""
    if branch:
        top.append(f"{CYAN}⎇ {branch}{RESET}")

# Line 2: how much is left
bottom = []
ctx = (data.get("context_window") or {}).get("used_percentage")
bottom.append(gauge("ctx", ctx) if ctx is not None else f"{DIM}ctx --{RESET}")

limits = data.get("rate_limits") or {}
for item in (
    limit("5h", limits.get("five_hour"), lambda d: d.strftime("%H:%M")),
    limit("7j", limits.get("seven_day"), lambda d: f"{DAYS[d.weekday()]} {d:%H:%M}"),
):
    if item:
        bottom.append(item)

if top:
    print(SEP.join(top))
print("   ".join(bottom))
'
