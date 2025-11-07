#import "../lib.typ": bdd, low, high

= Declarative API Examples

The declarative API allows you to define your BDD by providing nodes and edges as data structures.

== Simple Example

#bdd(
  nodes: (
    (id: "root", label: $x$),
    (id: "left", label: $y$),
    (id: "right", label: $z$),
    (id: "0", terminal: false),
    (id: "1", terminal: true),
  ),
  edges: (
    ("root", "left", low),
    ("root", "right", high),
    ("left", "0", low),
    ("left", "1", high),
    ("right", "0", low),
    ("right", "1", high),
  )
)

== With Custom Theme

You can easily change the visual appearance by specifying a theme.

#grid(
  columns: 3,
  gutter: 1em,
  [
    === Academic
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
      theme: "academic"
    )
  ],
  [
    === Colorful
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
      theme: "colorful"
    )
  ],
  [
    === Minimal
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
      theme: "minimal"
    )
  ]
)

== Manual Positioning

For precise control, you can specify exact positions for each node.

#bdd(
  nodes: (
    (id: "x1", label: $x_1$),
    (id: "x2", label: $x_2$),
    (id: "x3", label: $x_3$),
    (id: "0", terminal: false),
    (id: "1", terminal: true),
  ),
  edges: (
    ("x1", "x2", low),
    ("x1", "x3", high),
    ("x2", "0", low),
    ("x2", "1", high),
    ("x3", "0", low),
    ("x3", "1", high),
  ),
  pos: (
    x1: (0, 0),
    x2: (-1.5, -2),
    x3: (1.5, -2),
    "0": (-1.5, -4),
    "1": (1.5, -4),
  )
)
