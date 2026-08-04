#import "@preview/cetz:0.4.2"

#set page(width: auto, height: auto, margin: 0.5cm)

#let draw_scatter_softmax() = {
  import cetz.draw: *

  // ── 数据 ──────────────────────────────────────────────────────────────────
  let colors = (rgb("#b3e5fc"), rgb("#ffe0b2"), rgb("#dcedc8"), rgb("#f8bbd0"))
  let indices = (0, 0, 1, 0, 2, 2, 1, 2)
  let values = (2.1, 1.5, 0.5, 3.2, 1.1, 0.8, 2.5, 1.9)
  let n = indices.len()

  // ── 布局参数 ──────────────────────────────────────────────────────────────
  let box_w = 0.8 // 格子宽度
  let box_h = 0.6 // 格子高度
  let spacing = 1.0 // 列间距（格子左边缘）
  let y_index = 4.0 // index 行的底部 y
  let y_input = 2.8 // input 行的底部 y
  let y_op = 1.2 // operator 行的圆心 y
  let y_output = -0.6 // output 行的底部 y
  let label_x = -0.3 // 左侧行标签的 x（东锚点）
  let op_r = 0.42 // operator 圆半径

  // ── softmax 计算（按 group 分组） ─────────────────────────────────────────
  // 收集每个 group 的指数和
  let unique_groups = (0, 1, 2)
  let exp_sums = unique_groups.map(g => {
    let s = 0.0
    for (i, gi) in indices.enumerate() {
      if gi == g { s = s + calc.exp(values.at(i)) }
    }
    s
  })
  // 计算每个元素的 softmax 值，保留两位小数
  let results = range(n).map(i => {
    let g = indices.at(i)
    let val = calc.exp(values.at(i)) / exp_sums.at(g)
    // 手动四舍五入到两位小数
    let rounded = calc.round(val * 100) / 100
    str(rounded)
  })

  // ── 辅助：绘制带填充色的矩形格子 ─────────────────────────────────────────
  let draw_box(i, y_bot, label_content, box_name, fill_color) = {
    let x = i * spacing
    rect(
      (x, y_bot),
      (x + box_w, y_bot + box_h),
      fill: fill_color,
      stroke: 0.7pt + luma(120),
      name: box_name,
    )
    content(box_name, label_content)
  }

  // ── 1. Index 层 ───────────────────────────────────────────────────────────
  for (i, idx) in indices.enumerate() {
    draw_box(i, y_index, [#idx], "idx" + str(i), luma(235))
  }
  content((label_x, y_index + box_h / 2), [index], anchor: "east")

  // ── 2. Input 层（Logits） ─────────────────────────────────────────────────
  for (i, val) in values.enumerate() {
    let col = colors.at(indices.at(i))
    draw_box(i, y_input, [#val], "in" + str(i), col)
    line(
      "idx" + str(i) + ".south",
      "in" + str(i) + ".north",
      stroke: 0.5pt + gray,
      mark: (end: ">"),
    )
  }
  content((label_x, y_input + box_h / 2), [input ($x_i$)], anchor: "east")

  // ── 3. Operator 层（group-wise exp/sum） ──────────────────────────────────
  // 每个 operator 的 x 取其所属元素的 x 均值
  for g in unique_groups {
    let member_xs = range(n).filter(i => indices.at(i) == g).map(i => i * spacing + box_w / 2)
    let cx = member_xs.sum() / member_xs.len()

    circle((cx, y_op), radius: op_r, name: "op" + str(g), fill: white, stroke: 0.8pt + luma(100))
    content("op" + str(g), text(size: 6.5pt)[exp/sum])

    // Input → Operator
    for (i, gi) in indices.enumerate() {
      if gi == g {
        line(
          "in" + str(i) + ".south",
          "op" + str(g) + ".north",
          stroke: 0.5pt + gray,
          mark: (end: ">"),
        )
      }
    }
  }

  // ── 4. Output 层（softmax 结果） ──────────────────────────────────────────
  for (i, res) in results.enumerate() {
    let col = colors.at(indices.at(i))
    draw_box(i, y_output, text(size: 8pt)[#res], "out" + str(i), col)
    line(
      "op" + str(indices.at(i)) + ".south",
      "out" + str(i) + ".north",
      stroke: 0.5pt + gray,
      mark: (end: ">"),
    )
  }
  content((label_x, y_output + box_h / 2), [output ($sigma_i$)], anchor: "east")

  // ── 5. 公式标注 ───────────────────────────────────────────────────────────
  content(
    (n * spacing / 2 - box_w / 2, y_output - 0.9),
    $sigma_i = frac(exp(x_i), sum_(j in cal(N)(i)) exp(x_j))$,
    frame: "rect",
    padding: 4pt,
    stroke: none,
    fill: none,
  )
}

#let scatter_softmax() = cetz.canvas({
  draw_scatter_softmax()
})

#scatter_softmax()
