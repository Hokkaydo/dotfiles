import app from "ags/gtk3/app"
import style from "./style.scss"
import CalendarWidget from "./widget/CalendarWidget"

app.start({
  css: style,
  main() {
    CalendarWidget()
  },
})
