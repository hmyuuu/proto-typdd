#import "../lib.typ": bdd, low, high

= Theme Showcase

The package includes three built-in themes. Compare them side by side:

#let example-nodes = (
  (id: "x1", label: $x_1$),
  (id: "x2a", label: $x_2$),
  (id: "x2b", label: $x_2$),
  (id: "0", terminal: false),
  (id: "1", terminal: true),
)

#let example-edges = (
  ("x1", "x2a", low),
  ("x1", "x2b", high),
  ("x2a", "0", low),
  ("x2a", "1", high),
  ("x2b", "0", low),
  ("x2b", "1", high),
)

#grid(
  columns: 3,
  gutter: 2em,
  row-gutter: 1em,
  [
    == Academic
    Clean, professional style for papers and presentations.

    #bdd(
      nodes: example-nodes,
      edges: example-edges,
      theme: "academic"
    )
  ],
  [
    == Colorful
    Vibrant colors for better visual distinction.

    #bdd(
      nodes: example-nodes,
      edges: example-edges,
      theme: "colorful"
    )
  ],
  [
    == Minimal
    Clean and simple with subtle styling.

    #bdd(
      nodes: example-nodes,
      edges: example-edges,
      theme: "minimal"
    )
  ]
)

= Theme Details

== Academic Theme
- Black and white color scheme
- Clean lines and professional appearance
- Ideal for academic papers and formal documents
- High contrast for printing

== Colorful Theme
- Blue decision nodes
- Red (false) and green (true) terminals
- Colored edges (red for low, blue for high)
- Great for presentations and teaching materials

== Minimal Theme
- Subtle gray tones
- Lightweight styling
- Modern and clean aesthetic
- Works well in documents with other visual elements

= Using Themes

Simply pass the theme name to the `theme` parameter:

```typst
#bdd(
  nodes: (...),
  edges: (...),
  theme: "colorful"
)
```

You can also start with a theme and customize specific aspects:

```typst
#bdd(
  nodes: (...),
  edges: (...),
  theme: "academic",
  style: (
    decision: (
      fill: blue.lighten(80%)
    )
  )
)
```
