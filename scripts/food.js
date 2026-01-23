let current_language = localStorage.getItem("products-language") || "fr"
document.forms.page_settings.product_language.value = current_language

function set_products_display(lang, dis) {
  const elts = document.getElementsByClassName(`product-${lang}`)
  for (const elt of elts) {
    elt.style.display = dis
  }
}

function update_products() {
  set_products_display(current_language, "none")
  current_language = document.forms.page_settings.product_language.value
  set_products_display(current_language, "inherit")
  localStorage.setItem("products-language", current_language)
}

document.forms.page_settings.addEventListener("change", () => {
  update_products()
})

update_products()

const checkbox_status_key = `${location.href}-recipe-checkboxes`

function restore_checkbox_status() {
  const checkboxes = JSON.parse(localStorage.getItem(checkbox_status_key))

  try {
    for (const checked_checkbox_id of checkboxes) {
      try {
        document.getElementById(checked_checkbox_id).checked = true
      } catch (e) {}
    }
  } catch (e) {}
}

restore_checkbox_status()

function store_checkbox_status() {
  const checked_checkbox_ids = Array.from(document.getElementsByClassName("food-item-checkbox"))
    .filter((checkbox) => checkbox.checked)
    .map((checkbox) => checkbox.id)

  let doc = JSON.stringify(checked_checkbox_ids)
  localStorage.setItem(checkbox_status_key, doc)
}

const food_reset_button = document.getElementById("clear-food-checkboxes");
food_reset_button.addEventListener("click", (e) => {
  document.forms.recipe.reset()
  store_checkbox_status()
})

document.forms.recipe.addEventListener("change", () => {
  store_checkbox_status()
})

function timer_end(timer, interval) {
  clearInterval(interval)
  new Notification(
    "scrabsha.github.io",
    {
      // TODO: Maybe write something more informative here?
      body: "Timer expired"
    }
  )

  timer.style.display = "inherit"
  const progress = document.getElementById(timer.attributes.food_timer_progress.value)
  progress.style.display = "none"

  const checkbox = document.getElementById(timer.attributes.checkbox_id.value)
  checkbox.checked = true
}

function update_progress(progress, remaining) {
  const h = Math.floor(remaining / 3600)
  remaining -= h * 3600
  const m = Math.floor(remaining / 60)
  remaining = remaining - m * 60
  const s = remaining

  function f(v) {
    return String(v).padStart(2, "0")
  }

  const segments = h === 0 ? [m, s] : [h, m, s]

  const content = segments.map((segment) => f(segment)).join(":")

  progress.innerHTML = content
}

async function run_timer(timer) {
  const notification_rslt = await Notification.requestPermission()

  if (notification_rslt !== "granted") {
    return
  }

  // Clicking on the item checked the checkbox, but we want it to be checked
  // only once the timer has completed. Uncheck it for now.
  const checkbox_id = timer.attributes.checkbox_id.value
  document.getElementById(checkbox_id).checked = false

  const duration = timer.attributes.food_timer_duration.value

  timer.style.display = "none"
  const progress = document.getElementById(timer.attributes.food_timer_progress.value)
  progress.style.display = "inherit"

  let remaining = duration

  remaining--
  update_progress(progress, remaining)
  const interval = setInterval(
    () => {
      remaining--
      update_progress(progress, remaining)
    },
    1000
  )

  const timeout = setTimeout(
    () => timer_end(timer, interval),
    duration * 1000
  )

  progress.addEventListener("click", () => {
    clearInterval(interval)
    clearTimeout(timeout)
    progress.style.display = "none"
    timer.style.display = "inherit"
  })
}

function setup_timer(timer) {
  timer.addEventListener("click", () => {
    run_timer(timer)
  })
}

const timers = document.getElementsByClassName("food-timer")
for (const timer of timers) {
  setup_timer(timer)
}
