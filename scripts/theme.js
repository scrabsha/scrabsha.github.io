const dark_theme_toggle = document.getElementById("dark-theme-toggle")
const true_bw_toggle = document.getElementById("bw-toggle")
const html_ = document.getElementsByTagName("html")[0]

const dark_theme_query = window.matchMedia("(prefers-color-scheme: dark)")

let current_theme_class = dark_theme_query.matches ? "dark-theme" : undefined

function update_theme(update_checkbox) {
  if (update_checkbox) {
    dark_theme_toggle.checked = dark_theme_query.matches
  }

  let next_theme_class =
    (dark_theme_toggle.checked ? "dark-" : "light-")
    + (true_bw_toggle.checked ? "bw-" : "")
    + "theme"

  html_.classList.remove(current_theme_class)
  if (next_theme_class != "light-theme") {
    // Skip `light-theme`, as it's the default theme.
    html_.classList.add(next_theme_class)
  }

  current_theme_class = next_theme_class
}

update_theme(true)
html_.classList.add("theme-evaluated")

dark_theme_query.addEventListener("change", () => update_theme(true))
dark_theme_toggle.addEventListener("click", () => update_theme(false))
true_bw_toggle.addEventListener("click", () => update_theme(false))
