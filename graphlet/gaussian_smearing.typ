#import "@preview/cetz:0.4.2" as cetz

#set page(width: auto, height: auto, margin: 1cm)

#let draw_gaussian_smearing() = {
  import cetz.draw: *
  let d_e = 8
  let r_cut = 5.0
  let sigma = r_cut / (d_e - 1)
  let test_d = 2.2
  let scale_y = 2.5 // y轴缩放
  let scale_x = 5.5 / r_cut // x轴缩放，将 [0, r_cut] 映射到 [0, 5.5]

  // 绘制高斯曲线的辅助函数（通过折线近似）
  let gauss(x, mu, sig) = calc.exp(
    -calc.pow(x - mu, 2) / (2 * calc.pow(sig, 2)),
  )

  // 绘制每条高斯基函数曲线
  for i in range(0, d_e) {
    let mu = i * sigma
    let steps = 60
    let x_lo = calc.max(0, mu - 2.5 * sigma)
    let x_hi = calc.min(r_cut, mu + 2.5 * sigma)
    let dx = (x_hi - x_lo) / steps

    let pts = range(0, steps + 1).map(k => {
      let x = x_lo + k * dx
      let y = gauss(x, mu, sigma)
      (x * scale_x, y * scale_y)
    })

    // 根据是否接近 test_d 选择颜色
    let g_val = gauss(test_d, mu, sigma)
    let clr = if g_val > 0.05 { blue.lighten(40%) } else { gray.lighten(30%) }
    line(..pts, stroke: (paint: clr, thickness: 1pt))

    // 标记均值 μ_k
    circle((mu * scale_x, 0), radius: 0.04, fill: black, stroke: none)
  }

  // 绘制坐标轴
  line((-0.15, 0), (6.2, 0), mark: (end: ">"), stroke: (thickness: 0.8pt))
  line((0, -0.15), (0, scale_y + 0.4), mark: (end: ">"), stroke: (thickness: 0.8pt))

  // 轴标签
  content((6.4, 0), [$d$], anchor: "west")
  content((0, scale_y + 0.6), [$"GS"(d)_k$], anchor: "south")

  // 合并 μ 与刻度标注，避免重叠
  content((0, -0.35), [$mu_1 = 0$], anchor: "north")
  content((r_cut * scale_x, -0.35), [$mu_(d_e) = r_"cut"$], anchor: "north")

  // 绘制输入距离竖线
  line(
    (test_d * scale_x, -0.2),
    (test_d * scale_x, scale_y + 0.15),
    stroke: (dash: "dashed", paint: red, thickness: 1pt),
  )
  content((test_d * scale_x, -0.35), text(fill: red)[$d$], anchor: "north")

  // 在每个基函数与 d 的交点画红点，并连线到右侧特征向量
  let vec_x0 = 7.0
  let vec_w = 0.7
  let vec_h = 0.38
  let vec_gap = 0.08

  for i in range(0, d_e) {
    let mu = i * sigma
    let val = gauss(test_d, mu, sigma)
    let py = val * scale_y

    // 交点红点
    circle((test_d * scale_x, py), radius: 0.07, fill: red, stroke: none)

    // 连接到右侧向量格子的虚线
    let vy_center = i * (vec_h + vec_gap) + vec_h / 2
    line(
      (test_d * scale_x, py),
      (vec_x0, vy_center),
      stroke: (paint: gray.lighten(20%), dash: "loosely-dotted", thickness: 0.5pt),
    )

    // 特征向量格子（颜色深浅表示值大小）
    let alpha = calc.max(0, calc.min(255, int(val * 220)))
    let fill_clr = color.rgb(255 - alpha, 255 - alpha, 255)
    rect(
      (vec_x0, i * (vec_h + vec_gap)),
      (vec_x0 + vec_w, i * (vec_h + vec_gap) + vec_h),
      fill: fill_clr,
      stroke: (paint: blue.lighten(20%), thickness: 0.5pt),
    )

    // 在格子内显示数值（保留两位小数）
    let val_str = str(calc.round(val, digits: 2))
    content(
      (vec_x0 + vec_w / 2, i * (vec_h + vec_gap) + vec_h / 2),
      text(size: 6.5pt)[#val_str],
      anchor: "center",
    )
  }

  // 右侧向量标注
  let total_h = d_e * (vec_h + vec_gap) - vec_gap
  content(
    (vec_x0 + vec_w / 2, total_h + 0.35),
    [$bold(D)_(i j) in RR^(d_e)$],
    anchor: "south",
  )
  content(
    (vec_x0 + vec_w / 2, -0.35),
    text(size: 8pt)[$d_e = #d_e$],
    anchor: "north",
  )
}

#let gaussian_smearing() = cetz.canvas({
  draw_gaussian_smearing()
})

#gaussian_smearing()
