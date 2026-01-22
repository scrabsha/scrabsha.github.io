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

  food_button.addEventListener("click", () => {
    const checked = food_button.checked
    localStorage.setItem(storage_item_name, checked)
  })
}
