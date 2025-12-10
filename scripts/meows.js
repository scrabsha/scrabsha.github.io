const cat_toggle = document.getElementById("cat-toggle")

cat_toggle.checked = false

cat_toggle.addEventListener("click", (e) => {
  const display = cat_toggle.checked ? "inline" : "none"
  for (const elt of document.getElementsByClassName("meow")) {
    elt.style.display = display
  }
})
