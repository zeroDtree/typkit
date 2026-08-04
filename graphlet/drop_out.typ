#import "@preview/cetz:0.4.2"

#set page(width: auto, height: auto, margin: 1cm)

#let matrix_grid(name, rows, cols, dropout_type) = {
  cetz.canvas({
    import cetz.draw: *

    let cell_size = 0.5
    let title = ""

    // 绘制标题
    if dropout_type == "standard" { title = "Standard Dropout" } else if dropout_type == "row" {
      title = "Rowwise Dropout"
    } else if dropout_type == "col" { title = "Columnwise Dropout" }

    content((cols * cell_size / 2, 0.5), [*#title*])

    for r in range(rows) {
      for c in range(cols) {
        // 逻辑判断：决定该单元格是否被抹除 (变灰)
        let is_dropped = false

        if dropout_type == "standard" {
          // 模拟随机点状分布
          if calc.rem(r * 3 + c * 7, 5) == 0 { is_dropped = true }
        } else if dropout_type == "row" {
          // 模拟整行抹除 (假设第1行和第3行被丢弃)
          if r == 1 or r == 3 { is_dropped = true }
        } else if dropout_type == "col" {
          // 模拟整列抹除 (假设第0列和第2列被丢弃)
          if c == 0 or c == 2 { is_dropped = true }
        }

        let fill_color = if is_dropped { gray.lighten(50%) } else { blue.lighten(40%) }

        rect(
          (c * cell_size, -r * cell_size),
          ((c + 1) * cell_size, -(r + 1) * cell_size),
          fill: fill_color,
          stroke: white + 0.5pt,
        )
      }
    }
  })
}

#stack(
  dir: ltr,
  spacing: 2em,
  matrix_grid("m1", 5, 5, "standard"),
  matrix_grid("m2", 5, 5, "row"),
  matrix_grid("m3", 5, 5, "col"),
)
