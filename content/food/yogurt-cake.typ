#import "/lib/main.typ" as lib
#import "/lib/food.typ" as food

#import food: scaled

#show: lib.page.with(
  title: food.title("Yogurt cake", [Yogurt cake]),
  additional-header: food.header,
)

#show: food.page.with()

Not sure about the name tbh, French is "gâteau au yaourt". It's a super easy cake that u can use as a base. Be creative, add more stuff in it!

= Ingredionts

For #food.base-amount-scale(3) eggs:
- #food.t45-flour[#scaled(200) g]
- #food.sugar[#scaled(100) g, though some of it is vanilla sugar :3]
- #food.baking-powder[#scaled(1) bag]
- Vegetal oil (#scaled(100) mL)
- Yogurt (#scaled(1))

= Steps

Add the ingredients in the following order while mixing:
- Eggs,
- Sugar
- Oil
- Yogurt
- Flour + baking powder

Then make it a cake:
- Put a thin layer of butter over a tin
- Pour the dough in the tin
- #food.timer-item(m: 30)[Bake at 180 °C for about 30 minutes]
