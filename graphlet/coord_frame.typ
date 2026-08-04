#import "@preview/cetz:0.4.1"

#set page(width: auto, height: auto, margin: 1cm)

#let draw_local-frame(pos, angle, label-text: none) = {
  import cetz.draw: *

  group({
    translate(pos)
    rotate(angle)
    // 移动并旋转到残基所在的局部坐标系
    // 设置箭头样式
    let arrow-style = (end: "stealth", fill: none)

    // 绘制三个正交基向量箭头 (RGB 对应 XYZ)
    line((0, 0), (0.7, 0), mark: arrow-style, stroke: red + 2pt) // X轴
    line((0, 0), (0, 0.7), mark: arrow-style, stroke: green + 2pt) // Y轴
    // Z轴使用斜向投影模拟 3D 效果
    line((0, 0), (-0.3, -0.3), mark: arrow-style, stroke: blue + 2pt)

    // 绘制核心节点 (C-alpha)
    circle((0, 0), radius: 0.08, fill: gray.darken(50%), stroke: white + 0.5pt)

    // 标注文字（稍微偏离中心以免遮挡箭头）
    if label-text != none {
      content((0.3, 0.3), text(size: 7pt, weight: "bold", font: "New Computer Modern")[#label-text])
    }
  })
}

#let coord_frame(data) = {
  cetz.canvas({
    import cetz.draw: *

    // 设置缩放
    scale(1.5)

    // 2. 绘制骨架连线 (灰色线条)
    // for i in range(data.len() - 1) {
    //   let p1 = (data.at(i).at(0), data.at(i).at(1))
    //   let p2 = (data.at(i + 1).at(0), data.at(i + 1).at(1))
    //   line(p1, p2, stroke: (paint: gray.lighten(50%), thickness: 1pt))
    // }

    // 3. 循环绘制每个残基的坐标系
    for item in data {
      draw_local-frame(
        (item.at(0), item.at(1)),
        item.at(2),
        label-text: item.at(3),
      )
    }
  })
}

#coord_frame((
  (0, 0, 30deg, "1"),
  (1.5, 0.5, 15deg, none),
  (2.8, -0.2, 60deg, "6"),
  (3.5, 1.2, 120deg, none),
  (3.0, 2.5, 200deg, "11"),
  (1.2, 3.0, 45deg, "16"),
  (-1.0, 2.8, 80deg, "21"),
  (-2.5, 3.5, 10deg, "26"),
))
