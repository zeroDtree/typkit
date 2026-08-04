#import "@preview/cetz:0.4.2": canvas, draw
#import "@preview/suiji:0.5.1": *


#let draw_tensor_block(
  pos,
  body,
  base_color: blue,
  n-h: 4,
  n-w: 6,
  w: 1.2,
  h: 0.8,
  length_scale: none,
  random-seed: 42,
  lighten_factor: 90%,
  text-align: center,
  randomize: true,
) = {
  let w = if length_scale != none { n-w * length_scale } else { w }
  let h = if length_scale != none { n-h * length_scale } else { h }
  let (x, y) = pos
  let rng = gen-rng-f(random-seed)
  let val
  let cell_color
  let rows = n-h
  let cols = n-w

  draw.group({
    // 1. 绘制底层阴影 (简单位移)
    draw.rect((x + 0.05, y - 0.05), (x + w + 0.05, y + h - 0.05), fill: gray.lighten(50%), stroke: none)

    // 2. 绘制主体色块网格
    for i in range(rows) {
      for j in range(cols) {
        let x1 = x + (j / cols) * w
        let y1 = y + (i / rows) * h
        let x2 = x + ((j + 1) / cols) * w
        let y2 = y + ((i + 1) / rows) * h

        // 随机轻微改变颜色深度，模拟数据感
        (rng, val) = uniform-f(rng, low: 0.0, high: 1.0)
        if randomize {
          cell_color = base_color.lighten(val * lighten_factor)
        } else {
          cell_color = base_color
        }
        draw.rect((x1, y1), (x2, y2), fill: cell_color, stroke: white + 0.2pt)
      }
    }
    // 3. 绘制外边框
    draw.rect((x, y), (x + w, y + h), stroke: 0.5pt + gray)

    // 4. 添加文字标签
    draw.content((x + w / 2, y + h / 2), [
      #set align(text-align)
      #body
    ])
  })
}

#canvas({
  import draw: *

  // 绘制紫色张量 (extra_msa_feat)
  draw_tensor_block((10, 4), base_color: purple.lighten(60%), n-h: 4, n-w: 6, w: 3, h: 2)[haha]
  // --- 左侧：输入特征 (Input Features) ---

  // 紫色：extra_msa_feat
  draw_tensor_block((0, 8), base_color: purple.lighten(60%), random-seed: 1, w: 2.5, h: 1.5)[
    *extra_msa_feat* \ ($s_e, r, f_e$)
  ]

  // 浅蓝色：target_feat (长条形)
  draw_tensor_block((0, 6), base_color: blue.lighten(70%), random-seed: 2, w: 2.5, h: 0.6)[
    *target_feat* ($r, f$)
  ]

  // 深紫色：msa_feat
  draw_tensor_block((0, 11), base_color: purple.lighten(40%), random-seed: 3, w: 2.5, h: 1.5)[
    *msa_feat* \ ($s_c, r, f_c$)
  ]

  // --- 中间：表现层 (Representations) ---

  // 红色：extra MSA representation
  draw_tensor_block((6, 8.5), base_color: red.lighten(60%), random-seed: 4, w: 2.2, h: 1.2)[
    extra MSA \ rep.
  ]

  // 蓝色：pair representation (正方形网格感)
  draw_tensor_block((6, 5), base_color: blue.lighten(60%), random-seed: 5, n-h: 8, n-w: 8, w: 2, h: 2)[
    *pair rep.* \ ($r, r, c_z$)
  ]

  // 红色：MSA representation
  draw_tensor_block((6, 2.5), base_color: red.lighten(60%), random-seed: 6, w: 2.2, h: 1.2)[
    MSA \ rep.
  ]

  // --- 下方：模板特征 (叠加效果) ---

  // 绿色：template_pair_feat (层叠展示)
  draw_tensor_block((0, 0), base_color: green.lighten(20%), random-seed: 7, w: 3, h: 2)[]
  draw_tensor_block((0.15, 0.15), base_color: green.lighten(20%), random-seed: 8, w: 3, h: 2)[
    *template_pair_feat* \ ($s_t, r, r, f_p$)
  ]
})

#let tensor(
  pos,
  body,
  base_color: blue,
  n-h: 4,
  n-w: 6,
  w: 1.2,
  h: 0.8,
  length_scale: none,
  random-seed: 42,
  lighten_factor: 90%,
  text-align: center,
  randomize: true,
) = {
  canvas({
    import draw: *
    draw_tensor_block(
      pos,
      base_color: base_color,
      n-h: n-h,
      n-w: n-w,
      w: w,
      h: h,
      length_scale: length_scale,
      random-seed: random-seed,
      lighten_factor: lighten_factor,
      text-align: text-align,
      randomize: randomize,
    )[
      #body
    ]
  })
}

