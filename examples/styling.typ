#import "../lib.typ": bdd, low, high

= Custom Styling Examples

You can customize the appearance of your BDDs beyond themes.

== Custom Node Colors

Override specific style properties:

#bdd(
  nodes: (
    (id: "x", label: $x$),
    (id: "y", label: $y$),
    (id: "0", terminal: false),
    (id: "1", terminal: true),
  ),
  edges: (
    ("x", "0", low),
    ("x", "y", high),
    ("y", "0", low),
    ("y", "1", high),
  ),
  style: (
    decision: (
      fill: rgb("#FFE082"),
      stroke: rgb("#F57C00") + 2pt,
      radius: 0.5,
      text-size: 12pt,
    )
  )
)

== Custom Edge Styles

Customize edge appearance:

#bdd(
  nodes: (
    (id: "a", label: $a$),
    (id: "b", label: $b$),
    (id: "0", terminal: false),
    (id: "1", terminal: true),
  ),
  edges: (
    ("a", "0", low),
    ("a", "b", high),
    ("b", "0", low),
    ("b", "1", high),
  ),
  style: (
    edge: (
      low: (
        stroke: rgb("#E91E63") + 2pt,
        dash: "densely-dotted",
      ),
      high: (
        stroke: rgb("#2196F3") + 2pt,
        mark: (end: "stealth", fill: rgb("#2196F3")),
      ),
    )
  )
)

== Custom Terminal Nodes

Style terminal nodes differently:

#bdd(
  nodes: (
    (id: "x", label: $x$),
    (id: "0", terminal: false),
    (id: "1", terminal: true),
  ),
  edges: (
    ("x", "0", low),
    ("x", "1", high),
  ),
  style: (
    terminal: (
      false: (
        fill: rgb("#FFCDD2"),
        stroke: rgb("#D32F2F") + 2.5pt,
        width: 0.7,
        height: 0.5,
        text-size: 14pt,
      ),
      true: (
        fill: rgb("#4CAF50"),
        stroke: rgb("#1B5E20") + 2.5pt,
        width: 0.7,
        height: 0.5,
        text-size: 14pt,
        text-fill: white,
      ),
    )
  )
)

== Combining Custom Styles

Mix and match style overrides:

#bdd(
  nodes: (
    (id: "x1", label: $x_1$),
    (id: "x2", label: $x_2$),
    (id: "0", terminal: false),
    (id: "1", terminal: true),
  ),
  edges: (
    ("x1", "0", low),
    ("x1", "x2", high),
    ("x2", "0", low),
    ("x2", "1", high),
  ),
  theme: "minimal",
  style: (
    decision: (
      fill: rgb("#E1F5FE"),
      stroke: rgb("#0277BD") + 1.5pt,
    ),
    edge: (
      high: (
        stroke: rgb("#00897B") + 1.5pt,
      ),
    ),
    spacing: (
      vertical: 2.2,
      horizontal: 1.8,
    )
  )
)
