#import "/lib/main.typ" as lib
#import "/lib/food.typ" as food

#import food: scaled

#show: lib.page.with(
  title: food.title("Ragù", [Ragù]),
  additional-header: food.header,
)

#show: food.page.with()

No remoteworkster should ever have no ragù in their fridge. Let's fix that.

= Ingredients

#let meat = food.item(
  [Minced beef, optionally with some pork],
  [about #scaled(1000) g],
  fr: [bœuf haché],
  it: [macinato, metà manzo metà maiale],
  nl: [gehakt],
)

For #food.base-amount-scale(1000) g of meat:

- Half an onion (about #scaled(60) g)
- Celery (about #scaled(60) g)
- Half a carrot (about #scaled(60) g)
- Olive oil (about #scaled(140) g)
- #meat
- Tomato sauce _Mutti passata_ (#scaled(1600) g)
- Water
- #[
    #html.span(class: "product fr")[Chocolate (about 4 squares)]
    #html.span(class: "product it nl", style: "visibility: hidden")[-]
  ]
- Salt

= Steps

- Dice the onion, celery and carrot - the smaller the dices are the better
#food.timer-item(m: 5)[Fry the onion, celery and carrot in the olive oil in a large pot for about 5 minutes]
- Add the meat, stir continuously until no piece of meat is red
- Add the tomato sauce, mix until it is all homogenous
- Once the mix starts boiling, reduce the heat to the minimum and cover the pot with a lid
#food.timer-item(h: 3)[Let it cook for 3 hours, mix every once in a while]
- #[
    #html.span(class: "product fr")[Add the chocolate]
    #html.span(
      class: "product it",
    )[Do NOT add any chocolate. Your Italian partner would not like it and she'd get you jailed by the carabinieri 🤌]
    #html.span(class: "product nl")[Why would you add chocolate? Your Dutch partner doesn't like chocolate :/]
  ]

= Storing

Ikea KORKEN 0.5 L rocks! Half a KORKEN is a 2 people meal.

= About the water

The goal is to add enough water in the pot such that the volume of ragù + water you have after three hours of boiling is the same as the volume of ragù you had at the beginning. It all depends on how much you can reduce the power.

From my experience, gas stove requires one cup of water wherease vitro ceramic requires almost none.
