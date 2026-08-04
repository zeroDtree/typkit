#let one_level_el(it) = {
  let idx = 1
  for c in it.children {
    [
      #par(first-line-indent: 2em)[
        (#idx). #c.body
      ]
    ]
    idx += 1
  }
}
#let one_level_ul(it) = {
  let idx = 1
  for c in it.children {
    [
      #par(first-line-indent: 2em)[
        #it.marker.at(0) #c.body
      ]
    ]
    idx += 1
  }
}

#show list: one_level_ul
#show enum: one_level_el

#lorem(30)
- #lorem(40)
- #lorem(40)
#lorem(50)

#lorem(30)
+ #lorem(40)
+ #lorem(40)
#lorem(50)
