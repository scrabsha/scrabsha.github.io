const language_buttons = document.getElementsByName("product-names-language")
const available_languages = Array.from(language_buttons).map(
  (element) => element.value.split("-").at(-1)
)

function update_products(lang) {
  for (const lang_ of available_languages) {
    const display = (lang_ === lang) ? "inherit" : "none"
    const elts = document.getElementsByClassName(`product-${lang_}`)
    for (const elt of elts) {
      elt.style.display = display
    }
  }
}

for (const lang of available_languages) {
  const radio_button = document.getElementById(`product-names-${lang}`)

  if (radio_button.checked) {
    update_products(lang)
  }

  radio_button.addEventListener("change", (e) => {
    update_products(lang)
  })
}

function store_checkbox_status(elt) {
  const storage_item_name = `${location.href}-${elt.id}`
  localStorage.setItem(storage_item_name, elt.checked === 'true')
}

const food_reset_button = document.getElementById("clear-food-checkboxes");
food_reset_button.addEventListener("click", (e) => {
  const checkboxes = document.getElementsByClassName("food-item-checkbox")
  for (const checkbox of checkboxes) {
    checkbox.checked = false
    store_checkbox_status(checkbox)
  }
})

const food_buttons = document.getElementsByClassName("food-item-checkbox")
for (const food_button of food_buttons) {
  const storage_item_name = `${location.href}-${food_button.id}`
  const checked = localStorage.getItem(storage_item_name)
  food_button.checked = checked === 'true'

  food_button.addEventListener("click", (e) => {
    const checked = food_button.checked
    localStorage.setItem(storage_item_name, checked)
  })
}
