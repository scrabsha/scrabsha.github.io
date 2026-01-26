#import "/lib/main.typ" as lib
#import "/lib/food.typ" as food

#import food: scaled

#show: lib.page.with(
  title: food.title("Croissants", [Croissants]),
  additional-header: food.header,
)

#show: food.page.with()

Definitely not French-boulangerie-grade, but certainly good enough for when I'm abroad.

= Ingredients

For #food.base-amount-scale(1000) g of dough:

- #food.t45-flour[#scaled(500) g]
- Butter (#scaled(180) g)
- #food.fresh-yeast[#scaled(25) g]
- Sugar (#scaled(50) g)
- Salt (#scaled(10) g)
- #food.milk[#scaled(28) cL]
- Water (#scaled(2) tablespoons)
- Egg (#scaled(1))

= Steps

- Mix the yeast in the lukewarm water
- In a bowl, mix the flour, the salt and the sugar
- Make a well in the mix, then slowly incorporate the milk
- Once the milk is fully incorporated, add the yeast
#food.timer-item(m: 15)[Knead the dough for 15 minutes]
- Get the butter out of the fridge so that it is soft when needed
#food.timer-item(h: 2)[Let the dough rest for two hours in a covered bowl]
- Spread the dough as thin as possible, aiming for a rectangle
- Spread the butter over a quarter of the dough in a corner
- Fold the dough in four
- Fold again such that the face that has three layers of dough is on the outside
- Carefully spread the layered dough (avoid breaking the dough and revealing the butter that's underneath), then fold it again
- Repeat the previous step as many times as possible. If a hole forms, put some flower on the butter that's underneath so it does not stick
- Cut triangles of dough, ideally isosceles and acute
- Roll them and put them on a baking tray
#food.timer-item(h: 2)[Let the croissants rest for two hours]
- Preheat the oven at 240 °C
- Using a brush, spread the egg over the croissants
#food.timer-item(m: 5)[Bake for 5 minutes at 240 °C]
#food.timer-item(m: 10)[Bake for 10-15 minutes at 160-170 °C]
