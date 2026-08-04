#import "@preview/cetz:0.4.2"
#import "@local/paperkit:0.1.0" as paperkit
#import paperkit.word_count: *

#show: word-count-cjk

aaa bbb ccc 哈哈哈哈

总字数：#total-words

#cetz.canvas({
  import cetz.draw: *
  circle((0, 0), name: "c")
  fill(red)
  circle((v => cetz.vector.add(v, (0, -1)), "c.west"), radius: 0.3)
})
