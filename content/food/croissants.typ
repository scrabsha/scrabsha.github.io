#import "/lib/main.typ" as lib
#import "/lib/food.typ" as food

#show: lib.page.with(
  title: food.title("Croissants", [Croissants]),
  additional-header: food.header,
)

#show: food.page.with()

Definitely not French-boulangerie-grade, but certainly good enough for when I'm abroad.

= Ingredients

- #food.t45-flour[500 g]
- Butter (180 g)
- #food.fresh-yeast[15 g]
- Sugar (50 g)
- Salt (10 g)
- #food.milk[28 cL]
- Water (two tablespoons)
- Egg (1)

= Steps

- Mix the yeast in the lukewarm water
- In a bowl, mix the flour, the salt and the sugar
- Make a well in the mix, then slowly incorporate the milk
- Once the milk is fully incorporated, add the yeast
#food.timer-item(m: 15)[Knead the dough for 15 minutes]
#food.timer-item(h: 2)[Let it rest for two hours in a covered bowl]
- Spread the dough as thin as possible
- Spread the butter on a corner
- Fold the dough over the butter
- Carefully spread again, then fold again, and so on
- Cut triangles of dough, roll them and put them on a baking tray
#food.timer-item(h: 2)[Let the croissants rest for two hours]
- Preheat the oven at 240 °C
- Using a brush, spread the egg over the croissants
#food.timer-item(m: 5)[Bake for 5 minutes at 240 °C]
#food.timer-item(m: 10)[Bake for 10 - 15 minutes at 160-170 °C]
