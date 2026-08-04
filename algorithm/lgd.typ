#import "@preview/fletcher:0.5.8" as fletcher: *

#let LGD = diagram(
  node-stroke: 0.8pt,
  node-fill: white,
  edge-stroke: 0.8pt,
  spacing: (0.6cm, 0.5cm),
  // 定义节点
  node((1, 0), [$x_t$], shape: rect, name: "xt"),
  node((2, 1), [去噪器], shape: rect, name: "denoiser"),
  node((3, 1), [预测无条件分数], name: "pus"),
  node((3, 0), [后验均值], shape: rect, name: "pm"),
  node((4, 1), [$E[x_0|x_t]$], name: "ex0xt"),
  node((4, 2), [属性映射], shape: rect, name: "am"),
  node((5, 2), [条件 $y$], name: "cy"),
  node((4, 3), [条件损失函数], shape: rect, name: "closs"),
  node((3, 3), [预测的条件分数], name: "pcs"),
  node((3, 2), [$+$], shape: circle, name: "plus"),
  node((2, 2), [预测的分数], name: "ps"),
  node((2, 3), [采样器], shape: rect, name: "sampler"),
  node((1, 3), [$x_(t-1)$], shape: rect, name: "xt1"),

  // // 主要连接
  edge(<xt>, <denoiser>, "->", corner: right),
  edge(<denoiser>, <pus>, "->"),
  edge(<pus>, <pm>, "->"),
  edge(<xt>, <pm>, "->"),
  edge(<pm>, <ex0xt>, "->", corner: right),
  edge(<ex0xt>, <am>, "->"),
  edge(<am>, <closs>, "->"),
  edge(<cy>, <closs>, "->", corner: right),
  edge(<closs>, <pcs>, "->"),
  edge(<pcs>, <plus>, "->"),
  edge(<pus>, <plus>, "->"),
  edge(<plus>, <ps>, "->"),
  edge(<ps>, <sampler>, "->"),
  edge(<sampler>, <xt1>, "->"),
  edge(<xt1>, <xt>, "-->"),
)

#LGD
