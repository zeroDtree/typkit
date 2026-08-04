#import "@preview/cetz:0.4.2": canvas, draw
#import draw: circle, content, line, rect

#let atom(pos, element, color: white, text-color: black, padding: 6pt, name: none) = {
  // Calculate the radius based on padding to match the original size
  let radius = padding + 7pt // Approximation of text size + padding

  // Draw base circle with the main color
  circle(
    pos,
    radius: radius,
    stroke: none,
    fill: color,
  )

  // Draw gradient overlay for 3D shading effect
  circle(pos, radius: radius, stroke: none, fill: gradient.radial(
    color.lighten(75%),
    color,
    color.darken(15%),
    focal-center: (30%, 25%),
    focal-radius: 5%,
    center: (35%, 30%),
  ))

  // Draw the element text on top
  content(
    pos,
    text(fill: text-color, weight: "bold", size: 14pt)[#element],
    anchor: "center",
    name: name,
  )
}

#let small_mole(length: 5em, scale: 1) = {
  canvas(
    length: length,
    {
      // Define styles
      let arrow-style = (
        stroke: rgb("#888") + 5pt,
        mark: (end: "stealth", size: 15pt),
      )

      // Set vertical center point for all elements
      let vertical-center = 0

      // Define spacing constants
      let struct-desc-spacing = 2.5 // Closer spacing between structure and descriptor
      let model-prop-spacing = 2.5 // Closer spacing between model and property
      let component-spacing = 3.5 // Spacing between other components
      let label-offset = 4 // Vertical distance from components to labels
      let label-y = vertical-center - label-offset // Fixed y-position for all labels

      // Define vertical offsets
      let molecule-y-offset = 0.5 // Move molecule up
      let matrix-y-offset = 0.3 // Move matrix up

      // Define component positions
      let struct-x = -5.5
      let struct-y = vertical-center + molecule-y-offset
      let struct-origin = (struct-x, struct-y)

      // Draw molecular structure
      // Bonds first (so atoms appear on top)
      line(
        (rel: (1.5, -2.5), to: struct-origin),
        (rel: (0, -1.5), to: struct-origin),
        stroke: rgb("#888") + 3pt,
        name: "bond1",
      )
      line(
        (rel: (0, -1.5), to: struct-origin),
        struct-origin,
        stroke: rgb("#888") + 3pt,
        name: "bond2",
      )
      line(
        struct-origin,
        (rel: (-0.5, 1.5), to: struct-origin),
        stroke: rgb("#888") + 3pt,
        name: "bond3",
      )
      line(
        struct-origin,
        (rel: (1.8, 0.5), to: struct-origin),
        stroke: rgb("#888") + 3pt,
        name: "bond4",
      )
      line(
        (rel: (0, -3), to: struct-origin),
        (rel: (0, -1.5), to: struct-origin),
        stroke: rgb("#888") + 3pt,
        name: "bond5",
      )
      line(
        (rel: (-1.5, -2.5), to: struct-origin),
        (rel: (0, -1.5), to: struct-origin),
        stroke: rgb("#888") + 3pt,
        name: "bond6",
      )
      line(
        (rel: (-0.5, 1.5), to: struct-origin),
        (rel: (-2, 0.75), to: struct-origin),
        stroke: rgb("#888") + 3pt,
        name: "bond7",
      )
      line(
        (rel: (-0.5, 1.5), to: struct-origin),
        (rel: (1, 2), to: struct-origin),
        stroke: rgb("#888") + 3pt,
        name: "bond8",
      )

      // Now draw atoms on top of bonds - with increased size
      // Carbon atoms
      atom(struct-origin, "C", color: rgb("#404040"), text-color: white, name: "C1", padding: 5pt * scale)
      atom(
        (rel: (0, -1.5), to: struct-origin),
        "C",
        color: rgb("#404040"),
        text-color: white,
        name: "C2",
        padding: 5pt * scale,
      )

      // Nitrogen atom
      atom((rel: (-0.5, 1.5), to: struct-origin), "N", color: rgb("#4444ff"), name: "N1", padding: 6pt * scale)

      // Oxygen atom
      atom((rel: (1.8, 0.5), to: struct-origin), "O", color: rgb("#ff4444"), name: "O1", padding: 7pt * scale)

      // Hydrogen atoms
      atom((rel: (1.5, -2.5), to: struct-origin), "H", color: white, padding: 2pt * scale, name: "H1")
      atom((rel: (0, -3), to: struct-origin), "H", color: white, padding: 2pt * scale, name: "H2")
      atom((rel: (-1.5, -2.5), to: struct-origin), "H", color: white, padding: 2pt * scale, name: "H3")
      atom((rel: (-2, 0.75), to: struct-origin), "H", color: white, padding: 2pt * scale, name: "H4")
      atom((rel: (1, 2), to: struct-origin), "H", color: white, padding: 2pt * scale, name: "H5")
    },
  )
}

