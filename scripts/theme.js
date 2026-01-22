const true_bw_toggle = document.getElementById("bw-toggle")
const html_ = document.getElementsByTagName("html")[0]

const dark_theme_query = window.matchMedia("(prefers-color-scheme: dark)")

let current_theme_class = dark_theme_query.matches ? "dark-theme" : undefined

function update_page_theme() {
  const theme = document.forms.page_settings.theme.value
  const black_and_white = document.forms.page_settings.black_and_white.checked

  const next_theme_class =
  (theme !== "system" ? theme
    : dark_theme_query.matches ? "dark"
    : "light")
  + "-"
  + (black_and_white ? "bw-" : "")
  + "theme"

  html_.classList.remove(current_theme_class)
  html_.classList.add(next_theme_class)

  current_theme_class = next_theme_class

  localStorage.setItem("theme", theme)
  localStorage.setItem("black_and_white", black_and_white)
}

const initial_theme = localStorage.getItem("theme") || "system"
document.forms.page_settings.theme.value = initial_theme
const initial_black_and_white = localStorage.getItem("black_and_white") === "true"
document.forms.page_settings.black_and_white.checked = initial_black_and_white
update_page_theme()
html_.classList.add("theme-evaluated")

document.forms.page_settings.addEventListener("change", () => update_page_theme())
dark_theme_query.addEventListener("change", () => update_page_theme())
