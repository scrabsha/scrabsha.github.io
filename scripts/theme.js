function get_theme_radio(theme) {
  return document.getElementById(`${theme}-theme-radio`)
}

const theme_buttons = {
  dark: get_theme_radio("dark"),
  system: get_theme_radio("system"),
  light: get_theme_radio("light"),
}

const true_bw_toggle = document.getElementById("bw-toggle")
const html_ = document.getElementsByTagName("html")[0]

const dark_theme_query = window.matchMedia("(prefers-color-scheme: dark)")

let current_theme_class = dark_theme_query.matches ? "dark-theme" : undefined

function update_theme(selected_theme) {
  if (typeof(selected_theme) === "undefined") {
    if (!theme_buttons.system.checked) {
      // System theme change but system theme is not selected -> ignore.
      return
    }

    selected_theme = dark_theme_query.matches ? "dark" : "light"
  } else if (selected_theme !== "bw") {
    localStorage.setItem("theme", selected_theme)
    theme_buttons[selected_theme].checked = true
  } else {
    selected_theme = localStorage.getItem("theme") || "system"
  }

  const next_theme_class =
    (selected_theme !== "system" ? selected_theme
      : dark_theme_query.matches ? "dark"
      : "light")
    + "-"
    + (true_bw_toggle.checked ? "bw-" : "")
    + "theme"

  html_.classList.remove(current_theme_class)
  html_.classList.add(next_theme_class)

  current_theme_class = next_theme_class
}

const initial_theme = localStorage.getItem("theme") || "system"
theme_buttons[initial_theme].checked = true
update_theme(initial_theme)
html_.classList.add("theme-evaluated")

theme_buttons.dark.addEventListener("click", () => update_theme("dark"))
theme_buttons.light.addEventListener("click", () => update_theme("light"))
theme_buttons.system.addEventListener("click", () => update_theme("system"))
dark_theme_query.addEventListener("change", () => update_theme(undefined))

true_bw_toggle.addEventListener("click", () => update_theme("bw"))