#small_mole(length: 2em)

// Atom with 3D shading effect
#let atom(pos, color, element, radius: 0.3, name: none) = {
  import draw: circle, content, line, on-layer
  // Base circle with main color
  circle(
    pos,
    radius: radius,
    stroke: none,
    fill: color,
    name: name,
  )

  // Gradient overlay for 3D effect
  circle(pos, radius: radius, stroke: none, fill: gradient.radial(
    color.lighten(85%),
    color,
    color.darken(25%),
    focal-center: (25%, 20%),
    focal-radius: 10%,
    center: (30%, 25%),
  ))

  // Add element label
  let text-color = if color == rgb("#333333") { white } else { black }

  // Calculate text size based on radius
  let text-size = if radius < 0.4 { 10pt } else { 14pt }

  content(
    pos,
    text(fill: text-color, weight: "bold", size: text-size)[#element],
    anchor: "center",
  )
}

#let organic_molecule() = canvas({
  import draw: circle, content, line, on-layer
  // Define atom colors
  let hydrogen-color = rgb("#eee")
  let carbon-color = rgb("#333")
  let nitrogen-color = rgb("#3333cc")
  let oxygen-color = red.darken(10%)

  // Define atom sizes - increased to match target image
  let h-radius = 0.35
  let heavy-radius = 0.5

  // Adjust hydrogen positions to be further from connected atoms
  // Original positions from LaTeX
  let orig-h-positions = (
    ("H1", (-2.9, 1.39)),
    ("H2", (-3.5, 1.23)),
    ("H3", (-3.8, 0.15)),
    ("H4", (-1.7, -0.6)),
    ("H5", (-0.3, 1.4)),
    ("H6", (-1, 1.15)),
    ("H7", (0, -0.7)),
    ("H8", (1, -1.82)),
    ("H9", (0.2, -1.8)),
    ("H10", (3.5, 0.5)),
  )

  // Heavy atom positions
  let c-positions = (
    ("C1", (-3.19, 0.68)),
    ("C2", (-0.78, 0.67)),
    ("C3", (0.47, -0.18)),
    ("C4", (1.73, 0.67)),
  )

  let n-positions = (
    ("N1", (-2.00, -0.15)),
    ("N2", (0.51, -1.32)),
  )

  let o-positions = (
    ("O1", (1.80, 1.88)),
    ("O2", (2.86, -0.07)),
  )

  // Function to move hydrogen atoms further from their connected atoms
  let adjust-h-position(h-pos, connected-pos, factor: 1.5) = {
    let (hx, hy) = h-pos
    let (cx, cy) = connected-pos
    let dx = hx - cx
    let dy = hy - cy
    let dist = calc.sqrt(dx * dx + dy * dy)
    let new-dist = dist * factor
    let scale = new-dist / dist
    (cx + dx * scale, cy + dy * scale)
  }

  // Connection map: which hydrogen connects to which heavy atom
  let h-connections = (
    "H1": "C1",
    "H2": "C1",
    "H3": "C1",
    "H4": "N1",
    "H5": "C2",
    "H6": "C2",
    "H7": "C3",
    "H8": "N2",
    "H9": "N2",
    "H10": "O2",
  )

  // Combine all heavy atom positions for lookup
  let heavy-atoms = (:)
  for (name, pos) in c-positions { heavy-atoms.insert(name, pos) }
  for (name, pos) in n-positions { heavy-atoms.insert(name, pos) }
  for (name, pos) in o-positions { heavy-atoms.insert(name, pos) }

  // Adjust hydrogen positions
  let h-positions = (:)
  for (name, pos) in orig-h-positions {
    let connected-atom = h-connections.at(name)
    let connected-pos = heavy-atoms.at(connected-atom)
    h-positions.insert(name, adjust-h-position(pos, connected-pos))
  }

  // Further adjust overlapping hydrogens
  // Adjust H1 and H2 which overlap in the top left
  let h1-pos = h-positions.at("H1")
  let h2-pos = h-positions.at("H2")
  h-positions.insert("H1", (h1-pos.at(0) - 0.2, h1-pos.at(1) + 0.2))
  h-positions.insert("H2", (h2-pos.at(0) - 0.2, h2-pos.at(1) - 0.2))

  // Adjust H8 and H9 which overlap near the right N atom
  let h8-pos = h-positions.at("H8")
  let h9-pos = h-positions.at("H9")
  h-positions.insert("H8", (h8-pos.at(0) + 0.3, h8-pos.at(1) - 0.2))
  h-positions.insert("H9", (h9-pos.at(0) - 0.3, h9-pos.at(1) - 0.2))

  // Draw all atoms
  // Draw carbon atoms
  for (name, pos) in c-positions {
    atom(pos, carbon-color, "C", radius: heavy-radius, name: name)
  }

  // Draw nitrogen atoms
  for (name, pos) in n-positions {
    atom(pos, nitrogen-color, "N", radius: heavy-radius, name: name)
  }

  // Draw oxygen atoms
  for (name, pos) in o-positions {
    atom(pos, oxygen-color, "O", radius: heavy-radius, name: name)
  }

  // Draw hydrogen atoms
  for (name, pos) in h-positions {
    atom(pos, hydrogen-color, "H", radius: h-radius, name: name)
  }

  // Draw bonds on a background layer (behind atoms)
  on-layer(-1, {
    // Main chain
    let bond-chain = ("H1", "C1", "N1", "C2", "C3", "C4", "O1")
    for i in range(bond-chain.len() - 1) {
      let from = bond-chain.at(i)
      let to = bond-chain.at(i + 1)

      let from-pos = if from.starts-with("H") {
        h-positions.at(from)
      } else {
        heavy-atoms.at(from)
      }

      let to-pos = if to.starts-with("H") {
        h-positions.at(to)
      } else {
        heavy-atoms.at(to)
      }

      line(from-pos, to-pos, stroke: (paint: gray, thickness: 3.5pt))
    }

    // Additional bonds
    let additional-bonds = (
      ("H2", "C1"),
      ("H3", "C1"),
      ("N1", "H4"),
      ("C2", "H5"),
      ("C2", "H6"),
      ("C3", "H7"),
      ("C3", "N2"),
      ("N2", "H8"),
      ("N2", "H9"),
      ("C4", "O2"),
      ("O2", "H10"),
    )

    for (from, to) in additional-bonds {
      let from-pos = if from.starts-with("H") {
        h-positions.at(from)
      } else {
        heavy-atoms.at(from)
      }

      let to-pos = if to.starts-with("H") {
        h-positions.at(to)
      } else {
        heavy-atoms.at(to)
      }

      line(from-pos, to-pos, stroke: (paint: gray, thickness: 3.5pt))
    }
  })
})


#organic_molecule()
