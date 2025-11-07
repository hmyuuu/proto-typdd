// Proof of concept: BDD with Fletcher vs current implementation
#import "@preview/fletcher:0.5.8" as fletcher: diagram, edge, node

= Fletcher vs CeTZ Comparison

== Using Fletcher

#diagram(
  node-stroke: 1pt,
  edge-stroke: 1pt,
  node((0, 0), [$x_1$], shape: fletcher.shapes.circle, name: <x1>),
  node((0, 1), [$x_2$], shape: fletcher.shapes.circle, name: <x2>),
  node((-1, 2), [0], shape: rect, name: <0>),
  node(
    (1, 2),
    text(fill: white)[1],
    fill: black,
    stroke: black,
    shape: rect,
    name: <1>,
  ),

  edge(<x1>, <x2>, "-", stroke: (dash: "dotted")), // low edge
  edge(<x1>, <0>, "->"), // high edge
  edge(<x2>, <0>, "-", stroke: (dash: "dotted")),
  edge(<x2>, <1>, "->"),
)

== Using Our Current Implementation

#import "@local/typdd:0.1.0": bdd, high, low

#bdd(
  nodes: (
    (id: "x1", label: $x_1$),
    (id: "x2", label: $x_2$),
    (id: "0", terminal: false),
    (id: "1", terminal: true),
  ),
  edges: (
    ("x1", "x2", low),
    ("x1", "0", high),
    ("x2", "0", low),
    ("x2", "1", high),
  ),
)

== Analysis

*Fletcher Pros:*
- Simpler coordinate system (grid-based)
- Automatic edge snapping (built-in)
- Less code for simple diagrams

*Fletcher Cons:*
- Manual positioning required for each node
- No automatic layout algorithm
- Less control over styling
- Would need to rebuild our theme system

*Current Implementation Pros:*
- Automatic layout (no manual positioning!)
- Three theme system built-in
- DSL with arrow syntax (`->`, `=>`)
- Domain-specific API for BDDs
- Better separation of structure and presentation

*Current Implementation Cons:*
- More complex under the hood
- Built on lower-level CeTZ

== Recommendation

Our current implementation is better for BDDs because:
1. Automatic layout saves users from manual positioning
2. DSL is more concise than Fletcher's approach
3. Domain-specific themes and styling
4. Fletcher would require manual coordinates for every node
