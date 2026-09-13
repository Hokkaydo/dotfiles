import app from "ags/gtk3/app"
import Gtk from "gi://Gtk?version=3.0"
import Astal from "gi://Astal?version=3.0"
import Pango from "gi://Pango"
import GLib from "gi://GLib"
import { createState, createComputed, For, With } from "ags"
import { events, withColor, isToday, formatRange, eventStart, mondayOf, fmtDay, sameDay, diffWeeks } from "../lib/calendar"

type View = "compact" | "expanded" | "full"
type CalMode = "week" | "month"

const DIMS: Record<View, [number, number]> = {
  compact: [320, 230],
  expanded: [640, 480],
  full: [900, 640],
}

const V = Gtk.Orientation.VERTICAL
const H = Gtk.Orientation.HORIZONTAL
const DAYS = ["Mon", "Tue", "Wed", "Thu", "Fri"]

function tooltip(ev: ReturnType<typeof withColor>) {
  return `${ev.summary}\n📍 ${ev.location || "—"}\n🕘 ${formatRange(ev)}${
    ev.description ? `\n${ev.description}` : ""
  }`
}

function TodayCard(setView: (v: View) => void) {
  const [dayOffset, setDayOffset] = createState(0)
  const dayInfo = createComputed(() => {
    const date = GLib.DateTime.new_now_local().add_days(dayOffset())
    const list = events().map(withColor).filter((ev) => sameDay(eventStart(ev), date))
    return { date, list }
  })
  const label = createComputed(() => dayInfo().date.format("%a %d %b"))

  return (
    <box class="CalendarWidget compact" orientation={V} vexpand hexpand>
      <box orientation={H}>
        <button class="icon-btn" onClicked={() => setDayOffset((n) => n - 1)} label="‹" />
        <label class="header-title" hexpand halign={Gtk.Align.CENTER} label={label} />
        <button class="icon-btn" onClicked={() => setDayOffset((n) => n + 1)} label="›" />
        <button class="icon-btn" onClicked={() => setView("expanded")} label="⤢" />
      </box>
      <box orientation={V} spacing={8} vexpand>
        <For each={dayInfo((i) => i.list)}>
          {(ev) => (
            <box class="today-row" orientation={H} spacing={10} tooltipText={tooltip(ev)}>
              <box class="color-bar" css={`background-color: ${ev.color};`} vexpand />
              <box orientation={V} hexpand>
                <label
                  class="today-row-name"
                  halign={Gtk.Align.START}
                  label={ev.summary}
                  ellipsize={Pango.EllipsizeMode.END}
                />
                <label
                  class="today-row-sub"
                  halign={Gtk.Align.START}
                  label={`${formatRange(ev)} · ${ev.location}`}
                />
              </box>
            </box>
          )}
        </For>
      </box>
    </box>
  )
}