#let index_tensor(body, base_color: yellow, n-h: 1, n-w: 6, w: 3, h: 0.5, ..args) = canvas({
  import draw: *
  draw_tensor_block((0, 0), base_color: base_color, n-h: 1, n-w: 6, w: 3, h: 0.5, ..args)[
    #body
  ]
})

#index_tensor()[position_index]


#let pair_tensor_operation(
  n: 5,
  box_size: 0.5,
  body1: none,
  body2: none,
  body3: none,
  color1: orange.lighten(20%),
  color2: orange.lighten(20%),
  color3: orange.lighten(20%),
) = canvas({
  import draw: *

  let vec_w = n * box_size // 3.0：向量宽度 / 矩阵边长

  // 1. 水平向量 p_j (1 × N)
  group({
    translate((1.2, 3.2))
    draw_tensor_block(
      (0, 0),
      base_color: color1,
      n-h: 1,
      n-w: n,
      w: vec_w,
      h: box_size,
      randomize: true,
    )[#body1]
    for i in range(n) {
      line(
        ((i + 0.5) * box_size, -0.1),
        ((i + 0.5) * box_size, -0.6),
        mark: (end: "stealth"),
        stroke: gray + 0.5pt,
      )
    }
  })

  // 2. 垂直向量 p_i (N × 1)
  group({
    translate((0, 0))
    draw_tensor_block(
      (0, 0),
      base_color: color2,
      n-h: n,
      n-w: 1,
      w: box_size,
      h: vec_w,
      randomize: true,
    )[#body2]
    for i in range(n) {
      let y = (n - 1 - i) * box_size
      line(
        (box_size + 0.1, y + 0.5 * box_size),
        (1.1, y + 0.5 * box_size),
        mark: (end: "stealth", size: 0.1),
        stroke: gray + 0.5pt,
      )
    }
  })

  // 3. 结果矩阵 p (N × N)
  group({
    translate((1.2, 0))
    draw_tensor_block(
      (0, 0),
      base_color: color3,
      n-h: n,
      n-w: n,
      w: vec_w,
      h: vec_w,
      lighten_factor: 90%,
    )[#body3]
  })
})


#pair_tensor_operation(body1: rotate(0deg)[$p_j$], body2: rotate(-90deg)[$p_i$], body3: rotate(0deg)[$p$])

#let draw_mask_tensor(
  pos,
  body: none,
  w: 1.2,
  h: 0.8,
  n-h: 4,
  n-w: 6,
  length_scale: none,
  mask_prob: 0.5, // 被屏蔽（变成0）的概率
  seed: 42,
  show_values: true, // 是否在格子里显示 0 和 1
) = {
  let rows = n-h
  let cols = n-w
  let w = if length_scale != none { cols * length_scale } else { w }
  let h = if length_scale != none { rows * length_scale } else { h }
  let (x, y) = pos
  let rng = gen-rng-f(seed)
  let val

  draw.group({
    for i in range(rows) {
      for j in range(cols) {
        let x1 = x + (j / cols) * w
        let y1 = y + (i / rows) * h
        let x2 = x + ((j + 1) / cols) * w
        let y2 = y + ((i + 1) / rows) * h

        (rng, val) = uniform-f(rng)

        // 判定逻辑：小于概率则为 Mask (0)，否则为 Active (1)
        let is_masked = val < mask_prob
        let cell_color = if is_masked { gray.darken(0%) } else { white }
        let text_color = if is_masked { white.darken(0%) } else { gray }

        // 绘制格子
        draw.rect((x1, y1), (x2, y2), fill: cell_color, stroke: gray + 0.2pt)

        // 绘制 0/1 文本
        if show_values {
          draw.content(
            ((x1 + x2) / 2, (y1 + y2) / 2),
            text(size: 4pt, fill: text_color)[#(if is_masked { "0" } else { "1" })],
          )
        }
      }
    }

    // 整体外边框
    draw.rect((x, y), (x + w, y + h), stroke: 1pt + black)

    // 标签
    draw.content((x + w / 2, y + h / 2), text(size: 8pt, weight: "bold")[#body])
  })
}

#let mask_tensor(
  pos,
  body,
  n-h: 4,
  n-w: 6,
  w: 1.2,
  h: 0.8,
  length_scale: none,
  mask_prob: 0.5, // 被屏蔽（变成0）的概率
  seed: 42,
  show_values: true, // 是否在格子里显示 0 和 1
) = {
  canvas({
    import draw: *
    draw_mask_tensor(
      pos,
      body: body,
      w: w,
      h: h,
      n-h: n-h,
      n-w: n-w,
      length_scale: length_scale,
      mask_prob: mask_prob,
      seed: seed,
    )
  })
}

#mask_tensor((0, 0), w: 3, h: 2, n-h: 4, n-w: 6, mask_prob: 0.5, seed: 42, show_values: false)[#text(
  fill: blue,
)[mask tensor]]


#import "@preview/cetz:0.4.2": canvas, draw

#let draw_tensor_3d(
  pos,
  body,
  n-h: 6, // 第一维 (Height)
  n-w: 4, // 第二维 (14 in your case, Width)
  n-d: 3, // 第三维 (Depth)
  w: 3.0, // 整体宽度
  h: 2.0, // 整体高度
  depth_scale: 0.5, // 深度缩放比例
  length_scale: none,
  base_color: blue,
  label-w: none,
  label-h: none,
  label-d: none,
) = {
  let w = if length_scale != none { n-w * length_scale } else { w }
  let h = if length_scale != none { n-h * length_scale } else { h }

  let (x, y) = pos
  let dx = depth_scale
  let dy = depth_scale
  let n = n-h
  let m = n-w
  let d = n-d

  draw.group({
    // 1. 绘制侧面 (Right Side) - 代表维度 d
    draw.line(
      (x + w, y),
      (x + w + dx, y + dy),
      (x + w + dx, y + h + dy),
      (x + w, y + h),
      close: true,
      fill: base_color.darken(20%),
      stroke: white + 0.2pt,
    )

    // 2. 绘制顶面 (Top Side)
    draw.line(
      (x, y + h),
      (x + dx, y + h + dy),
      (x + w + dx, y + h + dy),
      (x + w, y + h),
      close: true,
      fill: base_color.lighten(40%),
      stroke: white + 0.2pt,
    )


    // 3. 绘制正面 (Front Face) - 划分 n x 14 网格
    for i in range(n) {
      for j in range(m) {
        let x1 = x + (j / m) * w
        let y1 = y + (i / n) * h
        let x2 = x + ((j + 1) / m) * w
        let y2 = y + ((i + 1) / n) * h

        // 正面格子的随机感
        let cell_color = base_color.lighten(calc.rem(i * j, 3) * 20%)
        draw.rect((x1, y1), (x2, y2), fill: cell_color, stroke: white + 0.1pt)
      }
    }

    // 4. 辅助线：在侧面绘制一些线条表示深度方向的切片 (d)
    for k in range(1, d + 1) {
      let step_x = (k / d) * dx
      let step_y = (k / d) * dy
      draw.line((x + w + step_x, y + step_y), (x + w + step_x, y + h + step_y), stroke: white + 0.2pt)
      draw.line((x + step_x, y + h + step_y), (x + w + step_x, y + h + step_y), stroke: white + 0.2pt)
    }

    // 5. 标注维度
    // n (Height)
    draw.content((x - 0.5, y + h / 2), [#label-h], angle: 0deg)
    // 14 (Width)
    draw.content((x + w / 2, y - 0.3), [#label-w])
    // d (Depth)
    draw.content((x + w + dx + 0.3, y + dy / 2 + h / 2), [#label-d])

    // 中心标签
    draw.content((x + w / 2, y + h / 2), [#body])
  })
}

#let tensor_3d(
  pos,
  body,
  n-h: 6, // 第一维 (Height)
  n-w: 4, // 第二维 (14 in your case, Width)
  n-d: 3, // 第三维 (Depth)
  w: 3.0, // 整体宽度
  h: 2.0, // 整体高度
  depth_scale: 0.5, // 深度缩放比例
  length_scale: none,
  base_color: blue,
  label-w: none,
  label-h: none,
  label-d: none,
) = {
  canvas({
    import draw: *
    draw_tensor_3d(
      pos,
      n-h: n-h,
      n-w: n-w,
      n-d: n-d,
      w: w,
      h: h,
      depth_scale: depth_scale,
      length_scale: length_scale,
      base_color: base_color,
      label-w: label-w,
      label-h: label-h,
      label-d: label-d,
    )[#body]
  })
}


// 示例：绘制 (n, 14, d) 张量
#tensor_3d(
  (0, 0),
  n-h: 8,
  n-w: 14,
  n-d: 5,
  w: 4,
  h: 2.5,
  base_color: orange,
  label-w: "14",
  label-h: "n",
  label-d: "ddd",
)[haha]

// 也可以并排画另一个
#tensor_3d(
  (7, 0),
  n-h: 8,
  n-w: 14,
  n-d: 3,
  w: 4,
  h: 2.5,
  base_color: blue.lighten(20%),
  label-w: "14",
  label-h: "n",
  label-d: "d",
)[xixi]
