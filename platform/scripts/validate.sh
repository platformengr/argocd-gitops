#!/usr/bin/env bash
# Checks every manifest in this repo before Argo CD sees it: YAML parses, every
# Application names a project and a destination, no plain Secrets.
set -euo pipefail
cd "$(dirname "$0")/.."
python3 - <<'PY'
import glob, sys, yaml
bad = 0
for f in sorted(glob.glob("**/*.yaml", recursive=True)):
    if f.startswith(".github/"):
        continue
    try:
        docs = [d for d in yaml.safe_load_all(open(f)) if d]
    except yaml.YAMLError as e:
        print(f"FAIL {f}: not valid YAML: {e}"); bad += 1; continue
    for d in docs:
        kind = d.get("kind")
        if kind == "Secret":
            print(f"FAIL {f}: plain Secret in Git; seal it (module 08)"); bad += 1
        if kind == "Application":
            spec = d.get("spec", {})
            if not spec.get("project"):
                print(f"FAIL {f}: Application without spec.project"); bad += 1
            if not spec.get("destination"):
                print(f"FAIL {f}: Application without spec.destination"); bad += 1
            if "YOUR_GITHUB_USER" in open(f).read():
                print(f"FAIL {f}: still points at YOUR_GITHUB_USER"); bad += 1
print("ok" if not bad else f"{bad} problem(s)")
sys.exit(1 if bad else 0)
PY
