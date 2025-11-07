#import "../lib.typ": diagram, put, add, set-label, set-labels, render

= DSL API Examples

The DSL provides a concise arrow-based syntax for building BDDs.

== Arrow Syntax

- `->` represents a *low edge* (dotted line, variable = 0)
- `=>` represents a *high edge* (solid arrow, variable = 1)

== Basic Example

Simple BDD for $f(x_1, x_2) = x_1 and x_2$:

#let d = diagram()
#let d = put(d, "x1 -> 0")
#let d = put(d, "x1 => x2")
#let d = put(d, "x2 -> 0")
#let d = put(d, "x2 => 1")
#let d = set-labels(d, x1: $x_1$, x2: $x_2$)

#render(d)

== Compact Syntax

You can add multiple edges in one call:

#let d2 = diagram()
#let d2 = put(d2, "x1 -> 0", "x1 => x2")
#let d2 = put(d2, "x2 -> 0", "x2 => 1")
#let d2 = set-labels(d2, x1: $x_1$, x2: $x_2$)

#render(d2, theme: "colorful")

== OR Function

BDD for $f(x_1, x_2) = x_1 or x_2$:

#let d3 = diagram()
#let d3 = put(d3,
  "x1 -> x2", "x1 => 1",
  "x2 -> 0", "x2 => 1"
)
#let d3 = set-labels(d3, x1: $x_1$, x2: $x_2$)

#render(d3, theme: "minimal")

== With Predefined Labels

You can specify labels upfront:

#let d4 = diagram(labels: (
  x1: $x_1$,
  x2: $x_2$,
  x3: $x_3$,
))

#let d4 = add(d4,
  "x1 -> x2", "x1 => x3",
  "x2 -> 0", "x2 => 1",
  "x3 -> 0", "x3 => 1"
)

#render(d4)

== Complex Example

Three-variable function with multiple levels:

#let d5 = diagram(labels: (
  x1: $x_1$,
  x2a: $x_2$,
  x2b: $x_2$,
  x3: $x_3$,
))

#let d5 = put(d5,
  "x1 -> x2a", "x1 => x2b",
  "x2a -> 0", "x2a => x3",
  "x2b -> x3", "x2b => 1",
  "x3 -> 0", "x3 => 1"
)

#render(d5, theme: "colorful")

== Step-by-Step Construction

Build diagrams incrementally:

#let d6 = diagram()

// Add first level
#let d6 = put(d6, "root -> left", "root => right")

// Add second level
#let d6 = put(d6, "left -> 0", "left => 1")
#let d6 = put(d6, "right -> 0", "right => 1")

// Set labels
#let d6 = set-label(d6, "root", $x$)
#let d6 = set-label(d6, "left", $y$)
#let d6 = set-label(d6, "right", $z$)

#render(d6, theme: "academic")

== Custom Styling

The DSL supports all rendering options:

#let d7 = diagram(labels: (a: $a$, b: $b$))
#let d7 = put(d7, "a -> 0", "a => b", "b -> 0", "b => 1")

#render(d7,
  theme: "minimal",
  style: (
    decision: (
      fill: rgb("#E1F5FE"),
      stroke: rgb("#0277BD") + 2pt,
    ),
    spacing: (vertical: 2.5, horizontal: 2.0)
  )
)

== Advantages of DSL

*Concise*: Define edges without explicit node declarations

*Readable*: Arrow syntax clearly shows edge direction and type

*Flexible*: Mix and match `add()` and `put()` as needed

*Automatic*: Nodes and terminals inferred from edges

== Comparison

=== Traditional Declarative API
```typst
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
  )
)
```

=== DSL API
```typst
#let d = diagram(labels: (x1: $x_1$, x2: $x_2$))
#let d = put(d,
  "x1 -> 0", "x1 => x2",
  "x2 -> 0", "x2 => 1"
)
#render(d)
```

The DSL is ~50% shorter while remaining clear and expressive!
