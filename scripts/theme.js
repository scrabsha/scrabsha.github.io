const dark_theme_toggle = document.getElementById("dark-theme-toggle")
const html_ = document.getElementsByTagName("html")[0]

const dark_theme_query = window.matchMedia("(prefers-color-scheme: dark)")

function update_theme(update_checkbox) {
  console.log(update_checkbox)
  if (update_checkbox) {
    dark_theme_toggle.checked = dark_theme_query.matches
  }

  if (dark_theme_toggle.checked) {
    html_.classList.add("dark-theme")
  } else {
    html_.classList.remove("dark-theme")
  }
}

update_theme(true)
html_.classList.add("theme-evaluated")

dark_theme_query.addEventListener("change", () => update_theme(true))
dark_theme_toggle.addEventListener("click", () => update_theme(false))