// weekOffset: weeks from the current real week. size controls hour range/scale + which chrome shows.
function WeekView(
  setView: (v: View) => void,
  size: "expanded" | "full",
  weekOffset: () => number,
  setWeekOffset: (n: number | ((n: number) => number)) => void,
  setCalMode?: (m: CalMode) => void,
) {
  const hourPx = size === "expanded" ? 34 : 40
  const dayStart = 8
  const dayEnd = size === "expanded" ? 19 : 20

  const weekInfo = createComputed(() => {
    const monday = mondayOf(GLib.DateTime.new_now_local()).add_days(weekOffset() * 7)
    const list = events().map(withColor)
    const cols = DAYS.map((_, i) => {
      const dayDate = monday.add_days(i)
      return list.filter((ev) => sameDay(eventStart(ev), dayDate))
    })
    return { monday, sunday: monday.add_days(6), cols }
  })

  const label = createComputed(() => {
    const { monday, sunday } = weekInfo()
    return `${fmtDay(monday)} – ${fmtDay(sunday)} ${sunday.get_year()}`
  })

  return (
    <box orientation={V} vexpand hexpand spacing={10}>
      <box>
        {size === "expanded" && (
          <button class="icon-btn" onClicked={() => setView("compact")} label="‹" />
        )}
        {(size === "full" || size === "expanded") && (
          <button class="pill-btn" onClicked={() => setWeekOffset((n) => n - 1)} label="‹" />
        )}
        {(size === "full" || size === "expanded") && (
          <button class="pill-btn" onClicked={() => setWeekOffset(0)} label="Today" />
        )}
        {(size === "full" || size === "expanded") && (
          <button class="pill-btn" onClicked={() => setWeekOffset((n) => n + 1)} label="›" />
        )}
        <label class="header-title" hexpand halign={Gtk.Align.START} label={label} />
        {size === "expanded" && (
          <button class="pill-btn" onClicked={() => setView("full")} label="Full app ↗" />
        )}
        {size === "full" && (
          <button class="pill-btn active" label="Week" />
        )}
        {size === "full" && (
          <button class="pill-btn" onClicked={() => setCalMode?.("month")} label="Month" />
        )}
      </box>
      <box>
        <box widthRequest={38} />
        {DAYS.map((d) => (
          <label class="day-label" hexpand halign={Gtk.Align.CENTER} label={d} />
        ))}
      </box>
      <box vexpand>
        <box orientation={V} widthRequest={38}>
          {Array.from({ length: dayEnd - dayStart + 1 }, (_, i) => dayStart + i).map((h) => (
            <label class="hour-label" heightRequest={hourPx} valign={Gtk.Align.START} label={`${h}h`} />
          ))}
        </box>
        <With value={weekInfo}>
          {(info) => (
            <box hexpand>
              {info.cols.map((dayEvents) => {
              const sorted = [...dayEvents].sort((a, b) => eventStart(a).compare(eventStart(b)))
              const children: any[] = []
              let cursorHour = dayStart
              for (const ev of sorted) {
                const s = eventStart(ev)
                const startHour = s.get_hour() + s.get_minute() / 60
                const durHours = (new Date(ev.end).getTime() - new Date(ev.start).getTime()) / 3_600_000
                if (startHour > cursorHour) {
                  children.push(<box heightRequest={Math.round((startHour - cursorHour) * hourPx)} />)
                }
                children.push(
                  <box
                    orientation={V}
                    class="event-tile"
                    css={`background-color: ${ev.color};`}
                    tooltipText={tooltip(ev)}
                    heightRequest={Math.max(1, Math.round(durHours * hourPx - 3))}
                  >
                    <label
                      class="event-tile-code"
                      halign={Gtk.Align.START}
                      label={ev.summary}
                      ellipsize={Pango.EllipsizeMode.END}
                    />
                    <label class="event-tile-time" halign={Gtk.Align.START} label={formatRange(ev)} />
                  </box>,
                )
                cursorHour = Math.max(cursorHour, startHour + durHours)
              }
              if (cursorHour < dayEnd) {
                children.push(<box heightRequest={Math.round((dayEnd - cursorHour) * hourPx)} vexpand />)
              }
              return (
                <box
                  orientation={V}
                  hexpand
                  css="background-color: rgba(255,255,255,0.03); border-radius: 6px;"
                >
                  {children}
                </box>
              )
              })}
            </box>
          )}
        </With>
      </box>
    </box>
  )
}

