#!/usr/bin/env python3
"""Merge the versioned Claude settings into the live settings file."""
import json
import os
import shutil
import sys
import tempfile
import time


def load(path):
    try:
        with open(path, encoding="utf-8-sig") as file:
            data = json.load(file)
    except json.JSONDecodeError as error:
        sys.exit(f"réglages : JSON invalide dans {path} ({error}), rien n'a été modifié")
    if not isinstance(data, dict):
        sys.exit(f"réglages : objet JSON attendu dans {path}, rien n'a été modifié")
    return data


# Lists are unioned so that a merge can never drop a permission rule.
def merge(live, repo):
    merged = dict(live)
    for key, value in repo.items():
        current = merged.get(key)
        if isinstance(current, dict) and isinstance(value, dict):
            merged[key] = merge(current, value)
        elif isinstance(current, list) and isinstance(value, list):
            merged[key] = value + [item for item in current if item not in value]
        else:
            merged[key] = value
    return merged


def write(path, data, mode):
    descriptor, temp_path = tempfile.mkstemp(dir=os.path.dirname(path), prefix=".settings.")
    try:
        with os.fdopen(descriptor, "w", encoding="utf-8") as file:
            json.dump(data, file, indent=2, ensure_ascii=False)
            file.write("\n")
        os.chmod(temp_path, mode)
        os.replace(temp_path, path)
    except BaseException:
        if os.path.exists(temp_path):
            os.unlink(temp_path)
        raise


def main():
    if len(sys.argv) != 3:
        sys.exit("usage: merge-settings.py <repo-settings> <live-settings>")
    repo_path, live_path = sys.argv[1:]

    repo = load(repo_path)
    # Orca owns the hooks and regenerates them at startup.
    repo.pop("hooks", None)

    is_link = os.path.islink(live_path)
    exists = os.path.exists(live_path)
    live = load(live_path) if exists else {}
    merged = merge(live, repo)

    if exists and not is_link and merged == live:
        print(f"réglages : {live_path} déjà à jour")
        return

    mode = os.stat(live_path).st_mode & 0o777 if exists else 0o644
    if exists and not is_link:
        backup = f"{live_path}.backup.{time.strftime('%Y%m%d%H%M%S')}"
        shutil.copy2(live_path, backup)
        print(f"sauvegarde : {backup}")
    os.makedirs(os.path.dirname(live_path), exist_ok=True)
    write(live_path, merged, mode)
    print(f"réglages : {live_path} mis à jour")


if __name__ == "__main__":
    main()
