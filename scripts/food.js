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
