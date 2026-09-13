#!/usr/bin/env python3
"""Pulls an iCal subscription and writes a flat JSON event list for the
AGS calendar widget to read. Run periodically via the bundled systemd timer."""
import json
import os
from datetime import datetime, timedelta

import requests
import recurring_ical_events
from icalendar import Calendar

CONFIG_DIR = os.path.expanduser("~/.config/ags")
CACHE_DIR = os.path.expanduser("~/.cache/ags")
URL_FILE = os.path.join(CONFIG_DIR, "ical-url.txt")
OUT_FILE = os.path.join(CACHE_DIR, "calendar.json")

WINDOW_DAYS_BACK = 7
WINDOW_DAYS_FWD = 21


def main():
    with open(URL_FILE) as f:
        url = f.read().strip()

    resp = requests.get(url, timeout=20)
    resp.raise_for_status()
    cal = Calendar.from_ical(resp.content)

    start = datetime.now() - timedelta(days=WINDOW_DAYS_BACK)
    end = datetime.now() + timedelta(days=WINDOW_DAYS_FWD)
    occurrences = recurring_ical_events.of(cal).between(start, end)

    events = []
    for ev in occurrences:
        events.append({
            "uid": str(ev.get("UID", ev.get("SUMMARY", ""))),
            "summary": str(ev.get("SUMMARY", "Untitled")),
            "location": str(ev.get("LOCATION", "")),
            "description": str(ev.get("DESCRIPTION", "")),
            "start": ev["DTSTART"].dt.isoformat(),
            "end": ev["DTEND"].dt.isoformat(),
        })

    events.sort(key=lambda e: e["start"])

    os.makedirs(CACHE_DIR, exist_ok=True)
    with open(OUT_FILE, "w") as f:
        json.dump(events, f, indent=2)

    print(f"Wrote {len(events)} events to {OUT_FILE}")


if __name__ == "__main__":
    main()