function MonthView(
  setCalMode: (m: CalMode) => void,
  setView: (v: View) => void,
  monthOffset: () => number,
  setMonthOffset: (n: number | ((n: number) => number)) => void,
  setWeekOffset: (n: number) => void,
) {
  const info = createComputed(() => {
    const base = GLib.DateTime.new_now_local().add_months(monthOffset())
    const firstOfMonth = GLib.DateTime.new_local(base.get_year(), base.get_month(), 1, 0, 0, 0)
    const gridStart = mondayOf(firstOfMonth)
    const today = GLib.DateTime.new_now_local()
    const thisMonday = mondayOf(today)
    const all = events().map(withColor)

    const cells = Array.from({ length: 42 }, (_, i) => {
      const date = gridStart.add_days(i)
      const inMonth = date.get_month() === base.get_month()
      const isToday = sameDay(date, today)
      const dayEvents = all.filter((ev) => sameDay(eventStart(ev), date))
      const colors = [...new Set(dayEvents.map((e) => e.color))].slice(0, 4)
      const wk = diffWeeks(thisMonday, mondayOf(date))
      return { day: date.get_day_of_month(), inMonth, isToday, colors, wk, count: dayEvents.length }
    })

    return { label: base.format("%B %Y"), cells }
  })

  return (
    <box orientation={V} vexpand hexpand spacing={10}>
      <box>
        <button class="pill-btn" onClicked={() => setMonthOffset((n) => n - 1)} label="‹" />
        <button class="pill-btn" onClicked={() => setMonthOffset(0)} label="Today" />
        <button class="pill-btn" onClicked={() => setMonthOffset((n) => n + 1)} label="›" />
        <label class="header-title" hexpand halign={Gtk.Align.START} label={info((i) => i.label)} />
        <button class="pill-btn" onClicked={() => setCalMode("week")} label="Week" />
        <button class="pill-btn active" label="Month" />
      </box>
      <box>
        {DAYS.concat(["Sat", "Sun"]).map((d) => (
          <label class="day-label" hexpand halign={Gtk.Align.CENTER} label={d} />
        ))}
      </box>
      <box orientation={V} vexpand spacing={2}>
        {[0, 1, 2, 3, 4, 5].map((row) => (
          <box spacing={2} hexpand vexpand>
            <With value={info}>
              {(i) => (
                <box hexpand>
                  {i.cells.slice(row * 7, row * 7 + 7).map((c) => (
                    <button
                      class={c.isToday ? "month-cell month-cell-today" : c.inMonth ? "month-cell" : "month-cell month-cell-muted"}
                      hexpand
                      vexpand
                      onClicked={() => {
                        setWeekOffset(c.wk)
                        setCalMode("week")
                        setView("full")
                      }}
                    >
                      <box orientation={V} spacing={4}>
                        <label label={String(c.day)} />
                        <box spacing={3} halign={Gtk.Align.CENTER}>
                          {c.colors.map((col) => (
                            <box widthRequest={5} heightRequest={5} css={`background-color: ${col}; border-radius: 3px;`} />
                          ))}
                        </box>
                      </box>
                    </button>
                  ))}
                </box>
              )}
            </With>
          </box>
        ))}
      </box>
    </box>
  )
}

function FullApp(setView: (v: View) => void) {
  const [calMode, setCalMode] = createState<CalMode>("week")
  const [weekOffset, setWeekOffset] = createState(0)
  const [monthOffset, setMonthOffset] = createState(0)

  return (
    <box class="CalendarWidget full" orientation={V} hexpand vexpand>
      <box>
        <button class="icon-btn" onClicked={() => setView("expanded")} label="‹" />
        <label class="header-title" label="My Schedule" />
      </box>
      <With value={calMode}>
        {(mode) =>
          mode === "week"
            ? WeekView(setView, "full", weekOffset, setWeekOffset, setCalMode)
            : MonthView(setCalMode, setView, monthOffset, setMonthOffset, setWeekOffset)
        }
      </With>
    </box>
  )
}

export default function CalendarWidget() {
  const [view, setView] = createState<View>("compact")
  const [expandedWeekOffset, setExpandedWeekOffset] = createState(0)
  const width = createComputed(() => DIMS[view()][0])
  const height = createComputed(() => DIMS[view()][1])

  return (
    <window
      class="CalendarWidgetWindow"
      application={app}
      anchor={Astal.WindowAnchor.TOP | Astal.WindowAnchor.LEFT}
      layer={Astal.Layer.BOTTOM}
      exclusivity={Astal.Exclusivity.IGNORE}
      margin_left={64}
      margin_top={80}
      widthRequest={width}
      heightRequest={height}
      visible
    >
      <box orientation={V} hexpand vexpand>
        <With value={view}>
          {(v) => {
            if (v === "compact") return TodayCard(setView)
            if (v === "expanded")
              return (
                <box class="CalendarWidget expanded" orientation={V} vexpand hexpand>
                  {WeekView(setView, "expanded", expandedWeekOffset, setExpandedWeekOffset)}
                </box>
              )
            return FullApp(setView)
          }}
        </With>
      </box>
    </window>
  )
}
