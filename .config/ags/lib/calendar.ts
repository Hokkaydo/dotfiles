import { createPoll } from "ags/time"
import GLib from "gi://GLib"

export type CalEvent = {
  uid: string
  summary: string
  location: string
  description: string
  start: string // ISO
  end: string   // ISO
}

const CACHE_PATH = `${GLib.get_home_dir()}/.cache/ags/calendar.json`

const COLORS = ["#89b4fa", "#a6e3a1", "#cba6f7", "#fab387", "#f5c2e7", "#94e2d5", "#f9e2af"]

function colorFor(key: string) {
  let hash = 0
  for (const ch of key) hash = (hash * 31 + ch.charCodeAt(0)) % COLORS.length
  return COLORS[hash]
}

function readCache(): CalEvent[] {
  try {
    const [, contents] = GLib.file_get_contents(CACHE_PATH)
    return JSON.parse(new TextDecoder().decode(contents))
  } catch {
    return []
  }
}

// re-reads the cache file every 60s; the systemd timer refreshes its contents.
// createPoll(initial, intervalMs, fn) — if your ags version's createPoll only
// accepts a shell-exec string (not a function), swap the 3rd arg for
// `cat ${CACHE_PATH}` and add a 4th `transform` arg that does JSON.parse.
export const events = createPoll<CalEvent[]>([], 60_000, readCache)

export function withColor(ev: CalEvent) {
  // keyed by course name (not per-session uid) so the same course keeps the
  // same color across weeks even if each session has a distinct iCal UID.
  return { ...ev, color: colorFor(ev.summary) }
}

export function isToday(ev: CalEvent) {
  const now = GLib.DateTime.new_now_local()
  const start = GLib.DateTime.new_from_iso8601(ev.start, null)
  return start?.format("%Y-%m-%d") === now.format("%Y-%m-%d")
}

export function mondayOf(date: GLib.DateTime) {
  const dow = date.get_day_of_week() // 1=Mon..7=Sun
  return date.add_days(-(dow - 1))
}

export function fmtDay(d: GLib.DateTime) {
  return `${d.get_day_of_month()} ${d.format("%b")}`
}

export function sameDay(a: GLib.DateTime, b: GLib.DateTime) {
  return a.get_year() === b.get_year() && a.get_day_of_year() === b.get_day_of_year()
}

export function diffWeeks(from: GLib.DateTime, to: GLib.DateTime) {
  return Math.round(to.difference(from) / (7 * 24 * 3600 * 1_000_000))
}

export function formatRange(ev: CalEvent) {
  const s = GLib.DateTime.new_from_iso8601(ev.start, null)
  const e = GLib.DateTime.new_from_iso8601(ev.end, null)
  return `${s?.format("%H:%M")}–${e?.format("%H:%M")}`
}

export function weekdayIndex(ev: CalEvent) {
  const d = new Date(ev.start).getDay() // 0=Sun..6=Sat
  return d === 0 ? 6 : d - 1 // 0=Mon..6=Sun
}

export function eventStart(ev: CalEvent) {
  return GLib.DateTime.new_from_iso8601(ev.start, null)!
}
