#import "@preview/cetz:0.4.2": canvas, draw

#let relpos-viz(body, n: 5, k: 2) = canvas({
  import draw: *

  let s = 0.55 // 单元格大小
  let gap = 1.2 // 模块间距

  // 辅助函数：模拟 Python 的 argmin(abs(d - v))，即截断逻辑
  let get-bin-idx(diff, k) = calc.min(calc.max(diff, -k), k)

  let get-color(val) = {
    if val == 0 { white } else if val > 0 { orange.lighten(30%) } else { blue.lighten(30%) }
  }

  // --- 1. Difference Matrix d ---
  group(name: "dist-matrix", {
    for i in range(n) {
      for j in range(n) {
        let diff = i - j
        let mapped = get-bin-idx(diff, k)
        rect((j * s, -i * s), ((j + 1) * s, -(i + 1) * s), fill: get-color(mapped), stroke: gray.lighten(50%))
        content((j * s + s / 2, -i * s - s / 2), text(size: 5pt)[#diff])
      }
    }
    content((n * s / 2, 0.5), text(size: 8pt)[#body])
  })
})

#relpos-viz(n: 6, k: 2)[]
